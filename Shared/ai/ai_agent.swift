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
    
    func compute_utility_score(board: [[Int]]) async -> Int {
        let score: (Int, Int) = await self.game.get_board_score(board: board)
        if self.agent_id == 0 {
            return score.0 - score.1
        } else {
            return score.1 - score.0
        }
    }
    
    @objc func play() async {
        print("Starting play loop")
        while (true) {
            if await !self.game.end {
                if await self.game.turn == self.agent_id {
                    let (i, j): (Int, Int) = await self.choose_move()
                    await self.game.play_move(i: i, j: j)
                }
            }
            await self.sleep(seconds: 3)
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
