//
//  Actions.swift
//  wwdcProject
//
//  Created by Rodrigo Maximo on 05/04/18.
//  Copyright © 2018 Alexandre Conti Mestre. All rights reserved.
//

import SpriteKit

class SetupActions {
    let const = Constants.self
    // MARK: - Setup actions
    func setupRotateWheelAnimation() -> SKAction {
        let textures = [
            SKTexture(imageNamed: "man-2"),
            SKTexture(imageNamed: "man-3"),
            SKTexture(imageNamed: "man-0"),
            SKTexture(imageNamed: "man-1")
        ]
        let texturesAnimation = SKAction.animate(with: textures, timePerFrame: const.animationPerFrame)
        let rotateWheelAnimation = SKAction.repeatForever(texturesAnimation)
        return rotateWheelAnimation
    }
    func setupRotateWheelAnimationRev() -> SKAction {
        let texturesReversed = [
            SKTexture(imageNamed: "man-0"),
            SKTexture(imageNamed: "man-3"),
            SKTexture(imageNamed: "man-2"),
            SKTexture(imageNamed: "man-1")
        ]
        let texturesActionReversed = SKAction.animate(with: texturesReversed, timePerFrame: const.animationPerFrame)
        let rotateWheelAnimationReversed = SKAction.repeatForever(texturesActionReversed)
        return rotateWheelAnimationReversed
    }
    func setupSadAnimation() -> SKAction {
        let texturesSadAnimation = [
            SKTexture(imageNamed: "man-sad1"),
            SKTexture(imageNamed: "man-sad2"),
            SKTexture(imageNamed: "man-sad3")
        ]
        let sadAnimation = SKAction.animate(with: texturesSadAnimation, timePerFrame: const.animationPerFrame)
        return sadAnimation
    }
    func setupSadAnimationRev() -> SKAction {
        let texturesSadAnimationReversed = [
            SKTexture(imageNamed: "man-sad2"),
            SKTexture(imageNamed: "man-sad1"),
            SKTexture(imageNamed: "man-1")
        ]
        let sadAnimationReversed = SKAction.animate(with: texturesSadAnimationReversed,
                                                    timePerFrame: const.animationPerFrame)
        return sadAnimationReversed
    }
    func setupStairsAnimation() -> SKAction {
        let textures = [
            SKTexture(imageNamed: "stairs-down-1"),
            SKTexture(imageNamed: "stairs-down-2"),
            SKTexture(imageNamed: "stairs-down-3"),
            SKTexture(imageNamed: "stairs-down-4"),
            SKTexture(imageNamed: "stairs-down-final")
        ]
        let stairsAnimation = SKAction.animate(with: textures, timePerFrame: const.animationPerFrame)
        return stairsAnimation
    }
    func setupBusDoorAnimation() -> SKAction {
        let textures = [
            SKTexture(imageNamed: "bus-2"),
            SKTexture(imageNamed: "bus-3"),
            SKTexture(imageNamed: "bus-4"),
            SKTexture(imageNamed: "bus-5")
        ]
        let busOpenDoorAnimation = SKAction.animate(with: textures, timePerFrame: const.animationPerFrame)
        return busOpenDoorAnimation
    }
    func setupBusWheelMoveAnimation() -> SKAction {
        let busWheelMoveAnimation = SKAction.rotate(byAngle: -(.pi/10), duration: const.animationPerFrame)
        return busWheelMoveAnimation
    }
    func setupBusMoveAnimation(finalPosition: CGPoint) -> SKAction {
        let busMoveAnimation = SKAction.move(to: finalPosition, duration: const.timeToBusArrives)
        return busMoveAnimation
    }
    func setupCloseDoorBusAnimation() -> SKAction {
        let texturesCloseDoor = [
            SKTexture(imageNamed: "bus-4"),
            SKTexture(imageNamed: "bus-3"),
            SKTexture(imageNamed: "bus-2"),
            SKTexture(imageNamed: "bus-1")
        ]
        let busCloseDoorAnimation = SKAction.animate(with: texturesCloseDoor, timePerFrame: const.animationPerFrame)
        return busCloseDoorAnimation
    }
    func setupArrowActions() -> SKAction {
        let arrowDecreaseScaleAction = SKAction.scale(to: const.decreaseScale, duration: const.timeToScaleArrow)
        let arrowIncreaseScaleAction = SKAction.scale(to: 1.0, duration: const.timeToScaleArrow)
        let sequenceAction = SKAction.sequence([arrowDecreaseScaleAction, arrowIncreaseScaleAction])
        let arrowScaleAction = SKAction.repeatForever(sequenceAction)
        return arrowScaleAction
    }
    func setupHoleAnimation() -> SKAction {
        let textures = [
            SKTexture(imageNamed: "final-ground-1"),
            SKTexture(imageNamed: "final-ground-2"),
            SKTexture(imageNamed: "final-ground-3"),
            SKTexture(imageNamed: "final-ground-4"),
            SKTexture(imageNamed: "final-ground-5"),
            SKTexture(imageNamed: "final-ground")
        ]
        let holeAnimation = SKAction.animate(with: textures, timePerFrame: const.animationPerFrame)
        return holeAnimation
    }
    func setupThoughtnessAnimation(fadeInAction: SKAction) -> SKAction {
        let textures = [
            SKTexture(imageNamed: "thought-bubble-2"),
            SKTexture(imageNamed: "thought-bubble-3")
        ]
        let textureAction = SKAction.animate(with: textures, timePerFrame: const.animationPerFrame)
        let thoughtnessAnimation = SKAction.sequence([fadeInAction, textureAction])
        return thoughtnessAnimation
    }
    func animateText(from labelNode: SKLabelNode, charTimeInterval: TimeInterval,
                     fadeInAction: SKAction, _ completion: (() -> Void)?) {
        guard let text = labelNode.text else { return }
        let waitAction = SKAction.wait(forDuration: charTimeInterval)
        var sequenceAction = [SKAction]()
        var currentText = ""
        var currentTextArray = [String]()
        for (index, char) in text.enumerated() {
            currentText += String(char)
            currentTextArray.append(currentText)
            let action = SKAction.run({
                labelNode.text = currentTextArray[index]
            })
            sequenceAction.append(action)
            sequenceAction.append(waitAction)
        }
        labelNode.text = ""
        labelNode.run(fadeInAction)
        labelNode.run(SKAction.sequence(sequenceAction)) {
            if let completionHandler = completion {
                completionHandler()
            }
        }
    }
}
