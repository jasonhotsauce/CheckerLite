//
//  Board.swift
//  CheckerLite
//
//  Created by Wenbin Zhang on 3/23/16.
//  Copyright © 2016 Wenbin Zhang. All rights reserved.
//

import UIKit

struct MatrixIndex {
    var row: Int
    var column: Int
}

enum BoardMoveError: ErrorType {
    case Invalid
}

enum GameTurn {
    case Computer
    case Player
    
    mutating func toggle() {
        switch self {
        case .Computer:
            self = .Player
        case .Player:
            self = .Computer
        }
    }
}

protocol GamePlaying: class {
    func didKillCell(cell: Cell)
    func didMove(cell: Cell, toIndex index: MatrixIndex)
    func didGameOver()
}

final class Board: RefereeType {
    private var board: [[Cell?]]
    var user: Player
    var computer: Player
    let numOfRows: Int
    let numOfColumns: Int
    var turn: GameTurn = .Player {
        didSet {
            switch turn {
            case .Computer:
                makeComputerMove()
                break
            default:
                break
            }
        }
    }
    weak var delegate: GamePlaying?
    
    init(user: Player, computer: Player, row: Int, column: Int) {
        self.user = user
        self.computer = computer
        self.numOfRows = row
        self.numOfColumns = column
        board = Array(count: row, repeatedValue: [Cell?](count: column, repeatedValue: nil))
    }
    
    func cellAt(index: MatrixIndex) -> Cell? {
        if index.row < 0 || index.row >= numOfRows || index.column < 0 || index.column >= numOfColumns {
            return nil
        }
        return board[index.row][index.column]
    }
    
    func add(cell: Cell, atIndex: MatrixIndex) {
        board[atIndex.row][atIndex.column] = cell
    }
    
    func move(cell: Cell, toIndex index: MatrixIndex) throws {
        let (validMove, cellToKill) = canMove(cell, toIndex: index)
        if !validMove {
            throw BoardMoveError.Invalid
        }
        move(cell, toIndex: index, kill: cellToKill)
        if isGameOvered() {
            delegate?.didGameOver()
        }
    }

    func kill(cell: Cell, player: Player) {
        board[cell.row][cell.column] = nil
        player.score += 1
        delegate?.didKillCell(cell)
    }
    
    func canMove(cell: Cell, toIndex index: MatrixIndex) -> (Bool, Cell?) {
        if index.row < 0 || index.row >= numOfRows || index.column < 0 || index.column >= numOfColumns {
            return (false, nil)
        }
        if cell.row == index.row || cell.column == index.column {
            return (false, nil)
        }
        if let _ = cellAt(index) {
            return (false, nil)
        } else {
            let rowDelta = index.row - cell.row
            let columnDelta = index.column - cell.column
            if abs(rowDelta) == 1 && abs(columnDelta) == 1 {
                return (true, nil)
            } else if abs(rowDelta) == 2 && abs(columnDelta) == 2 {
                let checkRow = rowDelta > 0 ? cell.row + 1 : cell.row - 1
                let checkColumn = columnDelta > 0 ? cell.column + 1 : cell.column - 1
                guard let cellToKill = cellAt(MatrixIndex(row: checkRow, column: checkColumn)) where cellToKill.type != cell.type else {
                    return (false, nil)
                }
                return (true, cellToKill)
            }
            return (false, nil)
         }
    }
    
    func isGameOvered() -> Bool {
        return user.score == 8 || computer.score == 8
    }
    
    // MARK: Private
    private func move(cell: Cell, toIndex index: MatrixIndex, kill killCell: Cell?) {
        board[cell.row][cell.column] = nil
        var newCell = cell
        newCell.updateIndex(index.row, column: index.column)
        board[newCell.row][newCell.column] = newCell
        delegate?.didMove(cell, toIndex: index)
        if let cellToKill = killCell {
            kill(cellToKill, player: cellToKill.type == .Computer ? user : computer)
        }
    }

    private func makeComputerMove() {
        let computerCells = board.flatMap{$0.filter{$0?.type == .Computer}}.shuffle()
        let delta = [-2, 2, -1, 1].shuffle()
        for computerCell in computerCells {
            guard let validCell = computerCell else {
                continue
            }
            for rowStep in delta {
                let columnSteps = [rowStep, 0-rowStep]
                for columnStep in columnSteps {
                    let index = MatrixIndex(row: validCell.row + rowStep, column: validCell.column + columnStep)
                    let (validMove, cellToKill) = canMove(validCell, toIndex: index)
                    if validMove {
                        move(validCell, toIndex: index, kill: cellToKill)
                        if isGameOvered() {
                            delegate?.didGameOver()
                        }
                        return
                    }
                }
            }

        }
    }
}

extension Array {
    func shuffle() -> [Element] {
        var elements = self
        for index in indices where index < count.predecessor() {
            guard case let swapIndex = Int(arc4random_uniform(UInt32(count - index))) + index
                where swapIndex != index else {
                    continue
            }
            swap(&elements[index], &elements[swapIndex])
        }
        return elements
    }
}