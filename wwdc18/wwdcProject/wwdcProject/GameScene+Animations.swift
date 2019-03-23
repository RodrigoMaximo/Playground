//
//  GameScene+Animations.swift
//  wwdcProject
//
//  Created by Rodrigo Maximo on 05/04/18.
//  Copyright © 2018 Alexandre Conti Mestre. All rights reserved.
//

import SpriteKit

extension GameScene {
    // MARK: - Entities behaviors
    /// Move forward and animating the wheels.
    func manMoveForward() {
        let manMovementForwardSpeed = 100
        manNode.run(rotateWheelAnimation)
        wheelChairAudioNode.run(SKAction.play())
        manNode.physicsBody?.velocity = CGVector(dx: manMovementForwardSpeed, dy: 0)
    }
    /// Transform the stairs making it possible to use by the man.
    func transformStairs(_ completion: (() -> Void)?) {
        let position = starEffect.position
        starEffect = SKEmitterNode(fileNamed: "StarEffect")
        starEffect.zPosition = 10
        starEffect.position = position
        gameSceneNode.addChild(starEffect)
        // building sound
        stairsNode.run(solvingSound)
        stairsNode.run(stairsAnimation) { [unowned self] in
            self.stairsStopNode.removeFromParent()
            self.starEffect.removeFromParent()
            if let completionHandler = completion {
                completionHandler()
            }
        }
    }
    /// Move the bus to the bus point in the scene.
    ///
    /// - Parameter completion: Completion handler called after the bus have stopped and have opened its doors.
    func moveBus(_ completion: (() -> Void)?) {
        busNode.run(busSoundAction)
        busNode.run(busHornSoundAction)
        busNode.isHidden = false
        busNode.run(SKAction.sequence([waitAction, waitAction, busMoveAnimation])) {
            // stops the wheels and open the bus door
            self.busBehindWheelNode.removeAllActions()
            self.busFrontWheelNode.removeAllActions()
            self.run(SKAction.wait(forDuration: self.const.timeToWaitBeforeAction)) {
                self.busNode.run(self.busOpenDoorAnimation) {
                    if let completionHandler = completion {
                        completionHandler()
                    }
                }
            }
        }
        busBehindWheelNode.run(SKAction.repeatForever(busWheelMoveAnimation))
        busFrontWheelNode.run(SKAction.repeatForever(busWheelMoveAnimation))
    }
    /// Move the bus board to left direction, in order to simulate the bus is moving forward.
    func moveBusBoard() {
        let vector = CGVector(dx: -300, dy: 0)
        let action = SKAction.move(by: vector, duration: const.timeToBusArrives)
        action.timingMode = .easeIn
        self.busBoard.run(action)
    }
    func changeScene(nextSceneNumber: SceneNumber, completion: (() -> Void)?) {
        let currentX = gameSceneNode.position.x
        let currentY = gameSceneNode.position.y
        guard let scene = self.scene else { return }
        let width = scene.size.width
        let moveLeftAction = SKAction.move(to: CGPoint(x: currentX-width, y: currentY),
                                           duration: const.timeToChangeScene)
        gameSceneNode.run(moveLeftAction) {
            if let completionHandler = completion {
                completionHandler()
            }
        }
        if nextSceneNumber == .secondScene {
            finalScene1Node.removeFromParent()
        } else if nextSceneNumber == .thirdScene {
            finalScene2Node.removeFromParent()
        }
    }
    /// Stops the man and run the sad animation.
    func stopsMan() {
        manNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        manNode.removeAllActions()
        wheelChairAudioNode.run(SKAction.pause())
    }
    /// Wait for timeToWaitBeforeAction and makes the man be sad.
    func manSadAction(sad: Bool, completion: (() -> Void)?) {
        var animation: SKAction = self.sadAnimation
        var text: String = const.sadEmotionText
        if !sad {
            animation = self.sadAnimationReversed
            text = const.happyEmotionText
        }
        self.emotionLabel.text = text
        manNode.run(waitAction) {
            self.manNode.run(animation) {
                self.thoughtnessNode.run(self.thoughtnessAnimation) {
                    self.manNode.run(self.feelingSoundAction)
                    self.emotionLabel.run(self.fadeInAction) {
                        self.thoughtnessNode.run(SKAction.sequence([self.waitAction, self.fadeOutAction])) {
                            self.thoughtnessNode.texture = SKTexture(imageNamed: "thought-bubble-1")
                            self.emotionLabel.alpha = 0
                            if let completionHandler = completion {
                                completionHandler()
                            }
                        }
                    }
                }
            }
        }
    }
    func activateArrow(_ arrowNode: SKSpriteNode) {
        arrowNode.isHidden = false
        arrowNode.run(arrowMovementAction(arrowNode))
        arrowNode.run(arrowScaleAction)
    }
    func disableArrow(_ arrowNode: SKSpriteNode) {
        arrowNode.isHidden = true
        arrowNode.removeAllActions()
    }
    func arrowMovementAction(_ arrowNode: SKSpriteNode) -> SKAction {
        let angle = arrowNode.zRotation
        let position = arrowNode.position
        // if the angle is zero, the arrow will move in y axe, in case angle is pi/2, the arrow will move in x axe
        let newX = position.x + (const.distanceMoveArrow * cos(.pi/2 - angle))
        let newY = position.y - (const.distanceMoveArrow * sin(.pi/2 - angle))
        let point = CGPoint(x: newX, y: newY)
        let actionMove = SKAction.move(to: point, duration: const.timeToScaleArrow)
        let actionReturnMovement = SKAction.move(to: position, duration: const.timeToScaleArrow)
        return SKAction.repeatForever(SKAction.sequence([actionMove, actionReturnMovement]))
    }
    func transformBus(completion: (() -> Void)?) {
        let position = busFinalPositionNode.position
        starEffect = SKEmitterNode(fileNamed: "StarEffect")
        starEffect.zPosition = 10
        starEffect.position = position
        starEffect.numParticlesToEmit = 20
        gameSceneNode.addChild(starEffect)
        let fadeInAlphaAction = SKAction.fadeIn(withDuration: const.timeToTransformBus)
        platformNode.run(solvingSound)
        platformNode.run(fadeInAlphaAction) {
            self.starEffect.removeFromParent()
            if let completionHandler = completion {
                completionHandler()
            }
        }
    }
    func enterInBus(completion: (() -> Void)?) {
        let position = busFinalPositionNode.position
        let newX = position.x + manNode.size.width/2
        let secondMoveBackAnimation = SKAction.moveTo(x: newX, duration: const.timeToEnterInBus)
        manPositionBeforeEnter = CGPoint(x: newX, y: manNode.position.y)
        let resizeAction = SKAction.scale(to: 0.6, duration: const.timeToEnterInBus)
        let newPoint = CGPoint(x: 150, y: -210)
        let moveAction = SKAction.move(to: newPoint, duration: const.timeToEnterInBus)
        platformPositionBeforeEnter = platformNode.position
        let resizePlatAction = SKAction.scale(to: 0.65, duration: const.timeToEnterInBus)
        let newPlatPoint = CGPoint(x: 130, y: -195)
        let movePlatAction = SKAction.move(to: newPlatPoint, duration: const.timeToEnterInBus)
        manNode.run(waitAction) {
            self.manNode.run(self.rotateWheelAnimationReversed)
            self.manNode.run(secondMoveBackAnimation) {
                // remove the action of wheel rotating
                self.manNode.removeAllActions()
                self.manNode.physicsBody?.affectedByGravity = false
                self.manNode.run(resizeAction)
                self.manNode.run(moveAction)
                self.platformNode.run(resizePlatAction)
                self.platformNode.run(movePlatAction) {
                    self.busNode.run(self.busCloseDoorAnimation, completion: {
                        if let completionHandler = completion {
                            completionHandler()
                        }
                    })
                }
            }
        }
    }
    func leaveBus(completion: (() -> Void)?) {
        self.manNode.run(SKAction.scale(to: 1, duration: const.timeToEnterInBus))
        self.manNode.run(SKAction.move(to: manPositionBeforeEnter, duration: const.timeToEnterInBus))
        self.platformNode.run(SKAction.scale(to: 1, duration: const.timeToEnterInBus))
        self.platformNode.run(SKAction.move(to: platformPositionBeforeEnter, duration: const.timeToEnterInBus)) {
            self.manNode.physicsBody?.affectedByGravity = true
            if let completionHandler = completion {
                completionHandler()
            }
        }
    }
    func transformHole(completion: (() -> Void)?) {
        let position = starEffectInHole.position
        starEffectInHole = SKEmitterNode(fileNamed: "StarEffect")
        starEffectInHole.zPosition = 10
        starEffectInHole.position = position
        gameSceneNode.addChild(starEffectInHole)
        finalGround.run(solvingSound)
        finalGround.run(holeAnimation) { [unowned self] in
            self.finalStopNode.removeFromParent()
            self.starEffectInHole.removeFromParent()
            if let completionHandler = completion {
                completionHandler()
            }
        }
    }
    func finalAnimation() {
        let currentGroundPosition = finalGround.position
        let newPoint = CGPoint(x: currentGroundPosition.x, y: currentGroundPosition.y - 700)
        let moveAction = SKAction.move(to: newPoint, duration: const.timeToFInalAnimations)
        let fadeInAction = SKAction.fadeIn(withDuration: const.timeToFInalAnimations)
        self.groundNode.run(moveAction)
        self.finalGround.run(moveAction) {
            self.wwdcNode.run(fadeInAction) {
                self.menuNode.run(fadeInAction)
            }
        }
    }
    // MARK: - Return to menu
    func presentStartScene() {
        let transition: SKTransition = SKTransition.fade(withDuration: 1)
        if let scene = SKScene(fileNamed: "StartScene") as? StartScene {
            scene.scaleMode = .aspectFit
            self.view?.presentScene(scene, transition: transition)
        }
    }
    func pressMenuButton(completion: (() -> Void)?) {
        let alphaInAnimation: CGFloat = 0.6
        let scaleInAnimation: CGFloat = 0.9
        let fadeAction = SKAction.fadeAlpha(to: alphaInAnimation, duration: const.animationPerFrame)
        let fadeActionReversed = SKAction.fadeAlpha(to: 1.0, duration: const.animationPerFrame)
        let scaleAction = SKAction.scale(to: scaleInAnimation, duration: const.animationPerFrame)
        let scaleActionReversed = SKAction.scale(to: 1.0, duration: const.animationPerFrame)
        menuNode.run(fadeAction)
        menuNode.run(scaleAction) {
            self.menuNode.run(fadeActionReversed)
            self.menuNode.run(scaleActionReversed) {
                if let completionHandler = completion {
                    completionHandler()
                }
            }
        }
    }
}
