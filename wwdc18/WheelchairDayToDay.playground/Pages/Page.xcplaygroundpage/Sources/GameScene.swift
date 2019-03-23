import SpriteKit
import GameplayKit
import AVFoundation
import PlaygroundSupport

// MARK: - Enum

enum PhysicsCategory : UInt32 {
    case none =     0           // 0
    case all =      2147483647  // max UInt32
    case man =      1           // 1
    case stairs =   2           // 2
    case block =    4
    case platform = 8
}

enum SceneNumber : Int {
    case firstScene = 1
    case secondScene = 2
    case thirdScene = 3
}

class GameScene: SKScene {
    
    // MARK: - Nodes from scene
    var gameSceneNode : SKSpriteNode!
    var manNode : SKSpriteNode!
    var stairsNode : SKSpriteNode!
    var busNode : SKSpriteNode!
    var busTouchNode : SKSpriteNode!
    var busBehindWheelNode : SKSpriteNode!
    var busFrontWheelNode : SKSpriteNode!
    var arrowStairsNode : SKSpriteNode!
    var arrowBusNode : SKSpriteNode!
    var arrowfinalNode : SKSpriteNode!
    var platformNode : SKSpriteNode!
    var groundNode : SKSpriteNode!
    var busBoard : SKSpriteNode!
    var finalGround : SKSpriteNode!
    var finalGroundTouchNode : SKSpriteNode!
    var thoughtnessNode : SKSpriteNode!
    var emotionLabel : SKLabelNode!
    var wwdcNode : SKLabelNode!
    var menuNode : SKSpriteNode!
    
    // MARK: - Labels nodes
    var firstTextLabel : SKLabelNode!
    var secondTextLabel : SKLabelNode!
    var thirdTextLabel : SKLabelNode!
    var firstInstructionTextLabel : SKLabelNode!
    var secondInstructionTextLabel : SKLabelNode!
    var thirdInstructionTextLabel : SKLabelNode!
    
    // MARK: - Reference Nodes
    var stairsStopNode : SKSpriteNode!
    var busStopNode : SKSpriteNode!
    var finalScene1Node : SKSpriteNode!
    var finalScene2Node : SKSpriteNode!
    var busFinalPositionNode : SKSpriteNode!
    var platformStopNode : SKSpriteNode!
    var finalStopNode : SKSpriteNode!
    var afterSceneStopNode : SKSpriteNode!
    
    // MARK: - Audio Nodes and Actions
    var wheelChairAudioNode = SKAudioNode(fileNamed: "wheelchair.wav")
    var solvingSound = SKAction.playSoundFileNamed("solvingSound.wav", waitForCompletion: true)
    var feelingSoundAction = SKAction.playSoundFileNamed("thoughtnessSound.wav", waitForCompletion: false)
    var busSoundAction = SKAction.playSoundFileNamed("busSound.wav", waitForCompletion: true)
    var busHornSoundAction = SKAction.playSoundFileNamed("busHorn.wav", waitForCompletion: true)
    
    // MARK: - System Particles
    var starEffect : SKEmitterNode!
    var starEffectInHole : SKEmitterNode!
    
    // MARK: - Actions
    var rotateWheelAnimation : SKAction!
    var rotateWheelAnimationReversed : SKAction!
    var moveManAnimation : SKAction!
    var sadAnimation : SKAction!
    
    var sadAnimationReversed : SKAction!
    var stairsAnimation : SKAction!
    var holeAnimation : SKAction!
    
    var busMoveAnimation : SKAction!
    var busWheelMoveAnimation : SKAction!
    var busOpenDoorAnimation : SKAction!
    var busCloseDoorAnimation : SKAction!
    var thoughtnessAnimation : SKAction!
    
    var waitAction : SKAction!
    var arrowScaleAction : SKAction!
    
    var fadeOutAction : SKAction!
    var fadeInAction : SKAction!
    
    var manPositionBeforeEnter : CGPoint!
    var platformPositionBeforeEnter : CGPoint!
    
