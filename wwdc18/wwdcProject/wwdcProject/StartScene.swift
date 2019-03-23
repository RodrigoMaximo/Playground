//
//  StartScene.swift
//  wwdcProject
//
//  Created by Rodrigo Maximo on 30/03/18.
//  Copyright © 2018 Alexandre Conti Mestre. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class StartScene: SKScene {
    var backgroundNode: SKSpriteNode!
    var startNode: SKSpriteNode!
    var manNode: SKSpriteNode!
    var textLabelNode: SKLabelNode!
    // MARK: - Constants
    let timeToAnimate: TimeInterval = 0.5
    let alphaInAnimation: CGFloat = 0.6
    let scaleInAnimation: CGFloat = 0.9
    // MARK: - Text voice
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundNode = self.childNode(withName: "backgroundNode") as? SKSpriteNode
        startNode = backgroundNode.childNode(withName: "startNode") as? SKSpriteNode
        manNode = backgroundNode.childNode(withName: "man") as? SKSpriteNode
        textLabelNode = backgroundNode.childNode(withName: "textLabel") as? SKLabelNode
        setupManAnimation()
        textToSpeech(textLabel: textLabelNode)
    }
    // MARK: - Touches
    func setupManAnimation() {
        let textures = [
            SKTexture(imageNamed: "man-2"),
            SKTexture(imageNamed: "man-3"),
            SKTexture(imageNamed: "man-0"),
            SKTexture(imageNamed: "man-1")
        ]
        let texturesAnimation = SKAction.animate(with: textures, timePerFrame: 0.25)
        let rotateWheelAnimation = SKAction.repeatForever(texturesAnimation)
        manNode.run(rotateWheelAnimation)
    }
    func touchDown(touchedNode: SKNode) {
        switch touchedNode {
        case startNode:
            pressStartButton(completion: {
                self.presentGameScene()
            })
        default:
            break
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scene = self.scene!
        let touch = touches.first!
        let viewTouchLocation = touch.location(in: self)
        let touchedNode = scene.atPoint(viewTouchLocation)
        self.touchDown(touchedNode: touchedNode)
    }
    // MARK: - Text
    func textToSpeech(textLabel: SKLabelNode) {
        guard let text = textLabel.text else { return }
        myUtterance = AVSpeechUtterance(string: text)
        myUtterance.rate = 0.4
        myUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synth.speak(myUtterance)
    }
    // MARK: - button and present scenes
    func presentGameScene() {
        if let avSpeechBoundary = AVSpeechBoundary(rawValue: 0) {
            synth.stopSpeaking(at: avSpeechBoundary)
        }
        let transition: SKTransition = SKTransition.fade(withDuration: 1)
        if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
            scene.scaleMode = .aspectFit
            self.view?.presentScene(scene, transition: transition)
        }
    }
    func pressStartButton(completion: (() -> Void)?) {
        let fadeAction = SKAction.fadeAlpha(to: alphaInAnimation, duration: timeToAnimate)
        let fadeActionReversed = SKAction.fadeAlpha(to: 1.0, duration: timeToAnimate)
        let scaleAction = SKAction.scale(to: scaleInAnimation, duration: timeToAnimate)
        let scaleActionReversed = SKAction.scale(to: 1.0, duration: timeToAnimate)
        startNode.run(fadeAction)
        startNode.run(scaleAction) {
            self.startNode.run(fadeActionReversed)
            self.startNode.run(scaleActionReversed) {
                if let completionHandler = completion {
                    completionHandler()
                }
            }
        }
    }
}
