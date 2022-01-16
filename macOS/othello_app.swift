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
        game = OthelloGameManager(dimension: 5)
        let ai_agents = [AlphabetaAgent(agent_id: 0, game: game, timeout: 5.0), RandyAgent(agent_id: 1, game: game)]
        for ai_agent in ai_agents {
            ai_agent.start()
        }
    }
}
