//
//  RefereeType.swift
//  CheckerLite
//
//  Created by Wenbin Zhang on 3/22/16.
//  Copyright © 2016 Wenbin Zhang. All rights reserved.
//

import Foundation

protocol RefereeType {
    associatedtype C: CellType
    func canMove(cell: C, toIndex index: MatrixIndex) -> (Bool, C?)
    func isGameOvered() -> Bool
}

