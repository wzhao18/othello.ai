//
//  static_table.swift
//  othello (iOS)
//
//  Created by 提莫 on 2022-01-16.
//

import Foundation

class StaticHeuristicTable {
    var static_tables: [Int : [[Int]]] =
        [8 : [[100, -20, 10, 5, 5, 10, -20, 100],
              [-20, -50, 1, 1, 1, 1, -50, -20],
              [10, 1, 2, 2, 2, 2, 1, 10],
              [5, 1, 2, 2, 2, 2, 1, 5],
              [5, 1, 2, 2, 2, 2, 1, 5],
              [10, 1, 2, 2, 2, 2, 1, 10],
              [-20, -50, 1, 1, 1, 1, -50, -20],
              [100, -20, 10, 5, 5, 10, -20, 100]]]

    func build_heuristic_table(dimension: Int) {
        var table = Array<Array<Int>>(repeating: Array<Int>(repeating: 1, count: dimension), count: dimension)
        
        if dimension > 4 {
            for i in 0..<dimension {
                for j in 0..<dimension {
                    if (i == 0 || i == dimension - 1) && (j == 0 || j == dimension - 1) {
                        table[i][j] = dimension * 5
                    } else if (i == 1 || i == dimension - 2) && (j == 0 || j == dimension - 1) {
                        table[i][j] = -Int((dimension * dimension) / 3)
                    } else if (j == 1 || j == dimension - 2) && (i == 0 || i == dimension - 1) {
                        table[i][j] = -Int((dimension * dimension) / 3)
                    } else if i == 0 || i == dimension - 1 {
                        if 1/3 * Double(dimension) <= Double(j) && Double(j) < 2/3 * Double(dimension) {
                            table[i][j] = dimension
                        } else {
                            table[i][j] = Int(1.5 * Double(dimension))
                        }
                    } else if j == 0 || j == dimension - 1 {
                        if 1/3 * Double(dimension) <= Double(i) && Double(i) < 2/3 * Double(dimension) {
                            table[i][j] = dimension
                        } else {
                            table[i][j] = Int(1.5 * Double(dimension))
                        }
                    } else if (i == 1 || i == dimension - 2) && (j == 1 || j == dimension - 2) {
                        table[i][j] = -dimension
                    } else {
                        if 1/3 * Double(dimension) <= Double(i) && Double(i) < 2/3 * Double(dimension) && 1/3 * Double(dimension) <= Double(j) && Double(j) < 2/3 * Double(dimension) {
                            table[i][j] = dimension / 2
                        } else {
                            table[i][j] = dimension / 3
                        }
                    }
                }
            }
        }
        
        print(table)
        
        self.static_tables[dimension] = table
    }
    
    func get_heuristic_value(dimension: Int, row: Int, col: Int) -> Int{
        if !static_tables.keys.contains(dimension){
            build_heuristic_table(dimension: dimension)
        }
        return static_tables[dimension]![row][col]
    }
}
