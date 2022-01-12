//
//  othelloGameManager.swift
//  othello
//
//  Created by 提莫 on 2022-01-11.
//

import Foundation

struct OthelloGameManager {
    var dimension: Int
    var matrix: Array<Array<Int>>
    var turn = 0;
    
    init(dimension: Int) {
        self.dimension = dimension
        self.matrix = Array<Array<Int>>(repeating: Array<Int>(repeating: -1, count: self.dimension), count: dimension)
    }
    
    func find_line(i: Int, j: Int, turn: Int) {
        
    }
    
    func play_move(i: Int, j: Int, turn: Int) {
        
    }
}
