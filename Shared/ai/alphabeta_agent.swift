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
    var limit: Int = -1
    
    init(agent_id: Int, game: OthelloGameManager, limit: Int) {
        super.init(agent_id: agent_id, game: game)
        self.limit = limit
    }
    
    override func choose_move() async -> (Int, Int) {
        return await alphabeta_selection(board: self.game.matrix, run_max: true, alpha: Int.min, beta: Int.max, limit: self.limit).0
    }
    
    func alphabeta_selection(board: [[Int]], run_max: Bool, alpha: Int, beta: Int, limit: Int) async -> ((Int, Int), Int) {
        if run_max && self.max_cache.keys.contains(board.description) && limit <= self.max_cache[board.description]!.1 {
            return self.max_cache[board.description]!.0
        } else if !run_max && self.min_cache.keys.contains(board.description) && limit <= self.min_cache[board.description]!.1 {
            return self.min_cache[board.description]!.0
        }
        
        var alpha = alpha
        var beta = beta
        var limit = limit
        var result: ((Int, Int), Int)
        let agent = run_max ? self.agent_id : 1 - self.agent_id
        let possible_moves: [(Int, Int)] = await self.game.get_possible_moves(board: board, turn: agent)
        
        if possible_moves.count == 0{
            limit = Int.max
            result = await ((-1, -1), compute_utility_score(board: board))
        } else if limit == 0 {
            return await (possible_moves.randomElement()!, compute_utility_score(board: board))
        } else {
            var best_move: (Int, Int)!
            var extreme_utility = run_max ? Int.min : Int.max

            for (row, col): (Int, Int) in possible_moves {
                let result_board = await self.game.get_matrix_after_play_move(board: board, i: row, j: col, turn: agent)
                let utility_value = await alphabeta_selection(board: result_board, run_max: !run_max, alpha: alpha, beta: beta, limit: limit - 1).1
                
                if (run_max && utility_value > extreme_utility) || (!run_max && utility_value < extreme_utility){
                        extreme_utility = utility_value
                        best_move = (row, col)
                }
                if (run_max && extreme_utility >= beta) || (!run_max && extreme_utility <= alpha) {
                    return (best_move, extreme_utility)
                }
                if run_max {
                    alpha = max(alpha, extreme_utility)
                } else {
                    beta = min(beta, extreme_utility)
                }
            }
            result = (best_move, extreme_utility)
        }
        
        if run_max && (!self.max_cache.keys.contains(board.description) || limit > self.max_cache[board.description]!.1){
            self.max_cache[board.description] = (result, limit)
        } else if !run_max && (!self.min_cache.keys.contains(board.description) || limit > self.min_cache[board.description]!.1) {
            self.min_cache[board.description] = (result, limit)
        }
        
        return result
    }
}