    // MARK: - Constants
    let animationPerFrame : TimeInterval = 0.25
    let timeToChangeScene : TimeInterval = 1.0
    let timeToWaitBeforeAction : TimeInterval = 1.0
    let timeToBusArrives : TimeInterval = 3.0
    let timeToTransformBus : TimeInterval = 2.0
    let timeToEnterInBus : TimeInterval = 1.0
    let timeToAnimateText : TimeInterval = 0.06
    let timeToFInalAnimations : TimeInterval = 1.0
    
    // MARK: - User interaction
    var stairsInteraction = false
    var busNodeInteraction = false
    var finalGroundInteraction = false
    
    // Arrow constants
    let decreaseScale : CGFloat = 0.7
    let timeToScaleArrow : TimeInterval = 0.5
    let distanceMoveArrow : CGFloat = 50
    let happyEmotionText = "🙂"
    let sadEmotionText = "☹️"
    
    // MARK: - Text voice
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        gameSceneNode = self.childNode(withName: "gameScene") as! SKSpriteNode
        manNode = gameSceneNode.childNode(withName: "man") as! SKSpriteNode
        
        stairsNode = gameSceneNode.childNode(withName: "stairs") as! SKSpriteNode
        stairsNode.texture = SKTexture(imageNamed: "stairs-down-1")
        starEffect = gameSceneNode.childNode(withName: "starEffect") as! SKEmitterNode
        
        busNode = gameSceneNode.childNode(withName: "busNode") as! SKSpriteNode
        busTouchNode = gameSceneNode.childNode(withName: "busTouchNode") as! SKSpriteNode
        busBehindWheelNode = busNode.childNode(withName: "wheel-behind") as! SKSpriteNode
        busFrontWheelNode = busNode.childNode(withName: "wheel-front") as! SKSpriteNode
        arrowStairsNode = gameSceneNode.childNode(withName: "arrowStairsNode") as! SKSpriteNode
        arrowBusNode = gameSceneNode.childNode(withName: "arrowBusNode") as! SKSpriteNode
        arrowfinalNode = gameSceneNode.childNode(withName: "arrowfinalNode") as! SKSpriteNode
        platformNode = gameSceneNode.childNode(withName: "platformNode") as! SKSpriteNode
        groundNode = gameSceneNode.childNode(withName: "groundNode") as! SKSpriteNode
        busBoard = gameSceneNode.childNode(withName: "busBoard") as! SKSpriteNode
        finalGround = gameSceneNode.childNode(withName: "finalGround") as! SKSpriteNode
        finalGroundTouchNode = gameSceneNode.childNode(withName: "finalGroundTouchNode") as! SKSpriteNode
        finalGround.texture = SKTexture(imageNamed: "final-ground-1")
        starEffectInHole = gameSceneNode.childNode(withName: "starEffectInHole") as! SKEmitterNode
        thoughtnessNode = manNode.childNode(withName: "thoughtnessNode") as! SKSpriteNode
        wwdcNode = gameSceneNode.childNode(withName: "wwdcNode") as! SKLabelNode
        menuNode = gameSceneNode.childNode(withName: "menuNode") as! SKSpriteNode
        
        emotionLabel = thoughtnessNode.childNode(withName: "emotionText") as! SKLabelNode
        firstTextLabel = gameSceneNode.childNode(withName: "firstTextLabel") as! SKLabelNode
        firstInstructionTextLabel = gameSceneNode.childNode(withName: "firstInstruction") as! SKLabelNode
        secondTextLabel = gameSceneNode.childNode(withName: "secondTextLabel") as! SKLabelNode
        secondInstructionTextLabel = gameSceneNode.childNode(withName: "secondInstruction") as! SKLabelNode
        thirdTextLabel = gameSceneNode.childNode(withName: "thirdTextLabel") as! SKLabelNode
        thirdInstructionTextLabel = gameSceneNode.childNode(withName: "thirdInstruction") as! SKLabelNode
        
