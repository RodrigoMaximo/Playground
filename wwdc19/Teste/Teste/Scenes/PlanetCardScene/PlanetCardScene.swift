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
    
    enum Stage: Int {
        case zero = 0
        case one
        case two
        case three
        case four
    }
    
    var backgroundNode: SKSpriteNode!
    var skyNode: SKEmitterNode!
    var planetNode: SKSpriteNode!
    var currentStage: Stage = .zero
    
    func load() {
        backgroundNode = self.childNode(withName: "backgroundNode") as? SKSpriteNode
        skyNode = backgroundNode.childNode(withName: "skyNode") as? SKEmitterNode
        planetNode = backgroundNode.childNode(withName: "planetNode") as? SKSpriteNode
    }
    
    func triggerInitialActions() {}
    
    func animatePlanetToNextStage(completion: Completion? = nil) {
        backgroundNode.run(.wait(forDuration: Constants.timeBetweenAnimations)) { [unowned self] in
            switch self.currentStage {
            case .zero:
                self.animatePlanetStageOne(completion: completion)
            case .one:
                self.animatePlanetStageTwo(completion: completion)
            case .two:
                self.animatePlanetStageThree(completion: completion)
            case .three:
                self.animatePlanetStageFour(completion: completion)
            case .four:
                return
            }
            self.currentStage = Stage(rawValue: self.currentStage.rawValue + 1) ?? .four
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
