//
//  CustomScene.swift
//  Teste
//
//  Created by Rodrigo Maximo on 23/03/19.
//  Copyright © 2019 Rodrigo Maximo. All rights reserved.
//

import Foundation
import SpriteKit

protocol CustomScene {
    var backgroundNode: SKSpriteNode! { get set }
}

extension CustomScene {
    static func loadBackground(with scale: Scale? = nil, addBackgroundIn scene: SKNode) -> Self? {
        if let customScene = SKScene(fileNamed: String(describing: Self.self)) as? Self,
            let backgroundNode = customScene.backgroundNode
        {
            backgroundNode.removeFromParent()
            backgroundNode.resize(with: scale)
            scene.addChild(backgroundNode)
            return customScene
        }
        return nil
    }
    
    static func loadBackground(with size: CGSize? = nil, addBackgroundIn scene: SKNode) -> Self? {
        if let customScene = SKScene(fileNamed: String(describing: Self.self)) as? Self,
            let backgroundNode = customScene.backgroundNode
        {
            backgroundNode.removeFromParent()
            backgroundNode.resize(with: size)
            scene.addChild(backgroundNode)
            return customScene
        }
        return nil
    }
}
