//
//  ViewController.swift
//  CheckerLite
//
//  Created by Wenbin Zhang on 3/22/16.
//  Copyright © 2016 Wenbin Zhang. All rights reserved.
//

import UIKit
import QuartzCore

enum BoardViewError: ErrorType {
    case NotSetup
    case OutOfBounds
}

class ViewController: UIViewController {
    let numOfRowsInBoard = 8
    let numOfColumnsInBoard = 8
    
    var boardView: BoardView?
    var board: Board?
    var selectedChecker: CheckerView?
    var computerScoreLabel: UILabel!
    var playerScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGrayColor()
        setupGameBoard()
        setupScoreLabels()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
        boardView?.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func handleTap(gesture: UITapGestureRecognizer) {
        guard let checker = selectedChecker where board?.turn == .Player else {
            return
        }
        do {
            let index = try indexOf(checker)
            let position = gesture.locationInView(boardView)
            let moveToIndex = try indexOf(position)
            if let cell = board?.cellAt(index) {
                try board?.move(cell, toIndex: moveToIndex)
            }
        } catch BoardViewError.NotSetup {
            print("Board not setup")
        } catch BoardMoveError.Invalid {
            let alertControl = UIAlertController(title: NSLocalizedString("invalid_move_alert_title", comment: ""), message: NSLocalizedString("invalid_move_alert_message", comment: ""), preferredStyle: .Alert)
            alertControl.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Cancel, handler: nil))
            presentViewController(alertControl, animated: true, completion: nil)
        } catch BoardViewError.OutOfBounds {
            
        } catch {
        
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutBoardView(view.bounds.size)
        layoutScoreLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        layoutBoardView(size)
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

    // MARK: Private stuff
    private func setupScoreLabels() {
        computerScoreLabel = UILabel()
        playerScoreLabel = UILabel()
        computerScoreLabel.textColor = UIColor.whiteColor()
        computerScoreLabel.backgroundColor = UIColor.redColor()
        computerScoreLabel.textAlignment = .Center
        computerScoreLabel.text = "0"
        computerScoreLabel.layer.borderWidth = 0.5
        computerScoreLabel.layer.cornerRadius = 25
        computerScoreLabel.layer.borderColor = UIColor.redColor().CGColor
        computerScoreLabel.layer.masksToBounds = true

        playerScoreLabel.textColor = UIColor.whiteColor()
        playerScoreLabel.backgroundColor = UIColor.orangeColor()
        playerScoreLabel.textAlignment = .Center
        playerScoreLabel.text = "0"
        playerScoreLabel.layer.borderWidth = 0.5
        playerScoreLabel.layer.cornerRadius = 25
        playerScoreLabel.layer.borderColor = UIColor.orangeColor().CGColor
        playerScoreLabel.layer.masksToBounds = true

        view.addSubview(playerScoreLabel)
        view.addSubview(computerScoreLabel)
    }

    private func setupGameBoard() {
        let player1 = Player(withIdentifier: .Player)
        let player2 = Player(withIdentifier: .Computer)

        player1.scoreUpdateBlock = {[unowned self](score) in
            self.playerScoreLabel.text = String(score)
        }
        player2.scoreUpdateBlock = {[unowned self](score) in
            self.computerScoreLabel.text = String(score)
        }

        board = Board(user: player1, computer: player2, row: numOfRowsInBoard, column: numOfColumnsInBoard)
        board?.delegate = self
        
        boardView = BoardView(frame: CGRectZero, numOfRows: numOfRowsInBoard, numOfColumns: numOfColumnsInBoard)
        view.addSubview(boardView!)
        
        addCheckers()
    }
    
    private func addCheckers() {
        for row in 0..<2 {
            for column in 0..<numOfColumnsInBoard {
                if (row == 0 && column % 2 == 0) || (row == 1 && column % 2 != 0){
                    let checkerView = CheckerView(frame: CGRect(x: CGFloat(column) * boardView!.gridSize, y: CGFloat(row) * boardView!.gridSize, width:boardView!.gridSize, height: boardView!.gridSize), checkerColor: UIColor.redColor(), controllable: false)
                    checkerView.delegate = self
                    boardView?.addSubview(checkerView)
                    let cell = Cell(type: .Computer, color: UIColor.redColor(), row: row, column: column, cellView: checkerView)
                    board?.add(cell, atIndex: MatrixIndex(row: row, column: column))
                }
            }
        }
        
        for row in numOfRowsInBoard-2..<numOfRowsInBoard {
            for column in 0..<numOfColumnsInBoard {
                if (row == numOfRowsInBoard-2 && column % 2 == 0) || (row == numOfRowsInBoard - 1 && column % 2 != 0) {
                    let checkerView = CheckerView(frame: CGRect(x: CGFloat(column) * boardView!.gridSize, y: CGFloat(row) * boardView!.gridSize, width:boardView!.gridSize, height: boardView!.gridSize), checkerColor: UIColor.orangeColor(), controllable: true)
                    checkerView.delegate = self
                    boardView?.addSubview(checkerView)
                    let cell = Cell(type: .Player, color: UIColor.orangeColor(), row: row, column: column, cellView: checkerView)
                    board?.add(cell, atIndex: MatrixIndex(row: row, column: column))
                }
            }
        }
    }
    
    private func layoutBoardView(size: CGSize) {
        var boardSize = min(size.width, size.height)
        var boardOrigin = CGPointZero
        if size.width > size.height {
            boardSize = size.height
            boardOrigin.x = (size.width - size.height) / 2
        } else {
            boardSize = size.width
            boardOrigin.y = (size.height - size.width) / 2
        }
        boardView?.frame = CGRect(x: boardOrigin.x, y: boardOrigin.y, width: boardSize, height: boardSize)
        for row in 0..<numOfRowsInBoard {
            for column in 0..<numOfColumnsInBoard {
                if let cell = board?.cellAt(MatrixIndex(row: row, column: column)) {
                    cell.cellView.frame = CGRect(x: CGFloat(column) * boardView!.gridSize, y: CGFloat(row) * boardView!.gridSize, width:boardView!.gridSize, height: boardView!.gridSize)
                }
            }
        }
    }

    private func layoutScoreLabels() {
        computerScoreLabel.frame = CGRect(x: CGRectGetMinX(boardView!.frame)+8, y: CGRectGetMaxY(boardView!.frame) + 8.0, width: 50, height: 50)

        playerScoreLabel.frame = CGRect(x: CGRectGetMaxX(boardView!.frame) - 58, y: CGRectGetMaxY(boardView!.frame) + 8.0, width: 50, height: 50)
    }
    
    private func indexOf(checker: CheckerView) throws -> MatrixIndex {
        guard let validBoardView = boardView else {
            throw BoardViewError.NotSetup
        }
        let origin = checker.frame.origin
        let gridSize = validBoardView.gridSize

        let row = Int(origin.y / gridSize)
        let column = Int(origin.x / gridSize)
        return MatrixIndex(row: row, column: column)
    }
    
    private func indexOf(point: CGPoint) throws -> MatrixIndex {
        guard let validBoardView = boardView else {
            throw BoardViewError.NotSetup
        }
        if point.x < 0 || point.x > validBoardView.bounds.width || point.y < 0 || point.y > validBoardView.bounds.height {
            throw BoardViewError.OutOfBounds
        }
        let gridSize = validBoardView.gridSize
        let row = Int(point.y / gridSize)
        let column = Int(point.x / gridSize)
        return MatrixIndex(row: row, column: column)
    }
    
    private func switchPlayer() {
        self.board?.turn.toggle()
        self.selectedChecker?.selected = false
        self.selectedChecker = nil
    }
}

