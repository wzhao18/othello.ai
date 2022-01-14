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
    var body: some Scene {
        let game = OthelloGameManager(dimension: 4, num_players: 0)
        WindowGroup {
            OthelloGameView(game: game)
        }
    }
}
