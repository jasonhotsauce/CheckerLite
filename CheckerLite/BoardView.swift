//
//  BoardView.swift
//  CheckerLite
//
//  Created by Wenbin Zhang on 3/22/16.
//  Copyright © 2016 Wenbin Zhang. All rights reserved.
//

import UIKit

class BoardView: UIView {
    var numOfRows: Int
    var numOfColumns: Int
    
    init(frame: CGRect, numOfRows: Int, numOfColumns: Int) {
        self.numOfRows = numOfRows
        self.numOfColumns = numOfColumns
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func calculateGridSize() -> CGFloat {
        return  frame.width / 8.0
    }
    
    override func drawRect(rect: CGRect) {
        let gridSize = calculateGridSize()
        let context = UIGraphicsGetCurrentContext()
        for row in 0..<numOfRows {
            for column in 0..<numOfColumns {
                var color: UIColor
                if row % 2 == 0 {
                    if column % 2 == 0 {
                        color = UIColor.blackColor()
                    } else {
                        color = UIColor.whiteColor()
                    }
                } else {
                    if column % 2 != 0 {
                        color = UIColor.blackColor()
                    } else {
                        color = UIColor.whiteColor()
                    }
                }
                CGContextSaveGState(context)
                let rect = CGRect(x: CGFloat(column)*gridSize, y: CGFloat(row)*gridSize, width: gridSize, height: gridSize)
                CGContextAddRect(context, rect)
                CGContextSetFillColorWithColor(context, color.CGColor)
                CGContextFillRect(context, rect)
                CGContextRestoreGState(context)
            }
        }
    }

}
