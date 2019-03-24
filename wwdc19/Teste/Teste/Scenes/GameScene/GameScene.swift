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
    var waterScene2: WaterScene!
    
    // MARK: - Backgrounds
    var scenesBackgroundNode: SKSpriteNode!
    var planetBackgroundNode: SKSpriteNode!
    
    // MARK: - Planet information
    var planetBackgroundPosition: CGPoint!
    var planetBackgroundScale: Scale!
    
    var isProcessingTouch = false
    
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
    }
    
    private func setup() {
        setupBackgroundNodes()
        setupScenes()
        airScene.animateMoveTo(quadrant: .first, duration: 0.0, completion: nil)
        waterScene.animateMoveTo(quadrant: .second, duration: 0.0, completion: nil)
        waterScene2.animateMoveTo(quadrant: .third, duration: 0.0, completion: nil)
    }
    
    private func setupBackgroundNodes() {
        setupPlanetBackground()
        scenesBackgroundNode = self.childNode(withName: "scenesBackgroundNode") as? SKSpriteNode
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
        waterScene2 = WaterScene.loadBackground(with: scale, forParentNode: scenesBackgroundNode)
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
        default:
            break
        }
        if let scene = customScene, customScene?.selectionNode.isPaused == false {
            scene.animateMoveToOrigin(duration: Constants.timeBetweenAnimations) {
                self.isProcessingTouch = false
            }
            return true
        }
        return false
    }
    
    private func airSceneNextLevel(completion: Completion? = nil) {
        if airScene.isNextLevel {
            airScene.animateCleanSky { [weak self] in
                self?.animatePlanetToCenter {
                    self?.planetCardScene.animatePlanetToNextStage() {
                        self?.animatePlanetToOrigin() {
                            self?.airScene.animateMoveTo(quadrant: .first, duration: Constants.timeBetweenAnimations) {
                                self?.airScene.selectionNode.isPaused = true
                                // TODO: - visual for completion task
                                completion?()
                            }
                        }
                    }
                }
            }
        } else {
            completion?()
        }
    }
    
    private func waterSceneNextLevel(completion: Completion? = nil) {
        if waterScene.isNextLevel {
            self.waterScene.animateOceanCleaning { [weak self] in
                self?.animatePlanetToCenter {
                    self?.planetCardScene.animatePlanetToNextStage() {
                        self?.animatePlanetToOrigin() {
                            self?.waterScene.animateMoveTo(quadrant: .second, duration: Constants.timeBetweenAnimations) {
                                self?.waterScene.selectionNode.isPaused = true
                                completion?()
                            }
                        }
                    }
                }
            }
        } else {
            completion?()
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
    
    
    // MARK: - Old code
    
    private func atlasAnimation() {
        
        func animate() {
            let action = SKAction.animate(with: fishFrames, timePerFrame: 0.3, resize: false, restore: true)
            fishNode.run(SKAction.repeatForever(action))
        }
        
        let fishAtlas = SKTextureAtlas(named: "fish")
        fishFrames = fishAtlas.textureNames.map { fishAtlas.textureNamed($0) }
        fishNode = SKSpriteNode(texture: fishFrames.first)
        self.addChild(fishNode)
        animate()
    }
    
    private func video() {
        let filePath = Bundle.main.path(forResource: "animation", ofType: "mp4")!
        let url = URL(fileURLWithPath: filePath)
        self.bgVideoPlayer = AVPlayer(url: url)
        self.bgVideoPlayer.actionAtItemEnd = .none
        
        videoNode = SKVideoNode(avPlayer: self.bgVideoPlayer)
        videoNode.size = CGSize(width: 500, height: 250)
        videoNode.zPosition = -1
        videoNode.alpha = 1.0
        self.addChild(videoNode)
        videoNode.play()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
