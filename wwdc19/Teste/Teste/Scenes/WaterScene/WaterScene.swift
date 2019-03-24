//
//  WaterScene.swift
//  Teste
//
//  Created by Rodrigo Maximo on 24/03/19.
//  Copyright © 2019 Rodrigo Maximo. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class WaterScene: SKScene, CustomScene {
    
    var backgroundNode: SKSpriteNode!
    var wasteNode1: SKSpriteNode!
    var wasteNode2: SKSpriteNode!
    var oceanNode1: SKSpriteNode!
    var oceanNode2: SKSpriteNode!
    var oceanNode3: SKSpriteNode!
    var oceanNode4: SKSpriteNode!
    var canNode1: SKSpriteNode!
    var canNode2: SKSpriteNode!
    var bottleNode: SKSpriteNode!
    var oilNode: SKSpriteNode!
    var fishNode1: SKSpriteNode!
    var fishNode2: SKSpriteNode!
    var fishNode3: SKSpriteNode!
    var trashNodes: [SKSpriteNode]!
    
    var objectsTouched: Int = 0
    var isNextLevel: Bool {
        return objectsTouched == 6
    }
    
    var selectionNode: SKSpriteNode!
    var backgroundCrop: SKSpriteNode!
    
    func load() {
        backgroundNode = self.childNode(withName: "backgroundNode") as? SKSpriteNode
        backgroundCrop = backgroundNode.childNode(withName: "backgroundCrop") as? SKSpriteNode
        wasteNode1 = backgroundCrop.childNode(withName: "wasteNode1") as? SKSpriteNode
        wasteNode2 = backgroundCrop.childNode(withName: "wasteNode2") as? SKSpriteNode
        oceanNode1 = backgroundCrop.childNode(withName: "oceanNode1") as? SKSpriteNode
        oceanNode2 = backgroundCrop.childNode(withName: "oceanNode2") as? SKSpriteNode
        oceanNode3 = backgroundCrop.childNode(withName: "oceanNode3") as? SKSpriteNode
        oceanNode4 = backgroundCrop.childNode(withName: "oceanNode4") as? SKSpriteNode
        canNode1 = backgroundCrop.childNode(withName: "canNode1") as? SKSpriteNode
        canNode2 = backgroundCrop.childNode(withName: "canNode2") as? SKSpriteNode
        bottleNode = backgroundCrop.childNode(withName: "bottleNode") as? SKSpriteNode
        oilNode = backgroundCrop.childNode(withName: "oilNode") as? SKSpriteNode
        fishNode1 = backgroundCrop.childNode(withName: "fishNode1") as? SKSpriteNode
        fishNode2 = backgroundCrop.childNode(withName: "fishNode2") as? SKSpriteNode
        fishNode3 = backgroundCrop.childNode(withName: "fishNode3") as? SKSpriteNode
        backgroundNode.isPaused = false
        trashNodes = [wasteNode1, wasteNode2, canNode1, canNode2, oilNode, bottleNode]
        cropBackground()
    }
    
    func triggerInitialActions() {
        animateWater()
        animateTrash()
    }
    
    private func animateWater() {
        let duration = Constants.Water.timeToAnimateWater
        let ocean1SequenceAction = sequenceAction(distanceX: Constants.Water.distanceWater1, distanceY: 0, duration: duration)
        let ocean2SequenceAction = sequenceAction(distanceX: Constants.Water.distanceWater2, distanceY: 0, duration: duration)
        let ocean3SequenceAction = sequenceAction(distanceX: Constants.Water.distanceWater3, distanceY: 0, duration: duration)
        let ocean4SequenceAction = sequenceAction(distanceX: Constants.Water.distanceWater4, distanceY: 0, duration: duration)
        oceanNode1.run(.repeatForever(ocean1SequenceAction))
        oceanNode2.run(.repeatForever(ocean2SequenceAction))
        oceanNode3.run(.repeatForever(ocean3SequenceAction))
        oceanNode4.run(.repeatForever(ocean4SequenceAction))
    }
    
    private func animateTrash() {
        let duration = Constants.Water.timeToAnimateWater
        let distance = Constants.Water.distanceTrash
        let action = sequenceAction(distanceX: distance, distanceY: distance, duration: duration)
        oilNode.run(.repeatForever(action))
        canNode1.run(.repeatForever(action))
        canNode2.run(.repeatForever(action))
        bottleNode.run(.repeatForever(action))
        fishNode1.run(.repeatForever(action))
        fishNode2.run(.repeatForever(action))
        fishNode3.run(.repeatForever(action))
    }
    
    private func sequenceAction(distanceX: CGFloat, distanceY: CGFloat, duration: TimeInterval) -> SKAction {
        let waterAction1 = SKAction.moveBy(x: -distanceX, y: -distanceY, duration: duration)
        let waterAction2 = SKAction.moveBy(x: distanceX, y: distanceY, duration: duration)
        let waterAction3 = SKAction.moveBy(x: distanceX, y: distanceY, duration: duration)
        let waterAction4 = SKAction.moveBy(x: -distanceX, y: -distanceY, duration: duration)
        return SKAction.sequence([waterAction1, waterAction2, waterAction3, waterAction4])
    }
    
    func touchTrash(node: SKNode, completion: ((Bool) -> Void)? = nil) {
        guard let node = node as? SKSpriteNode, trashNodes.contains(node) else {
            completion?(false)
            return
        }
        let hideAction = SKAction.fadeOut(withDuration: Constants.Water.timeToHideTrash)
        node.run(hideAction) { [weak self] in
            self?.objectsTouched += 1
            node.removeFromParent()
            completion?(true)
        }
    }
    
    func animateOceanCleaning(completion: Completion? = nil) {
        func texture(for ocean: Int, animationValue: Int) -> SKTexture {
            if animationValue == 7 {
                return SKTexture(imageNamed: "cleaned-ocean-\(String(ocean))")
            }
            return SKTexture(imageNamed: "ocean-\(String(ocean))-\(String(animationValue))")
        }
        
        var actions = [SKAction]()
        for ocean in 1...4 {
            var textures = [SKTexture]()
            for animationValue in 1...7 {
                textures.append(texture(for: ocean, animationValue: animationValue))
            }
            actions.append(SKAction.animate(with: textures, timePerFrame: Constants.Water.timeToChangeWater))
        }
        oceanNode1.run(actions[0])
        oceanNode2.run(actions[1])
        oceanNode3.run(actions[2])
        oceanNode4.run(actions[3])
        backgroundNode.run(.wait(forDuration: Constants.Water.timeToChangeWater * 7), completion: completion ?? {})
    }
    
    private func animateDeadFish(completion: Completion? = nil) {
        let duration = Constants.timeBetweenAnimations
        let fadeOutAction = SKAction.fadeOut(withDuration: duration)
        fishNode1.run(fadeOutAction)
        fishNode2.run(fadeOutAction)
        fishNode3.run(fadeOutAction)
        backgroundNode.run(.wait(forDuration: duration), completion: completion ?? {})
    }
    
    private func showLiveFish(completion: Completion? = nil) {
        
    }
}
