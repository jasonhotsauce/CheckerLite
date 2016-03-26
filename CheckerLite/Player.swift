//
//  Player.swift
//  CheckerLite
//
//  Created by Wenbin Zhang on 3/23/16.
//  Copyright © 2016 Wenbin Zhang. All rights reserved.
//

import Foundation

class Player {
    var score: Int {
        didSet {
            scoreUpdateBlock?(score)
        }
    }
    var identifier: CellIdentifierType
    var scoreUpdateBlock: ((Int) -> Void)?

    init(withIdentifier identifier: CellIdentifierType) {
        score = 0
        self.identifier = identifier
    }
}