//
//  Animate+SKSpriteNode.swift
//  Teste
//
//  Created by Rodrigo Maximo on 23/03/19.
//  Copyright © 2019 Rodrigo Maximo. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    func animate(with textures: [SKTexture], initialTexture: SKTexture?, timePerFrame: TimeInterval, completion: (() -> Void)?) {
        self.texture = initialTexture
        let action = SKAction.animate(with: textures, timePerFrame: timePerFrame, resize: false, restore: false)
        self.run(action, completion: completion ?? {})
    }
}
