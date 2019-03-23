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

class PlanetCardScene: SKScene {
    
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
    
    static func loadBackground(size: CGSize? = nil) -> SKSpriteNode? {
        if let scene = SKScene(fileNamed: "PlanetCardScene") as? PlanetCardScene {
            let backgroundNode = scene.backgroundNode
            backgroundNode?.removeFromParent()
            backgroundNode?.resize(with: size)
            return backgroundNode
        }
        return nil
    }
}

extension SKSpriteNode {
    func resize(with size: CGSize?) {
        guard let size = size else { return }
        let xScale = size.width / self.size.width
        let yScale = size.height / self.size.height
        self.xScale = xScale
        self.yScale = yScale
    }
}
