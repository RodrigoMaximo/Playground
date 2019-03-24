//
//  Deforestation.swift
//  Teste
//
//  Created by Rodrigo Maximo on 24/03/19.
//  Copyright © 2019 Rodrigo Maximo. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class DeforestationScene: SKScene, CustomScene {
    
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
    var deadFishNode1: SKSpriteNode!
    var deadFishNode2: SKSpriteNode!
    var deadFishNode3: SKSpriteNode!
    var fishNode1: SKSpriteNode!
    var fishNode2: SKSpriteNode!
    var fishNode3: SKSpriteNode!
    var fishNode4: SKSpriteNode!
    var badSmellNode1: SKSpriteNode!
    var badSmellNode2: SKSpriteNode!
    var badSmellNode3: SKSpriteNode!
    var trashNodes: [SKSpriteNode]!
    
    var objectsTouched: Int = 0
    var isNextLevel: Bool {
        return objectsTouched == 2
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
        deadFishNode1 = backgroundCrop.childNode(withName: "deadFishNode1") as? SKSpriteNode
        deadFishNode2 = backgroundCrop.childNode(withName: "deadFishNode2") as? SKSpriteNode
        deadFishNode3 = backgroundCrop.childNode(withName: "deadFishNode3") as? SKSpriteNode
        fishNode1 = backgroundCrop.childNode(withName: "fishNode1") as? SKSpriteNode
        fishNode2 = backgroundCrop.childNode(withName: "fishNode2") as? SKSpriteNode
        fishNode3 = backgroundCrop.childNode(withName: "fishNode3") as? SKSpriteNode
        fishNode4 = backgroundCrop.childNode(withName: "fishNode4") as? SKSpriteNode
        badSmellNode1 = backgroundCrop.childNode(withName: "badSmellNode1") as? SKSpriteNode
        badSmellNode2 = backgroundCrop.childNode(withName: "badSmellNode2") as? SKSpriteNode
        badSmellNode3 = backgroundCrop.childNode(withName: "badSmellNode3") as? SKSpriteNode
        backgroundNode.isPaused = false
        trashNodes = [wasteNode1, wasteNode2, canNode1, canNode2, oilNode, bottleNode]
        cropBackground()
    }
    
    func triggerInitialActions() {
        animateBadSmell()
        animateWater()
        animateTrash()
        animateLiveFish()
    }
    
    private func animateBadSmell() {
        func actionBadSmell(initialPosition: CGPoint, distanceX: CGFloat, distanceY: CGFloat, duration: TimeInterval) -> SKAction {
            let actionMove = SKAction.moveBy(x: distanceX, y: distanceY, duration: duration)
            let actionFadeout = SKAction.fadeOut(withDuration: duration)
            let groupAction = SKAction.group([actionMove, actionFadeout])
            let actionInitialPosition = SKAction.move(to: initialPosition, duration: 0)
            let fadeInAction = SKAction.fadeIn(withDuration: duration/3)
            return SKAction.sequence([groupAction, actionInitialPosition, fadeInAction])
        }
        let duration = Constants.Water.timeBadSmell
        let actionSmell1 = actionBadSmell(initialPosition: badSmellNode1.position, distanceX: 0, distanceY: Constants.Water.distanceToBadSmell1, duration: duration)
        let actionSmell2 = actionBadSmell(initialPosition: badSmellNode2.position, distanceX: 0, distanceY: Constants.Water.distanceToBadSmell1, duration: duration)
        let actionSmell3 = actionBadSmell(initialPosition: badSmellNode3.position, distanceX: 0, distanceY: Constants.Water.distanceToBadSmell1, duration: duration)
        badSmellNode1.run(.repeatForever(actionSmell1))
        badSmellNode2.run(.repeatForever(actionSmell2))
        badSmellNode3.run(.repeatForever(actionSmell3))
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
        deadFishNode1.run(.repeatForever(action))
        deadFishNode2.run(.repeatForever(action))
        deadFishNode3.run(.repeatForever(action))
    }
    
    private func sequenceAction(distanceX: CGFloat, distanceY: CGFloat, duration: TimeInterval) -> SKAction {
        let action1 = SKAction.moveBy(x: -distanceX, y: -distanceY, duration: duration)
        let action2 = SKAction.moveBy(x: distanceX, y: distanceY, duration: duration)
        let action3 = SKAction.moveBy(x: distanceX, y: distanceY, duration: duration)
        let action4 = SKAction.moveBy(x: -distanceX, y: -distanceY, duration: duration)
        return SKAction.sequence([action1, action2, action3, action4])
    }
    
    private func animateLiveFish() {
        func actionFish(duration: TimeInterval, distanceX: CGFloat, distanceY: CGFloat) -> SKAction {
            let actionToRight = SKAction.moveBy(x: distanceX, y: distanceY, duration: duration)
            let actionToLeft = SKAction.moveBy(x: -distanceX, y: -distanceY, duration: duration)
            let actionTurnSide = SKAction.scaleX(to: -1, duration: duration/5)
            let actionTurnSideAgain = SKAction.scaleX(to: 1, duration: duration/5)
            return SKAction.sequence([actionToRight, actionTurnSide, actionToLeft, actionTurnSideAgain])
        }
        let duration1 = Constants.Water.timeToTravelFish1
        let distance1 = Constants.Water.distanceToTravelFish1
        let duration2 = Constants.Water.timeToTravelFish2
        let distance2 = Constants.Water.distanceToTravelFish2
        let duration3 = Constants.Water.timeToTravelFish3
        let distance3 = Constants.Water.distanceToTravelFish3
        let duration4 = Constants.Water.timeToTravelFish4
        let distance4 = Constants.Water.distanceToTravelFish4
        fishNode1.run(.repeatForever(actionFish(duration: duration1, distanceX: distance1, distanceY: 0)))
        fishNode2.run(.repeatForever(actionFish(duration: duration2, distanceX: distance2, distanceY: 0)))
        fishNode3.run(.repeatForever(actionFish(duration: duration3, distanceX: distance3, distanceY: 0)))
        fishNode4.run(.repeatForever(actionFish(duration: duration4, distanceX: distance4, distanceY: 0)))
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
        backgroundNode.run(.wait(forDuration: Constants.Water.timeToChangeWater * 7)) { [weak self] in
            self?.animateDeadFish()
            self?.stopAnimateBedSmall()
            self?.showLiveFish(completion: completion)
        }
    }
    
    private func animateDeadFish(completion: Completion? = nil) {
        let duration = Constants.timeBetweenAnimations
        let fadeOutAction = SKAction.fadeOut(withDuration: duration)
        deadFishNode1.run(fadeOutAction)
        deadFishNode2.run(fadeOutAction)
        deadFishNode3.run(fadeOutAction)
        backgroundNode.run(.wait(forDuration: duration)) {
            completion?()
        }
    }
    
    private func showLiveFish(completion: Completion? = nil) {
        let duration = Constants.timeBetweenAnimations
        let fadeInAction = SKAction.fadeIn(withDuration: duration)
        fishNode1.run(fadeInAction)
        fishNode2.run(fadeInAction)
        fishNode3.run(fadeInAction)
        fishNode4.run(fadeInAction)
        backgroundNode.run(.wait(forDuration: duration)) {
            completion?()
        }
    }
    
    private func stopAnimateBedSmall() {
        let fadeOutAction = SKAction.fadeOut(withDuration: Constants.timeBetweenAnimations)
        badSmellNode1.run(fadeOutAction)
        badSmellNode2.run(fadeOutAction)
        badSmellNode3.run(fadeOutAction)
        backgroundNode.run(.wait(forDuration: Constants.timeBetweenAnimations)) { [weak self] in
            self?.badSmellNode1.isPaused = true
            self?.badSmellNode2.isPaused = true
            self?.badSmellNode3.isPaused = true
        }
    }
}
