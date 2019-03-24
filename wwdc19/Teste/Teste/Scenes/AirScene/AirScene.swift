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
    var frontCarNode1: SKSpriteNode!
    var frontCarNode2: SKSpriteNode!
    var mediumCarNode1: SKSpriteNode!
    var mediumCarNode2: SKSpriteNode!
    var mediumCarNode3: SKSpriteNode!
    var behindCarNode1: SKSpriteNode!
    var behindCarNode2: SKSpriteNode!
    var behindCarNode3: SKSpriteNode!
    var behindCarNode4: SKSpriteNode!
    var skyNode: SKSpriteNode!
    var factoryNode: SKSpriteNode!
    var treeNode1: SKSpriteNode!
    var treeNode2: SKSpriteNode!
    var treeNode3: SKSpriteNode!
    var smokeNode: SKSpriteNode!
    
    func load() {
        backgroundNode = self.childNode(withName: "backgroundNode") as? SKSpriteNode
        frontCarNode1 = backgroundNode.childNode(withName: "frontCarNode1") as? SKSpriteNode
        frontCarNode2 = backgroundNode.childNode(withName: "frontCarNode2") as? SKSpriteNode
        mediumCarNode1 = backgroundNode.childNode(withName: "mediumCarNode1") as? SKSpriteNode
        mediumCarNode2 = backgroundNode.childNode(withName: "mediumCarNode2") as? SKSpriteNode
        mediumCarNode3 = backgroundNode.childNode(withName: "mediumCarNode3") as? SKSpriteNode
        behindCarNode1 = backgroundNode.childNode(withName: "behindCarNode1") as? SKSpriteNode
        behindCarNode2 = backgroundNode.childNode(withName: "behindCarNode2") as? SKSpriteNode
        behindCarNode3 = backgroundNode.childNode(withName: "behindCarNode3") as? SKSpriteNode
        behindCarNode4 = backgroundNode.childNode(withName: "behindCarNode4") as? SKSpriteNode
        skyNode = backgroundNode.childNode(withName: "skyNode") as? SKSpriteNode
        factoryNode = backgroundNode.childNode(withName: "factoryNode") as? SKSpriteNode
        treeNode1 = backgroundNode.childNode(withName: "treeNode1") as? SKSpriteNode
        treeNode2 = backgroundNode.childNode(withName: "treeNode2") as? SKSpriteNode
        treeNode3 = backgroundNode.childNode(withName: "treeNode3") as? SKSpriteNode
        smokeNode = backgroundNode.childNode(withName: "smokeNode") as? SKSpriteNode
        backgroundNode.isPaused = false
    }
    
    func triggerInitialActions() {
        animateSmoke()
    }
    
    func animateSmoke() {
        let imageName = "smoke"
        let initialTexture = SKTexture(imageNamed: "\(imageName)-1")
        let textures = [
            SKTexture(imageNamed: "\(imageName)-2"),
            SKTexture(imageNamed: "\(imageName)-3"),
            SKTexture(imageNamed: "\(imageName)-4"),
            SKTexture(imageNamed: "\(imageName)-5"),
            SKTexture(imageNamed: "\(imageName)-6"),
            SKTexture(imageNamed: "\(imageName)-1")
        ]
        smokeNode.texture = initialTexture
        let textureAction = SKAction.animate(with: textures, timePerFrame: Constants.Air.timeToSmoke)
        smokeNode.run(SKAction.repeatForever(textureAction))
    }
}
