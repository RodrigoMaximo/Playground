//
//  CustomScene.swift
//  Teste
//
//  Created by Rodrigo Maximo on 23/03/19.
//  Copyright © 2019 Rodrigo Maximo. All rights reserved.
//

import Foundation
import SpriteKit

protocol CustomScene where Self: SKScene {
    var backgroundNode: SKSpriteNode! { get set }
    var backgroundCrop: SKSpriteNode! { get set }
    var selectionNode: SKSpriteNode! { get set }
    func load()
    func triggerInitialActions()
}

extension CustomScene {
    
    mutating func animateMoveTo(quadrant: Quadrant, duration: TimeInterval, completion: Completion?) {
        selectionNode = SKSpriteNode()
        selectionNode.size = self.size
        selectionNode.zPosition = 50
        backgroundNode.addChild(selectionNode)
        let finalScale = quadrant.scale
        let finalPoint = quadrant.coordinates(size: backgroundNode.size)
        animateMoveTo(point: finalPoint, finalScale: finalScale, duration: duration) { [weak self] in
            self?.backgroundNode.zPosition = 3
            completion?()
        }
    }
    
    func animateMoveToOrigin(duration: TimeInterval, completion: Completion?) {
        selectionNode.removeFromParent()
        backgroundNode.zPosition = 100
        let finalScale: Scale = Scale(x: 1.0, y: 1.0)
        let origin = CGPoint(x: 0, y: 0)
        animateMoveTo(point: origin, finalScale: finalScale, duration: duration, completion: completion)
    }
    
    fileprivate func animateMoveTo(point: CGPoint, finalScale: Scale, duration: TimeInterval, completion: Completion?) {
        guard let backgroundNode = backgroundNode else { return }
        backgroundNode.run(.move(to: point, duration: duration))
        backgroundNode.run(.scaleX(to: finalScale.x, duration: duration))
        backgroundNode.run(.scaleY(to: finalScale.y, duration: duration))
        backgroundNode.run(.wait(forDuration: duration), completion: completion ?? {})
    }
    
    
    /// Load the backgroundNode of the Scene.
    /// - Parameters:
    ///   - scale: This scale is the ratio between the backgroundNode and the scene in which it is been added.
    ///   - parentNode: Parent node that will add this backgroundNode.
    /// - Returns: A scene with the backgroundNode and all the other nodes references.
    static func loadBackground(with scale: Scale? = nil, forParentNode parentNode: SKNode) -> Self? {
        guard let customScene = Self(fileNamed: String(describing: Self.self)) else { return nil }
        customScene.load()
        guard let backgroundNode = customScene.backgroundNode else { return nil }
        backgroundNode.removeFromParent()
        backgroundNode.resize(with: scale)
        parentNode.addChild(backgroundNode)
        customScene.triggerInitialActions()
        return customScene
    }
    
    func cropBackground() {
        let cropNode = SKCropNode()
        cropNode.position = backgroundNode.position
        cropNode.zPosition = 0
        cropNode.maskNode = SKSpriteNode(color: .blue, size: backgroundNode.size)
        backgroundCrop.removeFromParent()
        cropNode.addChild(backgroundCrop)
        backgroundNode.addChild(cropNode)
    }
}
