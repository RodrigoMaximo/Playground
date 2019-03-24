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
    
    func load() {
        backgroundNode = self.childNode(withName: "backgroundNode") as? SKSpriteNode
        skyNode = backgroundNode.childNode(withName: "skyNode") as? SKEmitterNode
        planetNode = backgroundNode.childNode(withName: "planetNode") as? SKSpriteNode
    }
    
    func triggerInitialActions() {}
    
    func animatePlanet(for stage: Stage, completion: Completion? = nil) {
        switch stage {
        case .one:
            animatePlanetStageOne(completion: completion)
        case .two:
            animatePlanetStageTwo(completion: completion)
        case .three:
            animatePlanetStageThree(completion: completion)
        case .four:
            animatePlanetStageFour(completion: completion)
        }
    }
    
    private func animatePlanetStageOne(completion: Completion?) {
        animatePlanet(forImageName: "sad-planet", completion: completion)
    }
    
    private func animatePlanetStageTwo(completion: Completion?) {
        animatePlanet(forImageName: "low-sad-planet", completion: completion)
    }
    
    private func animatePlanetStageThree(completion: Completion?) {
        animatePlanet(forImageName: "low-happy-planet", completion: completion)
    }
    
    private func animatePlanetStageFour(completion: Completion?) {
        animatePlanet(forImageName: "happy-planet", completion: completion)
    }
    
    private func animatePlanet(forImageName imageName: String, completion: Completion?) {
        let initialTexture = SKTexture(imageNamed: "\(imageName)-1")
        let textures = [
            SKTexture(imageNamed: "\(imageName)-2"),
            SKTexture(imageNamed: "\(imageName)-3"),
            SKTexture(imageNamed: "\(imageName)-4")
        ]
        planetNode.animate(with: textures, initialTexture: initialTexture, timePerFrame: Constants.Planet.timeInStageAnimation, completion: completion)
    }
}
