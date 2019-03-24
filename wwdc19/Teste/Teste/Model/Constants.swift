//
//  Constants.swift
//  Teste
//
//  Created by Rodrigo Maximo on 23/03/19.
//  Copyright © 2019 Rodrigo Maximo. All rights reserved.
//

import Foundation
import CoreGraphics

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
    
    enum Water {
        static let timeToHideTrash: TimeInterval = 1.0
        static let timeToAnimateWater: TimeInterval = 1.0
        static let distanceWater1: CGFloat = 20
        static let distanceWater2: CGFloat = 8
        static let distanceWater3: CGFloat = 25
        static let distanceWater4: CGFloat = 25
        static let distanceTrash: CGFloat = 10
        static let timeToChangeWater: TimeInterval = 0.3
        static let timeToTravelFish1: TimeInterval = 2.0
        static let timeToTravelFish2: TimeInterval = 1.5
        static let timeToTravelFish3: TimeInterval = 1.0
        static let timeToTravelFish4: TimeInterval = 2.0
        static let distanceToTravelFish1: CGFloat = 50
        static let distanceToTravelFish2: CGFloat = 50
        static let distanceToTravelFish3: CGFloat = 50
        static let distanceToTravelFish4: CGFloat = 50
    }
}
