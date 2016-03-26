//
//  CheckerView.swift
//  CheckerLite
//
//  Created by Wenbin Zhang on 3/22/16.
//  Copyright © 2016 Wenbin Zhang. All rights reserved.
//

import UIKit

protocol CheckerViewDelegate: class {
    func didSelectChecker(checkerView: CheckerView)
}

class CheckerView: UIView {
    var selected: Bool {
        didSet {
            alpha = selected ? 0.8 : 1.0
        }
    }
    private(set) var checkerColor: UIColor
    weak var delegate: CheckerViewDelegate?
    
    init(frame: CGRect, checkerColor: UIColor, controllable: Bool) {
        self.checkerColor = checkerColor
        selected = false
        super.init(frame: frame)
        if controllable {
            self.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(CheckerView.didTapCell(_:)))
            addGestureRecognizer(tap)
        }
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, checkerColor.CGColor)
        CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), rect.width/2, 0, CGFloat(M_PI * 2), 1)
        CGContextFillPath(context)
    }
    
    func didTapCell(gesture: UITapGestureRecognizer) {
        delegate?.didSelectChecker(self)
    }
}
