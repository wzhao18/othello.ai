//
//  othelloApp.swift
//  Shared
//
//  Created by 提莫 on 2022-01-11.
//

import SwiftUI

@main
struct OthelloApp: App {
    var body: some Scene {
        let game = OthelloGameManager(dimension: 6)
        WindowGroup {
            OthelloGameView(game: game)
        }
    }
}
