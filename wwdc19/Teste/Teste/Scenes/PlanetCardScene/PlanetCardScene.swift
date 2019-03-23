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
    
    private let kTimePerFrame: TimeInterval = 0.5
    
    var backgroundNode: SKSpriteNode!
    var skyNode: SKEmitterNode!
    var planetNode: SKSpriteNode!
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        loadCard()
    }
    
    private func loadCard() {
        backgroundNode = self.childNode(withName: "backgroundNode") as? SKSpriteNode
        skyNode = backgroundNode.childNode(withName: "skyNode") as? SKEmitterNode
        planetNode = backgroundNode.childNode(withName: "planetNode") as? SKSpriteNode
        skyNode.isPaused = false
        skyNode.particleZPosition = 5
        skyNode.targetNode = backgroundNode
    }
    
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
        planetNode.animate(with: textures, initialTexture: initialTexture, timePerFrame: kTimePerFrame, completion: completion)
    }
}
