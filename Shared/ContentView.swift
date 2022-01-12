//
//  ContentView.swift
//  Shared
//
//  Created by 提莫 on 2022-01-11.
//

import SwiftUI

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0 ..< columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

struct ContentView: View {
    var matrix:[[Int]] = [
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
            GridStack(rows: matrix.count, columns: matrix[0].count) { row, col in
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
        }.frame(minWidth: 300, maxWidth: 800, minHeight: 300, maxHeight: 800, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
