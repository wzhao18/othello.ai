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
    @Binding var matrix: [[Int]]
    @Binding var turn: Int

    var body: some View {
        VStack(spacing: 0) {
            GridStack(matrix: $matrix) { row, col in
                ZStack {
                    Rectangle()
                        .fill(Color.green)
                        .aspectRatio(1.0, contentMode: .fit)
                        .border(Color.gray)
                    if matrix[row][col] != -1 {
                        Circle()
                            .fill(matrix[row][col] == 1 ? Color.black : Color.white)
                            .aspectRatio(0.8, contentMode: .fit)
                    }
                }.onTapGesture {
                    if matrix[row][col] == -1 {
                        matrix[row][col] = turn
                        turn = 1 - turn
                    }
                }
            }.padding([.leading, .bottom, .trailing])
        }
    }
}

struct OthelloGameView: View {
    @State var game: OthelloGameManager
    
    var body: some View {
        VStack {
            Text("Othello")
                .bold()
                .padding()
                .aspectRatio(contentMode: .fit)
                .onTapGesture {
                    print(game.matrix)
                }
            board(matrix: $game.matrix, turn: $game.turn);
        }.frame(minWidth: 300, maxWidth: 800, minHeight: 300, maxHeight: 800, alignment: .center)
    }
}

struct OthelloGameViewPreview: PreviewProvider {
    static var previews: some View {
        let game = OthelloGameManager(dimension: 6)
        OthelloGameView(game: game)
    }
}
