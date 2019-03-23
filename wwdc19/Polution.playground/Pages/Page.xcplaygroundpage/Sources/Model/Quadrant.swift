//
//  Quadrant.swift
//  Teste
//
//  Created by Rodrigo Maximo on 23/03/19.
//  Copyright © 2019 Rodrigo Maximo. All rights reserved.
//

import CoreGraphics

enum Quadrant: CaseIterable {
    case first
    case second
    case third
    case fourth
    
    func coordinates(size: CGSize) -> CGPoint {
        var x: CGFloat = size.width / CGFloat(Quadrant.allCases.count)
        var y: CGFloat = size.height / CGFloat(Quadrant.allCases.count)
        switch self {
        case .first:
            (x, y) = (x, y)
        case .second:
            (x, y) = (-x, y)
        case .third:
            (x, y) = (-x, -y)
        case .fourth:
            (x, y) = (x, -y)
        }
        return CGPoint(x: x, y: y)
    }
    
    static var scale: CGFloat {
        return 1.0 / (CGFloat(self.allCases.count) / 2.0)
    }
}
