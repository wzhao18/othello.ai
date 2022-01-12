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

    var body: some View {
        VStack(spacing: 0) {
            GridStack(matrix: $matrix) { row, col in
                ZStack {
                    Rectangle()
                        .fill(Color.green)
                        .aspectRatio(1.0, contentMode: .fit)
                        .border(Color.purple)
                    Circle()
                        .fill(matrix[row][col] == 0 ? Color.yellow : Color.white)
                        .aspectRatio(0.8, contentMode: .fit)
                    Text("Row\(row) Col\(col)")
                }
            }.padding([.leading, .bottom, .trailing])
        }
    }
}

struct ContentView: View {
    @State var matrix:[[Int]] = [
        [0, 1, 0, 1],
        [1, 1, 0, 1],
        [1, 0, 0, 0],
        [0, 1, 1, 0]
    ]
    
    var body: some View {
        VStack {
            Text("Othello")
                .padding()
                .aspectRatio(contentMode: .fit)
            board(matrix: $matrix);
            Button("button") {
                matrix[0][0] = 1 - matrix[0][0]
            }
        }.frame(minWidth: 300, maxWidth: 800, minHeight: 300, maxHeight: 800, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
