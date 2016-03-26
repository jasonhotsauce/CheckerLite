//
//  Player.swift
//  CheckerLite
//
//  Created by Wenbin Zhang on 3/23/16.
//  Copyright © 2016 Wenbin Zhang. All rights reserved.
//

import UIKit

enum CellIdentifierType: Int {
    case Computer
    case Player
}

struct Cell: CellType {
    var type: CellIdentifierType
    var color: UIColor
    var row: Int
    var column: Int
    var cellView: UIView
    
    mutating func updateIndex(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
}