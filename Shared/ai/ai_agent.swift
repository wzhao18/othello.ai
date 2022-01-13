//
//  ai.swift
//  othello
//
//  Created by 提莫 on 2022-01-12.
//

import Foundation

class OthelloAIAgent {
    var agent_id: Int = -1
    var game: OthelloGameManager! = nil
    var thread: Thread! = nil
    
    func choose_random_move(moves: [(Int, Int)]) -> (Int, Int) {
        return moves[0]
    }
    
    @objc func play() async
    {
        print("Starting play loop")
        while (true) {
            if await self.game.turn == self.agent_id {
                let possible_moves: [(Int, Int)] = await self.game.possible_moves
                if possible_moves.count > 0 {
                    let random_move: (Int, Int) = choose_random_move(moves: possible_moves)
                    let (i, j): (Int, Int) = random_move
                    await self.game.play_move(i: i, j: j)
                }
            } else {
                do {
                    try await Task.sleep(nanoseconds: 1000000000)
                }
                catch {
                    print(error)
                }
            }
        }
    }
    
    init(agent_id: Int, game: OthelloGameManager) {
        self.agent_id = agent_id
        self.game = game
        self.thread = Thread.init(target: self, selector: #selector(play), object: nil)
    }
    
    func start() {
        print("AI player \(agent_id) is ready to play")
        self.thread.start()
    }
}
