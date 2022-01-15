//
//  ContentView.swift
//  Shared
//
//  Created by 提莫 on 2022-01-11.
//

import SwiftUI

struct GridStack<Content: View>: View {
    @Binding var matrix: [[Int]]
    var content: (Int, Int) -> Content

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< matrix.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0 ..< matrix[0].count, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}

struct board : View {
    @ObservedObject var game: OthelloGameManager

    var body: some View {
        VStack(spacing: 0) {
            GridStack(matrix: $game.matrix) { row, col in
                ZStack {
                    Rectangle()
                        .fill(Color.green)
                        .aspectRatio(1.0, contentMode: .fit)
                        .border(Color.gray)
                    if game.matrix[row][col] != -1 {
                        Circle()
                            .fill(game.matrix[row][col] == 0 ? Color.white : Color.black)
                            .aspectRatio(0.8, contentMode: .fit)
                    }
                }.onTapGesture {
                    game.play_move(i: row, j: col)
                }
            }.padding([.leading, .bottom, .trailing])
        }
    }
}

struct OthelloGameView: View {
    @ObservedObject var game: OthelloGameManager
    
    var body: some View {
        VStack {
            Text("Othello")
                .bold()
                .padding()
                .aspectRatio(contentMode: .fit)
                .onTapGesture {
                    print(game.matrix)
                }
            board(game: game);
            HStack {
                Button("start") {
                    game.reset()
                }.padding(.all)
            }
        }.frame(minWidth: 300, maxWidth: 500, minHeight: 300, maxHeight: 500, alignment: .center)
    }
}

struct OthelloGameViewPreview: PreviewProvider {
    static var previews: some View {
        let game = OthelloGameManager(dimension: 6)
        OthelloGameView(game: game)
    }
}
