//
//  Player.swift
//  CheckerLite
//
//  Created by Wenbin Zhang on 3/22/16.
//  Copyright © 2016 Wenbin Zhang. All rights reserved.
//

import UIKit

protocol CellType {
    associatedtype IdentifierType: RawRepresentable
    var type: IdentifierType {get}
    var color: UIColor {get}
}