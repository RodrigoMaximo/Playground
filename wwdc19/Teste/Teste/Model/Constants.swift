//
//  Constants.swift
//  Teste
//
//  Created by Rodrigo Maximo on 23/03/19.
//  Copyright © 2019 Rodrigo Maximo. All rights reserved.
//

import Foundation

enum Constants {
    static let timeBetweenAnimations: TimeInterval = 1.0
    enum Planet {
        static let timeInStageAnimation: TimeInterval = 1.0
        static let timeToCenter: TimeInterval = 1.5
        static let timeToOrigin: TimeInterval = 1.5
    }
    enum Air {
        static let timeToSmoke: TimeInterval = 1.0
        static let timeToHideFactory: TimeInterval = 1.0
        static let timeToShowTree: TimeInterval = 0.3
        static let timeToChangeCar: TimeInterval = 0.5
        static let timeToSkyChange: TimeInterval = 0.5
    }
}
