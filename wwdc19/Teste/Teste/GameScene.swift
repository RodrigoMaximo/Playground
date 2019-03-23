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
    
    // MARK: - Nodes
    var planetCardScene: PlanetCardScene!
    
    override func didMove(to view: SKView) {
        let size = CGSize(width: 350, height: 400)
        planetCardScene = PlanetCardScene.loadBackground(size: size, addBackgroundIn: self)
        planetCardScene.animatePlanet(for: .three)
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
