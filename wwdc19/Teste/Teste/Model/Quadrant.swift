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
    
    private static let hasMargin: Bool = true
    private static let percentage: CGFloat = 0.2
    
    func coordinates(size: CGSize) -> CGPoint {
        let numberOfQuadrants = CGFloat(Quadrant.allCases.count)
        var x: CGFloat = (size.width / numberOfQuadrants) * (1.0 - Quadrant.percentage/3.0)
        var y: CGFloat = (size.height / numberOfQuadrants) * (1.0 - Quadrant.percentage/3.0)
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
        let marginPercentage: CGFloat = hasMargin ? percentage : 0.0
        return (1.0 - marginPercentage) / (CGFloat(self.allCases.count) / 2.0)
    }
}
