//
//  alphabeta_agent.swift
//  othello (iOS)
//
//  Created by 提莫 on 2022-01-14.
//

import Foundation

class AlphabetaAgent : OthelloAIAgent {
    var max_cache: [String : (((Int, Int), Int), Int)] = [:]
    var min_cache: [String : (((Int, Int), Int), Int)] = [:]
    var timeout: Double = Double.infinity
    let MAGICAL_TIMED_OUT_MOVE = (-5, -5)
    
    init(agent_id: Int, game: OthelloGameManager, timeout: Double) {
        super.init(agent_id: agent_id, game: game)
        self.timeout = timeout
    }
    
    override func choose_move() async -> (Int, Int) {
        let start = CFAbsoluteTimeGetCurrent()
        var limit = 1
        var final_move = await self.game.possible_moves.randomElement()!
        var remain_time = self.timeout - (CFAbsoluteTimeGetCurrent() - start)
        while remain_time > 0 {
            let ((move, _), reach_leaf_flag) = await alphabeta_selection(board: self.game.matrix, run_max: true, alpha: Int.min, beta: Int.max, limit: limit, timeout: remain_time)
            if move == MAGICAL_TIMED_OUT_MOVE {
                print("Failed to explore limit \(limit) - returning move")
                return final_move
            } else if reach_leaf_flag {
                print("Already exploring the leaves of the tree - returning move")
                return move
            }
            limit += 1
            final_move = move
            remain_time = self.timeout - (CFAbsoluteTimeGetCurrent() - start)
            print("Finished exploring limit \(limit - 1), remaining time \(remain_time)")
        }
        return final_move
    }
    
    func alphabeta_selection(board: [[Int]], run_max: Bool, alpha: Int, beta: Int, limit: Int, timeout: Double) async -> (((Int, Int), Int), Bool) {
        let start = CFAbsoluteTimeGetCurrent()
        
        let cache = run_max ? self.max_cache : self.min_cache
        if cache.keys.contains(board.description) {
            let (result, cache_limit) = cache[board.description]!
            if limit <= cache_limit {
                let reach_leaf_flag = cache_limit == Int.max
                return (result, reach_leaf_flag)
            }
        }
        
        var reach_leaf_flag = true
        var alpha = alpha
        var beta = beta
        var limit = limit
        var result: ((Int, Int), Int)
        let agent = run_max ? self.agent_id : 1 - self.agent_id
        let possible_moves: [(Int, Int)] = await self.game.get_possible_moves(board: board, turn: agent)
        
        var moves_board_map: [((Int, Int), [[Int]], Int)] = []
        for move in possible_moves {
            let result_board = await self.game.get_matrix_after_play_move(board: board, i: move.0, j: move.1, turn: agent)
            let move_board_score: ((Int, Int), [[Int]], Int) = await (move, result_board, compute_utility_score(board: result_board))
            moves_board_map.append(move_board_score)
        }
        if run_max {
            moves_board_map.sort {
                return $0.2 > $1.2
            }
        } else {
            moves_board_map.sort {
                return $0.2 < $1.2
            }
        }
        
        if possible_moves.count == 0{
            reach_leaf_flag = true
            result = await ((-1, -1), compute_utility_score(board: board))
        } else if limit == 0 {
            return await (((-1, -1), compute_utility_score(board: board)), false)
        } else {
            var best_move: (Int, Int)!
            var extreme_utility = run_max ? Int.min : Int.max

            for ((row, col), result_board, _): ((Int, Int), [[Int]], Int) in moves_board_map {
                let remain_time: Double = timeout - (CFAbsoluteTimeGetCurrent() - start)
                if remain_time <= 0 {
                    return ((MAGICAL_TIMED_OUT_MOVE, 0), false)
                }
                
                let ((child_move, utility_value), child_reach_leaf) = await alphabeta_selection(board: result_board, run_max: !run_max, alpha: alpha, beta: beta, limit: limit - 1, timeout: remain_time)
                if child_move == MAGICAL_TIMED_OUT_MOVE {
                    return ((MAGICAL_TIMED_OUT_MOVE, 0), false)
                }
                if !child_reach_leaf {
                    reach_leaf_flag = false
                }
                
                if (run_max && utility_value > extreme_utility) || (!run_max && utility_value < extreme_utility){
                        extreme_utility = utility_value
                        best_move = (row, col)
                }
                if (run_max && extreme_utility >= beta) || (!run_max && extreme_utility <= alpha) {
                    return ((best_move, extreme_utility), reach_leaf_flag)
                }
                if run_max {
                    alpha = max(alpha, extreme_utility)
                } else {
                    beta = min(beta, extreme_utility)
                }
            }
            result = (best_move, extreme_utility)
        }
        
        if reach_leaf_flag {
            limit = Int.max
        }
        
        if run_max && (!self.max_cache.keys.contains(board.description) || limit > self.max_cache[board.description]!.1){
            self.max_cache[board.description] = (result, limit)
        } else if !run_max && (!self.min_cache.keys.contains(board.description) || limit > self.min_cache[board.description]!.1) {
            self.min_cache[board.description] = (result, limit)
        }
        
        return (result, reach_leaf_flag)
    }
}
