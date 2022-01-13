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
    
    @objc func play() async {
        print("Starting play loop")
        while (true) {
            if await !self.game.end {
                if await self.game.turn == self.agent_id {
                    let (i, j): (Int, Int) = await self.choose_move()
                    await self.game.play_move(i: i, j: j)
                }
            }
            await self.sleep(seconds: 0.1)
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
    
    func sleep(seconds: Double) async{
        do {
            try await Task.sleep(nanoseconds: UInt64(seconds * 1000000000))
        }
        catch {
            print(error)
        }
    }
    
    func choose_move() async -> (Int, Int) {
        fatalError("Unimplemented")
    }
}


class RandyAgent : OthelloAIAgent {
    override func choose_move() async -> (Int, Int) {
        let possible_moves: [(Int, Int)] = await self.game.possible_moves
        return possible_moves.randomElement()!
    }
}