        stairsStopNode = gameSceneNode.childNode(withName: "firstStopNode") as! SKSpriteNode
        busStopNode = gameSceneNode.childNode(withName: "busStopNode") as! SKSpriteNode
        finalScene1Node = gameSceneNode.childNode(withName: "finalScene1Node") as! SKSpriteNode
        finalScene2Node = gameSceneNode.childNode(withName: "finalScene2Node") as! SKSpriteNode
        busFinalPositionNode = gameSceneNode.childNode(withName: "busFinalPositionNode") as! SKSpriteNode
        platformStopNode = gameSceneNode.childNode(withName: "platformStopNode") as! SKSpriteNode
        finalStopNode = gameSceneNode.childNode(withName: "finalStopNode") as! SKSpriteNode
        afterSceneStopNode = gameSceneNode.childNode(withName: "afterSceneStopNode") as! SKSpriteNode
        
        // instantiate all the actions
        setupActions()
        
        // set the physics delegate
        physicsWorld.contactDelegate = self
    }
    
    
    func setupActions() {
        
        waitAction = SKAction.wait(forDuration: timeToWaitBeforeAction)
        fadeOutAction = SKAction.fadeOut(withDuration: animationPerFrame)
        fadeInAction = SKAction.fadeIn(withDuration: animationPerFrame)
        
        // rotate wheel animation
        setupRotateWheelAnimation()
        
        // sad animation
        setupSadAnimation()
        
        // stairs animation
        setupStairsAnimation()
        
        // bus animation
        setupBusAnimations()
        
        // arrow actions to indicate where user can interact with the scene
        setupArrowActions()
        
        // setup the hole animation
        setupHoleAnimation()
        
        // setup the thoughtness animation
        setupThoughtnessAnimation()
        
        manNode.run(waitAction) {
            self.textToSpeech(textLabel: self.firstTextLabel)
            self.animateText(from: self.firstTextLabel, charTimeInterval: self.timeToAnimateText) {
                self.setupAudioNodes()
                self.manMoveForward()
            }
        }
    }
    
    func setupAudioNodes() {
        manNode.addChild(wheelChairAudioNode)
        wheelChairAudioNode.autoplayLooped = true
    }
    
    
    // MARK: - Setup actions
    
    func setupRotateWheelAnimation() {
        let textures = [
            SKTexture(imageNamed: "man-2"),
            SKTexture(imageNamed: "man-3"),
            SKTexture(imageNamed: "man-0"),
            SKTexture(imageNamed: "man-1")
        ]
        let texturesAnimation = SKAction.animate(with: textures, timePerFrame: animationPerFrame)
        rotateWheelAnimation = SKAction.repeatForever(texturesAnimation)
        
        let texturesReversed = [
            SKTexture(imageNamed: "man-0"),
            SKTexture(imageNamed: "man-3"),
            SKTexture(imageNamed: "man-2"),
            SKTexture(imageNamed: "man-1")
        ]
        let texturesActionReversed = SKAction.animate(with: texturesReversed, timePerFrame: animationPerFrame)
        rotateWheelAnimationReversed = SKAction.repeatForever(texturesActionReversed)
    }
    
    func setupSadAnimation() {
        let texturesSadAnimation = [
            SKTexture(imageNamed: "man-sad1"),
            SKTexture(imageNamed: "man-sad2"),
            SKTexture(imageNamed: "man-sad3")
        ]
        let texturesSadAnimationReversed = [
            SKTexture(imageNamed: "man-sad2"),
            SKTexture(imageNamed: "man-sad1"),
            SKTexture(imageNamed: "man-1")
        ]
        sadAnimation = SKAction.animate(with: texturesSadAnimation, timePerFrame: animationPerFrame)
        sadAnimationReversed = SKAction.animate(with: texturesSadAnimationReversed, timePerFrame: animationPerFrame)
    }
    
    func setupStairsAnimation() {
        let textures = [
            SKTexture(imageNamed: "stairs-down-1"),
            SKTexture(imageNamed: "stairs-down-2"),
            SKTexture(imageNamed: "stairs-down-3"),
            SKTexture(imageNamed: "stairs-down-4"),
            SKTexture(imageNamed: "stairs-down-final")
        ]
        stairsAnimation = SKAction.animate(with: textures, timePerFrame: animationPerFrame)
    }
    
    func setupBusAnimations() {
        let textures = [
            SKTexture(imageNamed: "bus-2"),
            SKTexture(imageNamed: "bus-3"),
            SKTexture(imageNamed: "bus-4"),
            SKTexture(imageNamed: "bus-5")
        ]
        busOpenDoorAnimation = SKAction.animate(with: textures, timePerFrame: animationPerFrame)
        busWheelMoveAnimation = SKAction.rotate(byAngle: -(.pi/10), duration: animationPerFrame)
        busMoveAnimation = SKAction.move(to: busFinalPositionNode.position, duration: timeToBusArrives)
        
        let texturesCloseDoor = [
            SKTexture(imageNamed: "bus-4"),
            SKTexture(imageNamed: "bus-3"),
            SKTexture(imageNamed: "bus-2"),
            SKTexture(imageNamed: "bus-1")
        ]
        busCloseDoorAnimation = SKAction.animate(with: texturesCloseDoor, timePerFrame: animationPerFrame)
    }
    
    func setupArrowActions() {
        let arrowDecreaseScaleAction = SKAction.scale(to: decreaseScale, duration: timeToScaleArrow)
        let arrowIncreaseScaleAction = SKAction.scale(to: 1.0, duration: timeToScaleArrow)
        let sequenceAction = SKAction.sequence([arrowDecreaseScaleAction, arrowIncreaseScaleAction])
        arrowScaleAction = SKAction.repeatForever(sequenceAction)
    }
    
    func setupHoleAnimation() {
        let textures = [
            SKTexture(imageNamed: "final-ground-1"),
            SKTexture(imageNamed: "final-ground-2"),
            SKTexture(imageNamed: "final-ground-3"),
            SKTexture(imageNamed: "final-ground-4"),
            SKTexture(imageNamed: "final-ground-5"),
            SKTexture(imageNamed: "final-ground")
        ]
        holeAnimation = SKAction.animate(with: textures, timePerFrame: animationPerFrame)
    }
    
    func setupThoughtnessAnimation() {
        let textures = [
            SKTexture(imageNamed: "thought-bubble-2"),
            SKTexture(imageNamed: "thought-bubble-3")
        ]
        let textureAction = SKAction.animate(with: textures, timePerFrame: animationPerFrame)
        thoughtnessAnimation = SKAction.sequence([fadeInAction, textureAction])
    }
    
    
    // MARK: - Text
    
    func textToSpeech(textLabel : SKLabelNode) {
        guard let text = textLabel.text else { return }
        myUtterance = AVSpeechUtterance(string: text)
        myUtterance.rate = 0.4
        myUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synth.speak(myUtterance)
    }
    
    func animateText(from labelNode : SKLabelNode, charTimeInterval : TimeInterval, _ completion : (()->())?) {
        guard let text = labelNode.text else { return }
        let waitAction = SKAction.wait(forDuration: charTimeInterval)
        var sequenceAction = [SKAction]()
        var currentText = ""
        var currentTextArray = [String]()
        for (i, char) in text.enumerated() {
            currentText += String(char)
            currentTextArray.append(currentText)
            let action = SKAction.run({
                labelNode.text = currentTextArray[i]
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
    
    // MARK: - Entities behaviors
    
    /// Move forward and animating the wheels.
    func manMoveForward() {
        let manMovementForwardSpeed = 100
        manNode.run(rotateWheelAnimation)
        wheelChairAudioNode.run(SKAction.play())
        manNode.physicsBody?.velocity = CGVector(dx: manMovementForwardSpeed, dy: 0)
    }
    
    /// Transform the stairs making it possible to use by the man.
    func transformStairs(_ completion : (()->())?) {
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
    func moveBus(_ completion : (()->())?) {
        busNode.run(busSoundAction)
        busNode.run(busHornSoundAction)
        busNode.isHidden = false
        busNode.run(SKAction.sequence([waitAction, waitAction, busMoveAnimation])) {
            // stops the wheels and open the bus door
            self.busBehindWheelNode.removeAllActions()
            self.busFrontWheelNode.removeAllActions()
            self.run(SKAction.wait(forDuration: self.timeToWaitBeforeAction)) {
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
        let action = SKAction.move(by: vector, duration: timeToBusArrives)
        action.timingMode = .easeIn
        self.busBoard.run(action)
    }
    
    func changeScene(nextSceneNumber : SceneNumber, completion : (()->())?) {
        let currentX = gameSceneNode.position.x
        let currentY = gameSceneNode.position.y
        guard let scene = self.scene else { return }
        let width = scene.size.width
        let moveLeftAction = SKAction.move(to: CGPoint(x: currentX-width, y: currentY), duration: timeToChangeScene)
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
    func manSadAction(sad : Bool, completion : (()->())?) {
        var animation : SKAction = self.sadAnimation
        var text : String = sadEmotionText
        if !sad {
            animation = self.sadAnimationReversed
            text = happyEmotionText
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
    
    func activateArrow(_ arrowNode : SKSpriteNode) {
        arrowNode.isHidden = false
        arrowNode.run(arrowMovementAction(arrowNode))
        arrowNode.run(arrowScaleAction)
    }
    
    func disableArrow(_ arrowNode : SKSpriteNode) {
        arrowNode.isHidden = true
        arrowNode.removeAllActions()
    }
    
    func arrowMovementAction(_ arrowNode : SKSpriteNode) -> SKAction {
        let angle = arrowNode.zRotation
        let position = arrowNode.position
        // if the angle is zero, the arrow will move in y axe, in case angle is pi/2, the arrow will move in x axe
        let newX = position.x + (distanceMoveArrow * cos(.pi/2 - angle))
        let newY = position.y - (distanceMoveArrow * sin(.pi/2 - angle))
        let point = CGPoint(x: newX, y: newY)
        let actionMove = SKAction.move(to: point, duration: timeToScaleArrow)
        
        let actionReturnMovement = SKAction.move(to: position, duration: timeToScaleArrow)
        
        return SKAction.repeatForever(SKAction.sequence([actionMove, actionReturnMovement]))
    }
    
    func transformBus(completion : (()->())?) {
        let position = busFinalPositionNode.position
        starEffect = SKEmitterNode(fileNamed: "StarEffect")
        starEffect.zPosition = 10
        starEffect.position = position
        starEffect.numParticlesToEmit = 20
        gameSceneNode.addChild(starEffect)
        
        let fadeInAlphaAction = SKAction.fadeIn(withDuration: timeToTransformBus)
        
        platformNode.run(solvingSound)
        platformNode.run(fadeInAlphaAction) {
            self.starEffect.removeFromParent()
            if let completionHandler = completion {
                completionHandler()
            }
        }
    }
    
    func enterInBus(completion : (()->())?) {
        let position = busFinalPositionNode.position
        let newX = position.x + manNode.size.width/2
        let secondMoveBackAnimation = SKAction.moveTo(x: newX, duration: timeToEnterInBus)
        
        manPositionBeforeEnter = CGPoint(x: newX, y: manNode.position.y)
        let resizeAction = SKAction.scale(to: 0.6, duration: timeToEnterInBus)
        let newPoint = CGPoint(x: 150, y: -210)
        let moveAction = SKAction.move(to: newPoint, duration: timeToEnterInBus)
        
        platformPositionBeforeEnter = platformNode.position
        let resizePlatAction = SKAction.scale(to: 0.65, duration: timeToEnterInBus)
        let newPlatPoint = CGPoint(x: 130, y: -195)
        let movePlatAction = SKAction.move(to: newPlatPoint, duration: timeToEnterInBus)
        
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
    
    func leaveBus(completion : (()->())?) {
        self.manNode.run(SKAction.scale(to: 1, duration: timeToEnterInBus))
        self.manNode.run(SKAction.move(to: manPositionBeforeEnter, duration: timeToEnterInBus))
        self.platformNode.run(SKAction.scale(to: 1, duration: timeToEnterInBus))
        self.platformNode.run(SKAction.move(to: platformPositionBeforeEnter, duration: timeToEnterInBus)) {
            self.manNode.physicsBody?.affectedByGravity = true
            if let completionHandler = completion {
                completionHandler()
            }
        }
    }
    
    func transformHole(completion : (()->())?) {
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
        let moveAction = SKAction.move(to: newPoint, duration: timeToFInalAnimations)
        let fadeInAction = SKAction.fadeIn(withDuration: timeToFInalAnimations)
        self.groundNode.run(moveAction)
        self.finalGround.run(moveAction) {
            self.wwdcNode.run(fadeInAction) {
                self.menuNode.run(fadeInAction)
            }
        }
    }
    
    // MARK: - Return to menu
    func presentStartScene() {
        let transition:SKTransition = SKTransition.fade(withDuration: 1)
        // Load the SKScene from 'GameScene.sks'
        let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 700, height: 700))
        
        if let scene = StartScene(fileNamed: "StartScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
            
            // Present the scene
            sceneView.presentScene(scene, transition: transition)
        }
        
        sceneView.ignoresSiblingOrder = false
        
        PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
    }
    
    func pressMenuButton(completion : (()->())?) {
        let alphaInAnimation : CGFloat = 0.6
        let scaleInAnimation : CGFloat = 0.9
        let fadeAction = SKAction.fadeAlpha(to: alphaInAnimation, duration: animationPerFrame)
        let fadeActionReversed = SKAction.fadeAlpha(to: 1.0, duration: animationPerFrame)
        let scaleAction = SKAction.scale(to: scaleInAnimation, duration: animationPerFrame)
        let scaleActionReversed = SKAction.scale(to: 1.0, duration: animationPerFrame)
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
    
    // MARK: - Touches
    
    func touchDown(touchedNode : SKNode) {
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
            break
            
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
            break
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
            break
        case menuNode:
            pressMenuButton(completion: {
                self.presentStartScene()
            })
            break
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

extension GameScene : SKPhysicsContactDelegate {
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
        if ((firstBody.categoryBitMask & PhysicsCategory.man.rawValue != 0) && (secondBody.categoryBitMask & PhysicsCategory.block.rawValue != 0)) {
            if let secondNode = secondBody.node as? SKSpriteNode {
                manColides(with: secondNode)
            }
        }
    }
    
    func manColides(with node : SKSpriteNode) {
        switch node {
        case stairsStopNode:
            stopsMan()
            manSadAction(sad: true) { [unowned self] in
                let label : SKLabelNode = self.firstInstructionTextLabel
                self.textToSpeech(textLabel: label)
                self.animateText(from: label, charTimeInterval: self.timeToAnimateText) {
                    self.activateArrow(self.arrowStairsNode)
                    self.stairsInteraction = true
                }
            }
            break
        case finalScene1Node:
            changeScene(nextSceneNumber: .secondScene) {}
            break
        case busStopNode:
            stopsMan()
            busStopNode.removeFromParent()
            
            self.textToSpeech(textLabel: self.secondTextLabel)
            self.animateText(from: self.secondTextLabel, charTimeInterval: self.timeToAnimateText) {
                self.moveBus {
                    self.manSadAction(sad: true, completion: {
                        let label : SKLabelNode = self.secondInstructionTextLabel
                        self.textToSpeech(textLabel: label)
                        self.animateText(from: label, charTimeInterval: self.timeToAnimateText) {
                            self.activateArrow(self.arrowBusNode)
                            self.busNodeInteraction = true
                        }
                    })
                }
            }
            break
        case platformStopNode:
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
            break
        case finalScene2Node:
            changeScene(nextSceneNumber: .thirdScene) {}
            break
        case finalStopNode:
            stopsMan()
            self.textToSpeech(textLabel: self.thirdTextLabel)
            self.animateText(from: self.thirdTextLabel, charTimeInterval: self.timeToAnimateText) {
                self.manSadAction(sad: true) { [unowned self] in
                    let label : SKLabelNode = self.thirdInstructionTextLabel
                    self.textToSpeech(textLabel: label)
                    self.animateText(from: label, charTimeInterval: self.timeToAnimateText) {
                        self.activateArrow(self.arrowfinalNode)
                        self.finalGroundInteraction = true
                    }
                }
            }
            break
        case afterSceneStopNode:
            stopsMan()
            finalAnimation()
        default:
            break
        }
        
    }
}

