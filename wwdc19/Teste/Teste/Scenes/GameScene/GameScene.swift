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
    var backgroundNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        setup()
    }
    
    private func setup() {
        backgroundNode = self.childNode(withName: "backgroundNode") as? SKSpriteNode
        let scale = Scale(x: 1, y: 1)
        planetCardScene = PlanetCardScene.loadBackground(with: scale, addBackgroundIn: backgroundNode)
    }
    
    private func allPlanetAnimations() {
        self.run(SKAction.wait(forDuration: 3)) { [weak self] in
            self?.planetCardScene.animatePlanet(for: .one) {
                self?.run(SKAction.wait(forDuration: 2)) {
                    self?.planetCardScene.animatePlanet(for: .two) {
                        self?.run(SKAction.wait(forDuration: 2)) {
                            self?.planetCardScene.animatePlanet(for: .three) {
                                self?.run(SKAction.wait(forDuration: 2)) {
                                    self?.planetCardScene.animatePlanet(for: .four)
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
