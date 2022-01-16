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
        game = OthelloGameManager(dimension: 4)
        let ai_agents = [AlphabetaAgent(agent_id: 0, game: game, timeout: 10.0), AlphabetaAgent(agent_id: 1, game: game, timeout: 10.0)]
        for ai_agent in ai_agents {
            ai_agent.start()
        }
    }
}
