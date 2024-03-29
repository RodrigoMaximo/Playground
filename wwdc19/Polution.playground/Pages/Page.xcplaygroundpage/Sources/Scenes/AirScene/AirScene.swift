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
    var backgroundCrop: SKSpriteNode!
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
    var carsNode: [SKSpriteNode]!
    
    var isFactoryTouched: Bool = false
    var carsTouched: Int = 0
    var isNextLevel: Bool {
        return carsTouched == 3 && isFactoryTouched
    }
    
    var selectionNode: SKSpriteNode!
    
    func load() {
        backgroundNode = self.childNode(withName: "backgroundNode") as? SKSpriteNode
        backgroundCrop = backgroundNode.childNode(withName: "backgroundCrop") as? SKSpriteNode
        frontCarNode1 = backgroundCrop.childNode(withName: "frontCarNode1") as? SKSpriteNode
        frontCarNode2 = backgroundCrop.childNode(withName: "frontCarNode2") as? SKSpriteNode
        mediumCarNode1 = backgroundCrop.childNode(withName: "mediumCarNode1") as? SKSpriteNode
        mediumCarNode2 = backgroundCrop.childNode(withName: "mediumCarNode2") as? SKSpriteNode
        mediumCarNode3 = backgroundCrop.childNode(withName: "mediumCarNode3") as? SKSpriteNode
        behindCarNode1 = backgroundCrop.childNode(withName: "behindCarNode1") as? SKSpriteNode
        behindCarNode2 = backgroundCrop.childNode(withName: "behindCarNode2") as? SKSpriteNode
        behindCarNode3 = backgroundCrop.childNode(withName: "behindCarNode3") as? SKSpriteNode
        behindCarNode4 = backgroundCrop.childNode(withName: "behindCarNode4") as? SKSpriteNode
        skyNode = backgroundCrop.childNode(withName: "skyNode") as? SKSpriteNode
        factoryNode = backgroundCrop.childNode(withName: "factoryNode") as? SKSpriteNode
        treeNode1 = backgroundCrop.childNode(withName: "treeNode1") as? SKSpriteNode
        treeNode2 = backgroundCrop.childNode(withName: "treeNode2") as? SKSpriteNode
        treeNode3 = backgroundCrop.childNode(withName: "treeNode3") as? SKSpriteNode
        smokeNode = backgroundCrop.childNode(withName: "smokeNode") as? SKSpriteNode
        backgroundNode.isPaused = false
        carsNode = [frontCarNode1, frontCarNode2, mediumCarNode1, mediumCarNode2, mediumCarNode3, behindCarNode1, behindCarNode2, behindCarNode3, behindCarNode4]
        cropBackground()
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
    
    func touchFactory(completion: Completion? = nil) {
        let hideAction = SKAction.fadeOut(withDuration: Constants.Air.timeToHideFactory)
        smokeNode.run(hideAction)
        factoryNode.run(hideAction)
        let unHideTree = SKAction.fadeIn(withDuration: Constants.Air.timeToShowTree)
        treeNode1.run(unHideTree) { [weak self] in
            self?.treeNode2.run(unHideTree) {
                self?.treeNode3.run(unHideTree)
            }
        }
        backgroundNode.run(.wait(forDuration: Constants.Air.timeToSmoke)) { [weak self] in
            self?.isFactoryTouched = true
            completion?()
        }
    }
    
    func carNodeTouched(_ node: SKNode, completion: ((Bool) -> Void)? = nil) {
        guard let node = node as? SKSpriteNode, node.isPaused == false else {
            completion?(false)
            return
        }
        for carNode in carsNode where node == carNode {
            let fadeInaction = SKAction.fadeIn(withDuration: Constants.Air.timeToChangeCar)
            let fadeOutAction = SKAction.fadeOut(withDuration: Constants.Air.timeToChangeCar)
            carNode.run(fadeOutAction) { [weak self] in
                let random = Int.random(in: 1...4)
                let bikeTexture = SKTexture(imageNamed: "bike-\(random)")
                carNode.texture = bikeTexture
                carNode.run(fadeInaction) {
                    carNode.isPaused = true
                    self?.carsTouched += 1
                    completion?(true)
                }
            }
            return
        }
        completion?(false)
    }
    
    func animateCleanSky(completion: Completion?) {
        let textures = [
            SKTexture(imageNamed: "sky-bad-1"),
            SKTexture(imageNamed: "sky-bad-2"),
            SKTexture(imageNamed: "sky-bad-3"),
            SKTexture(imageNamed: "sky-good")
        ]
        skyNode.run(.animate(with: textures, timePerFrame: Constants.Air.timeToSkyChange)) {
            completion?()
        }
    }
    
}
