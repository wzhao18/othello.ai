//
//  othelloApp.swift
//  Shared
//
//  Created by 提莫 on 2022-01-11.
//

import SwiftUI
import Foundation

@main
struct OthelloApp: App {    
    var body: some Scene {
        let game = OthelloGameManager(dimension: 6, num_players: 0)
        WindowGroup {
            OthelloGameView(game: game)
        }
    }
}
