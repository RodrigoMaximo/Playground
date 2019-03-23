//
//  GameScene.swift
//  wwdcProject
//
//  Created by Alexandre Conti Mestre on 23/03/18.
//  Copyright © 2018 Alexandre Conti Mestre. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

// MARK: - Enum

enum PhysicsCategory: UInt32 {
    case none =     0           // 0
    case all =      2147483647  // max UInt32
    case man =      1           // 1
    case stairs =   2           // 2
    case block =    4
    case platform = 8
}

enum SceneNumber: Int {
    case firstScene = 1
    case secondScene = 2
    case thirdScene = 3
}

class GameScene: SKScene {
    let const = Constants.self
    var actionsInstance = SetupActions()
    // MARK: - Nodes from scene
    var gameSceneNode: SKSpriteNode!
    var manNode: SKSpriteNode!
    var stairsNode: SKSpriteNode!
    var busNode: SKSpriteNode!
    var busTouchNode: SKSpriteNode!
    var busBehindWheelNode: SKSpriteNode!
    var busFrontWheelNode: SKSpriteNode!
    var arrowStairsNode: SKSpriteNode!
    var arrowBusNode: SKSpriteNode!
    var arrowfinalNode: SKSpriteNode!
    var platformNode: SKSpriteNode!
    var groundNode: SKSpriteNode!
    var busBoard: SKSpriteNode!
    var finalGround: SKSpriteNode!
    var finalGroundTouchNode: SKSpriteNode!
    var thoughtnessNode: SKSpriteNode!
    var emotionLabel: SKLabelNode!
    var wwdcNode: SKLabelNode!
    var menuNode: SKSpriteNode!
    // MARK: - Labels nodes
    var firstTextLabel: SKLabelNode!
    var secondTextLabel: SKLabelNode!
    var thirdTextLabel: SKLabelNode!
    var firstInstructionTextLabel: SKLabelNode!
    var secondInstructionTextLabel: SKLabelNode!
    var thirdInstructionTextLabel: SKLabelNode!
    // MARK: - Reference Nodes
    var stairsStopNode: SKSpriteNode!
    var busStopNode: SKSpriteNode!
    var finalScene1Node: SKSpriteNode!
    var finalScene2Node: SKSpriteNode!
    var busFinalPositionNode: SKSpriteNode!
    var platformStopNode: SKSpriteNode!
    var finalStopNode: SKSpriteNode!
    var afterSceneStopNode: SKSpriteNode!
    // MARK: - Audio Nodes and Actions
    var wheelChairAudioNode = SKAudioNode(fileNamed: "wheelchair.wav")
    var solvingSound = SKAction.playSoundFileNamed("solvingSound.wav", waitForCompletion: true)
    var feelingSoundAction = SKAction.playSoundFileNamed("thoughtnessSound.wav", waitForCompletion: false)
    var busSoundAction = SKAction.playSoundFileNamed("busSound.wav", waitForCompletion: true)
    var busHornSoundAction = SKAction.playSoundFileNamed("busHorn.wav", waitForCompletion: true)
    // MARK: - System Particles
    var starEffect: SKEmitterNode!
    var starEffectInHole: SKEmitterNode!
    // MARK: - Actions
    var rotateWheelAnimation: SKAction!
    var rotateWheelAnimationReversed: SKAction!
    var moveManAnimation: SKAction!
    var sadAnimation: SKAction!
    var sadAnimationReversed: SKAction!
    var stairsAnimation: SKAction!
    var holeAnimation: SKAction!
    var busMoveAnimation: SKAction!
    var busWheelMoveAnimation: SKAction!
    var busOpenDoorAnimation: SKAction!
    var busCloseDoorAnimation: SKAction!
    var thoughtnessAnimation: SKAction!
    var waitAction: SKAction!
    var arrowScaleAction: SKAction!
    var fadeOutAction: SKAction!
    var fadeInAction: SKAction!
    var manPositionBeforeEnter: CGPoint!
    var platformPositionBeforeEnter: CGPoint!
    // MARK: - User interaction
    var stairsInteraction = false
    var busNodeInteraction = false
    var finalGroundInteraction = false
    // MARK: - Text voice
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        gameSceneNode = self.childNode(withName: "gameScene") as? SKSpriteNode
        manNode = gameSceneNode.childNode(withName: "man") as? SKSpriteNode
        stairsNode = gameSceneNode.childNode(withName: "stairs") as? SKSpriteNode
        stairsNode.texture = SKTexture(imageNamed: "stairs-down-1")
        starEffect = gameSceneNode.childNode(withName: "starEffect") as? SKEmitterNode
        busNode = gameSceneNode.childNode(withName: "busNode") as? SKSpriteNode
        busTouchNode = gameSceneNode.childNode(withName: "busTouchNode") as? SKSpriteNode
        busBehindWheelNode = busNode.childNode(withName: "wheel-behind") as? SKSpriteNode
        busFrontWheelNode = busNode.childNode(withName: "wheel-front") as? SKSpriteNode
        arrowStairsNode = gameSceneNode.childNode(withName: "arrowStairsNode") as? SKSpriteNode
        arrowBusNode = gameSceneNode.childNode(withName: "arrowBusNode") as? SKSpriteNode
        arrowfinalNode = gameSceneNode.childNode(withName: "arrowfinalNode") as? SKSpriteNode
        platformNode = gameSceneNode.childNode(withName: "platformNode") as? SKSpriteNode
        groundNode = gameSceneNode.childNode(withName: "groundNode") as? SKSpriteNode
        busBoard = gameSceneNode.childNode(withName: "busBoard") as? SKSpriteNode
        finalGround = gameSceneNode.childNode(withName: "finalGround") as? SKSpriteNode
        finalGroundTouchNode = gameSceneNode.childNode(withName: "finalGroundTouchNode") as? SKSpriteNode
        finalGround.texture = SKTexture(imageNamed: "final-ground-1")
        starEffectInHole = gameSceneNode.childNode(withName: "starEffectInHole") as? SKEmitterNode
        thoughtnessNode = manNode.childNode(withName: "thoughtnessNode") as? SKSpriteNode
        wwdcNode = gameSceneNode.childNode(withName: "wwdcNode") as? SKLabelNode
        menuNode = gameSceneNode.childNode(withName: "menuNode") as? SKSpriteNode
        emotionLabel = thoughtnessNode.childNode(withName: "emotionText") as? SKLabelNode
        firstTextLabel = gameSceneNode.childNode(withName: "firstTextLabel") as? SKLabelNode
        firstInstructionTextLabel = gameSceneNode.childNode(withName: "firstInstruction") as? SKLabelNode
        secondTextLabel = gameSceneNode.childNode(withName: "secondTextLabel") as? SKLabelNode
        secondInstructionTextLabel = gameSceneNode.childNode(withName: "secondInstruction") as? SKLabelNode
        thirdTextLabel = gameSceneNode.childNode(withName: "thirdTextLabel") as? SKLabelNode
        thirdInstructionTextLabel = gameSceneNode.childNode(withName: "thirdInstruction") as? SKLabelNode
        stairsStopNode = gameSceneNode.childNode(withName: "firstStopNode") as? SKSpriteNode
        busStopNode = gameSceneNode.childNode(withName: "busStopNode") as? SKSpriteNode
        finalScene1Node = gameSceneNode.childNode(withName: "finalScene1Node") as? SKSpriteNode
        finalScene2Node = gameSceneNode.childNode(withName: "finalScene2Node") as? SKSpriteNode
        busFinalPositionNode = gameSceneNode.childNode(withName: "busFinalPositionNode") as? SKSpriteNode
        platformStopNode = gameSceneNode.childNode(withName: "platformStopNode") as? SKSpriteNode
        finalStopNode = gameSceneNode.childNode(withName: "finalStopNode") as? SKSpriteNode
        afterSceneStopNode = gameSceneNode.childNode(withName: "afterSceneStopNode") as? SKSpriteNode
        // instantiate all the actions
        setupActions()
        // set the physics delegate
        physicsWorld.contactDelegate = self
    }
    func setupActions() {
        actionsInstance = SetupActions()
        waitAction = SKAction.wait(forDuration: const.timeToWaitBeforeAction)
        fadeOutAction = SKAction.fadeOut(withDuration: const.animationPerFrame)
        fadeInAction = SKAction.fadeIn(withDuration: const.animationPerFrame)
        // rotate wheel animation
        rotateWheelAnimation = actionsInstance.setupRotateWheelAnimation()
        rotateWheelAnimationReversed = actionsInstance.setupRotateWheelAnimationRev()
        // sad animation
        sadAnimation = actionsInstance.setupSadAnimation()
        sadAnimationReversed = actionsInstance.setupSadAnimationRev()
        // stairs animation
        stairsAnimation = actionsInstance.setupStairsAnimation()
        // bus animation
        busOpenDoorAnimation = actionsInstance.setupBusDoorAnimation()
        busWheelMoveAnimation = actionsInstance.setupBusWheelMoveAnimation()
        busMoveAnimation = actionsInstance.setupBusMoveAnimation(finalPosition: busFinalPositionNode.position)
        busCloseDoorAnimation = actionsInstance.setupCloseDoorBusAnimation()
        // arrow actions to indicate where user can interact with the scene
        arrowScaleAction = actionsInstance.setupArrowActions()
        // setup the hole animation
        holeAnimation = actionsInstance.setupHoleAnimation()
        // setup the thoughtness animation
        thoughtnessAnimation = actionsInstance.setupThoughtnessAnimation(fadeInAction: fadeInAction)
        manNode.run(waitAction) {
            self.textToSpeech(textLabel: self.firstTextLabel)
            self.actionsInstance.animateText(from: self.firstTextLabel,
                                             charTimeInterval: self.const.timeToAnimateText,
                                             fadeInAction: self.fadeInAction) {
                self.setupAudioNodes()
                self.manMoveForward()
            }
        }
    }
    func setupAudioNodes() {
        manNode.addChild(wheelChairAudioNode)
        wheelChairAudioNode.autoplayLooped = true
    }
    // MARK: - Text
    func textToSpeech(textLabel: SKLabelNode) {
        guard let text = textLabel.text else { return }
        myUtterance = AVSpeechUtterance(string: text)
        myUtterance.rate = 0.4
        myUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synth.speak(myUtterance)
    }
    // MARK: - Touches
    func touchDown(touchedNode: SKNode) {
        switch touchedNode {
        // first interaction
        case stairsNode:
            guard stairsInteraction else { return }
            transformStairs {
                self.manSadAction(sad: false, completion: {
                    // removes the text from the scene and makes the man go to the other scene
                    self.firstTextLabel.run(self.fadeOutAction)
                    self.firstInstructionTextLabel.run(self.fadeOutAction)
                    self.manMoveForward()
                })
            }
            disableArrow(arrowStairsNode)
            self.stairsInteraction = false
        // second interaction
        case busTouchNode:
            guard busNodeInteraction else { return }
            disableArrow(arrowBusNode)
            self.busNodeInteraction = false
            transformBus(completion: {
                self.manSadAction(sad: false, completion: {
                    // removes the text from the scene and makes the man go to the other scene
                    self.secondTextLabel.run(self.fadeOutAction)
                    self.secondInstructionTextLabel.run(self.fadeOutAction)
                    self.manMoveForward()
                })
            })
        // third and last interaction
        case finalGroundTouchNode:
            guard finalGroundInteraction else { return }
            disableArrow(arrowfinalNode)
            self.finalGroundInteraction = false
            transformHole(completion: {
                self.manSadAction(sad: false, completion: {
                    self.finalStopNode.removeFromParent()
                    self.thirdTextLabel.run(self.fadeOutAction)
                    self.thirdInstructionTextLabel.run(self.fadeOutAction)
                    self.manMoveForward()
                })
            })
        case menuNode:
            pressMenuButton(completion: {
                self.presentStartScene()
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
}
