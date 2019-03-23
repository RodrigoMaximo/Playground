//
//  GameScene.swift
//  Teste
//
//  Created by Rodrigo Maximo on 18/03/19.
//  Copyright © 2019 Rodrigo Maximo. All rights reserved.
//

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
    
    override func didMove(to view: SKView) {
        let size = CGSize(width: 350, height: 400)
        if let node = PlanetCardScene.loadBackground(size: size) {
            self.addChild(node)
        }
    }
    
    private func animatePlanet() {
        func animate() {
            let textures = [
                SKTexture(imageNamed: "happy-planet-2"),
                SKTexture(imageNamed: "happy-planet-3"),
                SKTexture(imageNamed: "happy-planet-4")
            ]
            let action = SKAction.animate(with: textures, timePerFrame: 0.3, resize: false, restore: false)
            planetNode.run(SKAction.wait(forDuration: 3.0)) { [weak self] in
                self?.planetNode.run(action)
            }
        }
        
        planetNode = SKSpriteNode(texture: SKTexture(imageNamed: "happy-planet-1"))
        planetNode.size.width *= 2
        planetNode.size.height *= 2
        self.addChild(planetNode)
        animate()
    }
    
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
