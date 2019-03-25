//
//  GameScene.swift
//  Teste
//
//  Created by Rodrigo Maximo on 18/03/19.
//  Copyright © 2019 Rodrigo Maximo. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    // MARK: - Video
    private var videoNode: SKVideoNode!
    private var node: SKSpriteNode!
    var bgVideoPlayer: AVPlayer!
    
    // MARK: - AlasAnimation
    var fishFrames = [SKTexture]()
    var fishNode: SKSpriteNode!
    var planetNode: SKSpriteNode!
    
    // MARK: - Scenes
    var planetCardScene: PlanetCardScene!
    var airScene: AirScene!
    var waterScene: WaterScene!
    var deforestationScene: DeforestationScene!
    
    // MARK: - Backgrounds
    var scenesBackgroundNode: SKSpriteNode!
    var planetBackgroundNode: SKSpriteNode!
    var textBackgroundNode: SKSpriteNode!
    
    // MARK: - Planet information
    var planetBackgroundPosition: CGPoint!
    var planetBackgroundScale: Scale!
    
    var isProcessingTouch = false
    
    // MARK: text voice
    var labelNode: SKLabelNode!
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scene = self.scene!
        let touch = touches.first!
        let viewTouchLocation = touch.location(in: self)
        let touchedNode = scene.atPoint(viewTouchLocation)
        self.touchDown(touchedNode: touchedNode)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setup()
        textToSpeech(textLabel: labelNode)
    }
    
    private func setup() {
        setupBackgroundNodes()
        setupScenes()
        airScene.animateMoveTo(quadrant: .first, duration: 0.0, completion: nil)
        waterScene.animateMoveTo(quadrant: .third, duration: 0.0, completion: nil)
        deforestationScene.animateMoveTo(quadrant: .second, duration: 0.0, completion: nil)
    }
    
    private func setupBackgroundNodes() {
        setupPlanetBackground()
        scenesBackgroundNode = self.childNode(withName: "scenesBackgroundNode") as? SKSpriteNode
        textBackgroundNode = self.childNode(withName: "textBackgroundNode") as? SKSpriteNode
        labelNode = self.childNode(withName: "labelNode") as? SKLabelNode
    }
    
    private func setupPlanetBackground() {
        planetBackgroundNode = self.childNode(withName: "planetBackgroundNode") as? SKSpriteNode
        planetBackgroundPosition = planetBackgroundNode.position
        planetBackgroundScale = Scale(x: planetBackgroundNode.xScale, y: planetBackgroundNode.yScale)
    }
    
    private func setupScenes() {
        setupPlanetCardScene()
        setupAirScene()
        setupWaterScene()
        setupDeforestationScene()
    }
    
    private func setupPlanetCardScene() {
        let scale = Scale(x: 1, y: 1)
        planetCardScene = PlanetCardScene.loadBackground(with: scale, forParentNode: planetBackgroundNode)
    }
    
    private func setupAirScene() {
        let scale = Scale(x: 1, y: 1)
        airScene = AirScene.loadBackground(with: scale, forParentNode: scenesBackgroundNode)
    }
    
    private func setupWaterScene() {
        let scale = Scale(x: 1, y: 1)
        waterScene = WaterScene.loadBackground(with: scale, forParentNode: scenesBackgroundNode)
    }
    
    private func setupDeforestationScene() {
        let scale = Scale(x: 1, y: 1)
        deforestationScene = DeforestationScene.loadBackground(with: scale, forParentNode: scenesBackgroundNode)
    }
    
    private func touchDown(touchedNode: SKNode) {
        guard isProcessingTouch == false else { return }
        isProcessingTouch = true
        
        guard sceneTouhed(touchedNode: touchedNode) == false else { return }
        
        let group = DispatchGroup()
        group.enter()
        airScene.carNodeTouched(touchedNode) { [weak self] found in
            if found {
                self?.airSceneNextLevel() {
                    group.leave()
                }
            } else {
                group.leave()
            }
        }
        
        group.enter()
        deforestationScene.touchTargets(node: touchedNode) { [weak self] found in
            if found {
                self?.deforestationNextLevel() {
                    group.leave()
                }
            } else {
                group.leave()
            }
        }
        
        group.enter()
        waterScene.touchTrash(node: touchedNode) { [weak self] found in
            if found {
                self?.waterSceneNextLevel() {
                    group.leave()
                }
            } else {
                group.leave()
            }
        }
        
        switch touchedNode {
        case airScene.factoryNode:
            group.enter()
            airScene.touchFactory() { [weak self] in
                self?.airSceneNextLevel() {
                    group.leave()
                }
            }
        default:
            break
        }
        group.notify(queue: .main) {
            self.isProcessingTouch = false
        }
    }
    
    private func sceneTouhed(touchedNode: SKNode) -> Bool {
        var customScene: (CustomScene & SKNode)?
        switch touchedNode {
        case airScene.selectionNode:
            customScene = airScene
        case waterScene.selectionNode:
            customScene = waterScene
        case deforestationScene.selectionNode:
            customScene = deforestationScene
        default:
            break
        }
        if let scene = customScene, customScene?.selectionNode.isPaused == false {
            scene.animateMoveToOrigin(duration: Constants.timeBetweenAnimations) {
                self.labelNode.text = "Find all the problems related to environment and click them. Tap three cars, the factory, the chainsaw, the cut trees, and all the garbage in the ocean to help the Earth!"
                self.textToSpeech(textLabel: self.labelNode)
                self.isProcessingTouch = false
            }
            return true
        }
        return false
    }
    
    private func airSceneNextLevel(completion: Completion? = nil) {
        guard airScene.isNextLevel else {
            completion?()
            return
        }
        airScene.animateCleanSky { [weak self] in
            self?.animatePlanetToCenter {
                self?.planetCardScene.animatePlanetToNextStage() {
                    self?.animatePlanetToOrigin() {
                        self?.airScene.animateMoveTo(quadrant: .first, duration: Constants.timeBetweenAnimations) {
                            self?.airScene.selectionNode.isPaused = true
                            if self?.planetCardScene.currentStage == .three {
                                self?.presentWWDCScene()
                            }
                            completion?()
                        }
                    }
                }
            }
        }
    }
    
    private func waterSceneNextLevel(completion: Completion? = nil) {
        guard waterScene.isNextLevel else {
            completion?()
            return
        }
        self.waterScene.animateOceanCleaning { [weak self] in
            self?.animatePlanetToCenter {
                self?.planetCardScene.animatePlanetToNextStage() {
                    self?.animatePlanetToOrigin() {
                        self?.waterScene.animateMoveTo(quadrant: .third, duration: Constants.timeBetweenAnimations) {
                            self?.waterScene.selectionNode.isPaused = true
                            if self?.planetCardScene.currentStage == .three {
                                self?.presentWWDCScene()
                            }
                            completion?()
                        }
                    }
                }
            }
        }
    }
    
    private func deforestationNextLevel(completion: Completion? = nil) {
        guard deforestationScene.isNextLevel else {
            completion?()
            return
        }
        deforestationScene.animatePlantTrees() { [weak self] in
            self?.animatePlanetToCenter {
                self?.planetCardScene.animatePlanetToNextStage() {
                    self?.animatePlanetToOrigin() {
                        self?.deforestationScene.animateMoveTo(quadrant: .second, duration: Constants.timeBetweenAnimations) {
                            self?.deforestationScene.selectionNode.isPaused = true
                            if self?.planetCardScene.currentStage == .three {
                                self?.presentWWDCScene()
                            }
                            completion?()
                        }
                    }
                }
            }
        }
    }
    
    private func animatePlanetToCenter(completion: Completion? = nil) {
        self.run(.wait(forDuration: Constants.timeBetweenAnimations)) { [weak self] in
            self?.animatePlanetBackground(
                duration: Constants.Planet.timeToCenter,
                scale: Scale(x: 0.7, y: 0.7),
                position: .zero,
                completion: completion
            )
        }
    }
    
    private func animatePlanetToOrigin(completion: Completion? = nil) {
        self.run(.wait(forDuration: Constants.timeBetweenAnimations)) { [unowned self] in
            self.animatePlanetBackground(
                duration: Constants.Planet.timeToOrigin,
                scale: self.planetBackgroundScale,
                position: self.planetBackgroundPosition,
                completion: completion
            )
        }
    }
    
    private func animatePlanetBackground(duration: TimeInterval, scale: Scale, position: CGPoint, completion: Completion?) {
        let actionMove = SKAction.move(to: position, duration: duration)
        let actionScaleX = SKAction.scaleX(to: scale.x, duration: duration)
        let actionScaleY = SKAction.scaleY(to: scale.y, duration: duration)
        let waitAction = SKAction.wait(forDuration: duration)
        planetBackgroundNode.run(actionMove)
        planetBackgroundNode.run(actionScaleX)
        planetBackgroundNode.run(actionScaleY)
        planetBackgroundNode.run(waitAction, completion: completion ?? {})
    }
    
    
    // MARK: - Text
    
    func textToSpeech(textLabel: SKLabelNode) {
        guard let text = textLabel.text else { return }
        myUtterance = AVSpeechUtterance(string: text)
        myUtterance.rate = 0.4
        myUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synth.speak(myUtterance)
    }
    
    private func presentWWDCScene() {
        let transition: SKTransition = SKTransition.fade(withDuration: 1)
        if let scene = PlanetCardScene(fileNamed: "PlanetCardScene") {
            scene.scaleMode = .aspectFit
            self.view?.presentScene(scene, transition: transition)
            scene.showWWDC = true
        }
    }
}
