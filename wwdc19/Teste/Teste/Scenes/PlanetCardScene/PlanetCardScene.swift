//
//  PlanetCard.swift
//  Teste
//
//  Created by Rodrigo Maximo on 22/03/19.
//  Copyright © 2019 Rodrigo Maximo. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class PlanetCardScene: SKScene, CustomScene {
    
    enum Stage {
        case one
        case two
        case three
        case four
    }
    
    var backgroundNode: SKSpriteNode!
    var skyNode: SKEmitterNode!
    var planetNode: SKSpriteNode!
    
    override func sceneDidLoad() {
        loadCard()
    }
    
    private func loadCard() {
        backgroundNode = self.childNode(withName: "backgroundNode") as? SKSpriteNode
        skyNode = backgroundNode.childNode(withName: "skyNode") as? SKEmitterNode
        planetNode = backgroundNode.childNode(withName: "planetNode") as? SKSpriteNode
    }
    
    func animatePlanet(for stage: Stage) {
        switch stage {
        case .one:
            animatePlanetStageOne()
        case .two:
            animatePlanetStageTwo()
        case .three:
            animatePlanetStageThree()
        case .four:
            animatePlanetStageFour()
        }
    }
    
    private func animatePlanetStageOne() {
        
    }
    
    private func animatePlanetStageTwo() {
        
    }
    
    private func animatePlanetStageThree() {
        planetNode.texture = SKTexture(imageNamed: "happy-planet-1")
        let textures = [
            SKTexture(imageNamed: "happy-planet-2"),
            SKTexture(imageNamed: "happy-planet-3"),
            SKTexture(imageNamed: "happy-planet-4")
        ]
        let action = SKAction.animate(with: textures, timePerFrame: 0.3, resize: false, restore: false)
        planetNode.run(SKAction.repeatForever(action))
    }
    
    private func animatePlanetStageFour() {
        
    }
}
