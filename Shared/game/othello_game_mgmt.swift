//
//  othelloGameManager.swift
//  othello
//
//  Created by 提莫 on 2022-01-11.
//

import Foundation

@MainActor class OthelloGameManager : ObservableObject{
    var dimension: Int = 0
    var num_players: Int = 0
    @Published var turn: Int = 0
    @Published var matrix: [[Int]] = []
    var possible_moves: [(Int, Int)] = []
    var end: Bool = false
    var ai_agents: [OthelloAIAgent] = []
    
    func init_board () {
        self.matrix = Array<Array<Int>>(repeating: Array<Int>(repeating: -1, count: self.dimension), count: dimension)
        let i = self.dimension / 2 - 1
        let j = self.dimension / 2 - 1
        self.matrix[i][j] = 1
        self.matrix[i + 1][j + 1] = 1
        self.matrix[i + 1][j] = 0
        self.matrix[i][j + 1] = 0
    }
    
    func reset() {
        self.turn = 1
        self.init_board()
        self.possible_moves = get_possible_moves(turn: self.turn)
        self.end = false
    }
    
    init(dimension: Int, num_players: Int) {
        self.dimension = dimension
        self.num_players = num_players
        self.reset()
        for i in 0..<(2-self.num_players) {
            let ai_agent = RandyAgent(agent_id: i, game: self)
            self.ai_agents.append(ai_agent)
            ai_agent.start()
        }
    }
    
    func get_possible_moves(turn: Int) -> [(Int, Int)] {
        var result: [(Int, Int)] = []
        for i in 0..<matrix.count {
            for j in 0..<matrix.count {
                if matrix[i][j] == -1 {
                    let lines: [[(Int, Int)]] = find_lines(i: i, j: j, turn: turn)
                    if lines.count > 0 {
                        result.append((i, j))
                    }
                }
            }
        }
        return result
    }
    
    func find_lines(i: Int, j: Int, turn: Int) -> [[(Int, Int)]]{
        var lines: [[(Int, Int)]] = []
        for (xdir, ydir) in [(0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1),
                    (-1, 0), (-1, 1)] {
            var u = i + xdir
            var v = j + ydir
            var line: [(Int, Int)] = []
            var found = false
            
            while u >= 0 && u < matrix.count && v >= 0 && v < matrix.count {
                if matrix[u][v] == -1 {
                    break
                } else if matrix[u][v] == turn{
                    found = true
                    break
                } else {
                    line.append((u, v))
                }
                u += xdir
                v += ydir
            }
            if found && line.count > 0 {
                lines.append(line)
            }
        }
        return lines
    }
    
    func exchange_turns() {
        self.possible_moves = get_possible_moves(turn: 1 - self.turn)
        if self.possible_moves.count == 0 {
            self.end = true
            let (white_score, black_score): (Int, Int) = get_current_score()
            print("game over", white_score > black_score ? "white wins" : "black wins")
        }
        self.turn = 1 - self.turn
    }
    
    func get_current_score() -> (Int, Int){
        var white_score: Int = 0
        var black_score: Int = 0
        for i in 0..<matrix.count {
            for j in 0..<matrix.count {
                if matrix[i][j] == 0 {
                    white_score += 1
                } else if (matrix[i][j] == 1) {
                    black_score += 1
                }
            }
        }
        return (white_score, black_score)
    }
    
    func valid_move(i: Int, j: Int) -> Bool {
        return self.possible_moves.contains(where: { (x, y) in
            return x == i && y == j
        })
    }
    
    func play_move(i: Int, j: Int) {
        if !valid_move(i: i, j: j) {
            if !self.end {
                print("Invalid Move")
            }
            return
        }
        print(self.turn == 0 ? "white" : "black", "takes move at (\(i), \(j))")
        let lines: [[(Int, Int)]] = find_lines(i: i, j: j, turn: self.turn)
        matrix[i][j] = turn
        for line in lines {
            for (u, v) in line {
                matrix[u][v] = turn
            }
        }
        let (white_score, black_score): (Int, Int) = get_current_score()
        print("Score: white \(white_score) : black \(black_score)")
        exchange_turns()
    }
}
