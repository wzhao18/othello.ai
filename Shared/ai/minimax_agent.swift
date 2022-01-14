//
//  minimax_agent.swift
//  othello (iOS)
//
//  Created by 提莫 on 2022-01-14.
//

import Foundation

class MinimaxAgent : OthelloAIAgent {
    
    func minimax_min_node(board: [[Int]]) async -> ((Int, Int), Int) {
        var best_move: (Int, Int)! = nil
        let possible_moves: [(Int, Int)] = await self.game.get_possible_moves(board: board, turn: 1 - self.agent_id)
        
        if possible_moves.count == 0 {
            return await ((-1, -1), compute_utility_score(board: board))
        }
        
        var lowest_utility = Int.max
        for (row, col): (Int, Int) in possible_moves {
            let result_board = await self.game.get_matrix_after_play_move(board: board, i: row, j: col, turn: 1 - self.agent_id)
            let maxi = await minimax_max_node(board: result_board).1
            if maxi < lowest_utility {
                lowest_utility = maxi
                best_move = (row, col)
            }
        }
        
        return (best_move, lowest_utility)
    }
    
    func minimax_max_node(board: [[Int]]) async -> ((Int, Int), Int) {
        var best_move: (Int, Int)! = nil
        let possible_moves: [(Int, Int)] = await self.game.get_possible_moves(board: board, turn: self.agent_id)
        
        if possible_moves.count == 0 {
            return await ((-1, -1), compute_utility_score(board: board))
        }
        
        var highest_utility = Int.min
        for (row, col): (Int, Int) in possible_moves {
            let result_board = await self.game.get_matrix_after_play_move(board: board, i: row, j: col, turn: self.agent_id)
            let mini = await minimax_min_node(board: result_board).1
            
            if mini > highest_utility {
                highest_utility = mini
                best_move = (row, col)
            }
        }
        
        return (best_move, highest_utility)
    }
    
    override func choose_move() async -> (Int, Int) {
        return await minimax_max_node(board: self.game.matrix).0
    }
}
