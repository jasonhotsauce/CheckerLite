//
//  ViewController.swift
//  CheckerLite
//
//  Created by Wenbin Zhang on 3/22/16.
//  Copyright © 2016 Wenbin Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let boardView = BoardView(frame: CGRectZero, numOfRows: 8, numOfColumns: 8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGrayColor()
        view.addSubview(boardView)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureBoardView(view.bounds.size)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        configureBoardView(size)
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

    // MARK: Private stuff
    private func configureBoardView(size: CGSize) {
        var boardSize = min(size.width, size.height)
        var boardOrigin = CGPointZero
        if size.width > size.height {
            boardSize = size.height
            boardOrigin.x = (size.width - size.height) / 2
        } else {
            boardSize = size.width
            boardOrigin.y = (size.height - size.width) / 2
        }
        boardView.frame = CGRect(x: boardOrigin.x, y: boardOrigin.y, width: boardSize, height: boardSize)
    }
}