extension ViewController: GamePlaying {
    // MARK: GamePlaying
    func didKillCell(cell: Cell) {
        UIView.animateWithDuration(0.5, animations: {
            cell.cellView.alpha = 0.0
        }) { (finished) in
            cell.cellView.removeFromSuperview()
        }
    }

    func didMove(cell: Cell, toIndex index: MatrixIndex) {
        cell.cellView.userInteractionEnabled = false
        UIView.animateWithDuration(0.2, animations: {
            cell.cellView.frame = CGRect(x: CGFloat(index.column) * self.boardView!.gridSize, y: CGFloat(index.row) * self.boardView!.gridSize, width: self.boardView!.gridSize, height: self.boardView!.gridSize)
        }) { (finished) in
            cell.cellView.userInteractionEnabled = true
            self.switchPlayer()
        }
    }

    func didGameOver() {
        let alertView = UIAlertController(title: NSLocalizedString("game_over", comment: ""), message: NSLocalizedString("game_over_message", comment: ""), preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Cancel, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
}

extension ViewController: CheckerViewDelegate {
    // MARK: CheckerViewDelegate
    func didSelectChecker(checkerView: CheckerView) {
        guard board?.turn == .Player else {
            return
        }
        if let checker = selectedChecker where checker.isEqual(checkerView) {
            selectedChecker?.selected = false
            selectedChecker = nil
        } else {
            selectedChecker?.selected = false
            selectedChecker = checkerView
            selectedChecker?.selected = true
        }
    }
}
