//
//  randy_agent.swift
//  othello (iOS)
//
//  Created by 提莫 on 2022-01-14.
//

import Foundation

class RandyAgent : OthelloAIAgent {
    override func choose_move() async -> (Int, Int) {
        let possible_moves: [(Int, Int)] = await self.game.possible_moves
        return possible_moves.randomElement()!
    }
}


























