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
            (x, y) = (0, -y)
        case .fourth:
            (x, y) = (0, -y)
        }
        return CGPoint(x: x, y: y)
    }
    
    var scale: Scale {
        switch self {
        case .first, .second:
            let marginPercentage: CGFloat = Quadrant.hasMargin ? Quadrant.percentage : 0.0
            let scale = (1.0 - marginPercentage) / (CGFloat(Quadrant.allCases.count) / 2.0)
            return Scale(x: scale, y: scale)
        case .third, .fourth:
            let marginPercentage: CGFloat = Quadrant.hasMargin ? Quadrant.percentage : 0.0
            let yScale = (1.0 - marginPercentage) / (CGFloat(Quadrant.allCases.count) / 2.0)
            let xScale = (1.0 - marginPercentage*2/3)
            return Scale(x: xScale, y: yScale)
        }
    }

}
