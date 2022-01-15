//
//  othelloApp.swift
//  Shared
//
//  Created by 提莫 on 2022-01-11.
//

import SwiftUI

@main
struct OthelloApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let game: OthelloGameManager
    var body: some Scene {
        WindowGroup {
            OthelloGameView(game: game)
        }
    }
    
    init() {
        game = OthelloGameManager(dimension: 6)
        let ai_agents = [RandyAgent(agent_id: 0, game: game), AlphabetaAgent(agent_id: 1, game: game, limit: 9)]
        for ai_agent in ai_agents {
            ai_agent.start()
        }
    }
}
