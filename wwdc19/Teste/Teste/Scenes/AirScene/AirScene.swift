//
//  AirScene.swift
//  Teste
//
//  Created by Rodrigo Maximo on 24/03/19.
//  Copyright © 2019 Rodrigo Maximo. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class AirScene: SKScene, CustomScene {
    
    var backgroundNode: SKSpriteNode!
    var frontCardNode1: SKSpriteNode!
    var frontCardNode2: SKSpriteNode!
    
    func load() {
        backgroundNode = self.childNode(withName: "backgroundNode") as? SKSpriteNode
        frontCardNode1 = backgroundNode.childNode(withName: "frontCardNode1") as? SKSpriteNode
        frontCardNode2 = backgroundNode.childNode(withName: "frontCardNode2") as? SKSpriteNode
        backgroundNode.isPaused = false
    }
}
