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
    
    // MARK: - Nodes
    var planetCardScene: PlanetCardScene!
    var scenesBackgroundNode: SKSpriteNode!
    
    var planetBackgroundNode: SKSpriteNode!
    var planetBackgroundPosition: CGPoint!
    var planetBackgroundScale: Scale!
    
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
        setupPlanetCardScene()
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
    
    private func setupPlanetCardScene() {
        let scale = Scale(x: 1, y: 1)
        planetCardScene = PlanetCardScene.loadBackground(with: scale, addBackgroundIn: planetBackgroundNode)
    }
    
    private func touchDown(touchedNode: SKNode) {
        print(type(of: touchedNode))
        animatePlanetToCenter { [weak self] in
            self?.planetCardScene.animatePlanet(for: .three) {
                self?.animatePlanetToOrigin(completion: nil)
            }
        }
    }
    
    private func allPlanetAnimations(completion: Completion?) {
        self.planetCardScene.animatePlanet(for: .one) { [weak self] in
            self?.run(SKAction.wait(forDuration: 2)) {
                self?.planetCardScene.animatePlanet(for: .two) {
                    self?.run(SKAction.wait(forDuration: 2)) {
                        self?.planetCardScene.animatePlanet(for: .three) {
                            self?.run(SKAction.wait(forDuration: 2)) {
                                self?.planetCardScene.animatePlanet(for: .four) {
                                    completion?()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func moveQuadrants() {
        planetCardScene.animateMoveTo(quadrant: .fourth, duration: 3.0) { [weak self] in
            self?.planetCardScene.animateMoveToOrigin(duration: 3.0, completion: nil)
        }
    }
    
    private func animatePlanetToCenter(completion: Completion?) {
        animatePlanetBackground(
            duration: Constants.Planet.timeToCenter,
            scale: Scale(x: 0.7, y: 0.7),
            position: .zero,
            completion: completion
        )
    }
    
    private func animatePlanetToOrigin(completion: Completion?) {
        animatePlanetBackground(
            duration: Constants.Planet.timeToOrigin,
            scale: planetBackgroundScale,
            position: planetBackgroundPosition,
            completion: completion
        )
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
