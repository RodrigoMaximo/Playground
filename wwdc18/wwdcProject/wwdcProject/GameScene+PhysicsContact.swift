//
//  PhysicsGameScene.swift
//  wwdcProject
//
//  Created by Rodrigo Maximo on 05/04/18.
//  Copyright © 2018 Alexandre Conti Mestre. All rights reserved.
//

import SpriteKit

extension GameScene: SKPhysicsContactDelegate {
    /// Method called every time a coontact is detected.
    ///
    /// - Parameter contact: Contact detected.
    func didBegin(_ contact: SKPhysicsContact) {
        // gets the first body as the body with minor Physics category value, and second body with the major one
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        // MARK: - Types of collision
        // man with step blocks
        let firstBodyIsMan = (firstBody.categoryBitMask & PhysicsCategory.man.rawValue != 0)
        let secondBodyIsBlock = (secondBody.categoryBitMask & PhysicsCategory.block.rawValue != 0)
        if firstBodyIsMan && secondBodyIsBlock {
            if let secondNode = secondBody.node as? SKSpriteNode {
                manColides(with: secondNode)
            }
        }
    }
    fileprivate func stairsNodeCollision() {
        stopsMan()
        manSadAction(sad: true) { [unowned self] in
            let label: SKLabelNode = self.firstInstructionTextLabel
            self.textToSpeech(textLabel: label)
            self.actionsInstance.animateText(from: label, charTimeInterval: self.const.timeToAnimateText,
                                             fadeInAction: self.fadeInAction) {
                                                self.activateArrow(self.arrowStairsNode)
                                                self.stairsInteraction = true
            }
        }
    }
    fileprivate func busStopNodeCollision() {
        stopsMan()
        busStopNode.removeFromParent()
        self.textToSpeech(textLabel: self.secondTextLabel)
        self.actionsInstance.animateText(from: self.secondTextLabel,
            charTimeInterval: self.const.timeToAnimateText,
            fadeInAction: self.fadeInAction) {
                self.moveBus {
                    self.manSadAction(sad: true, completion: {
                        let label: SKLabelNode = self.secondInstructionTextLabel
                        self.textToSpeech(textLabel: label)
                        self.actionsInstance.animateText(from: label,
                            charTimeInterval: self.const.timeToAnimateText,
                            fadeInAction: self.fadeInAction) {
                                self.activateArrow(self.arrowBusNode)
                                self.busNodeInteraction = true
                        }
                    })
                }
        }
    }
    fileprivate func platFormStopNodeCollision() {
        platformStopNode.removeFromParent()
        stopsMan()
        enterInBus(completion: {
            self.moveBusBoard()
            self.moveBus({
                self.leaveBus(completion: {
                    self.manMoveForward()
                })
            })
        })
    }
    fileprivate func finalStopNodeCollision() {
        stopsMan()
        self.textToSpeech(textLabel: self.thirdTextLabel)
        self.actionsInstance.animateText(from: self.thirdTextLabel,
                                         charTimeInterval: self.const.timeToAnimateText,
                                         fadeInAction: self.fadeInAction) {
                self.manSadAction(sad: true) { [unowned self] in
                    let label: SKLabelNode = self.thirdInstructionTextLabel
                    self.textToSpeech(textLabel: label)
                    self.actionsInstance.animateText(from: label,
                                                     charTimeInterval: self.const.timeToAnimateText,
                                                     fadeInAction: self.fadeInAction) {
                                                        self.activateArrow(self.arrowfinalNode)
                                                        self.finalGroundInteraction = true
                    }
            }
        }
    }
    func manColides(with node: SKSpriteNode) {
        switch node {
        case stairsStopNode:
            stairsNodeCollision()
        case finalScene1Node:
            changeScene(nextSceneNumber: .secondScene) {}
        case busStopNode:
            busStopNodeCollision()
        case platformStopNode:
            platFormStopNodeCollision()
        case finalScene2Node:
            changeScene(nextSceneNumber: .thirdScene) {}
        case finalStopNode:
            finalStopNodeCollision()
        case afterSceneStopNode:
            stopsMan()
            finalAnimation()
        default:
            break
        }
    }
}
