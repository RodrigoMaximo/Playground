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
}

extension CustomScene {
    
    func animateMoveTo(quadrant: Quadrant, duration: TimeInterval, completion: Completion?) {
        let finalScale = Quadrant.scale
        let finalPoint = quadrant.coordinates(size: backgroundNode.size)
        animateMoveTo(point: finalPoint, finalScale: finalScale, duration: duration, completion: completion)
    }
    
    func animateMoveToOrigin(duration: TimeInterval, completion: Completion?) {
        let finalScale: CGFloat = 1.0
        let origin = CGPoint(x: 0, y: 0)
        animateMoveTo(point: origin, finalScale: finalScale, duration: duration, completion: completion)
    }
    
    fileprivate func animateMoveTo(point: CGPoint, finalScale: CGFloat, duration: TimeInterval, completion: Completion?) {
        guard let backgroundNode = backgroundNode else { return }
        let group = DispatchGroup()
        group.enter()
        backgroundNode.run(.move(to: point, duration: duration)) {
            group.leave()
        }
        group.enter()
        backgroundNode.run(.scale(to: finalScale, duration: duration)) {
            group.leave()
        }
        group.notify(queue: DispatchQueue.main, execute: completion ?? {})
    }
    
    
    /// Load the backgroundNode of the Scene.
    /// - Parameters:
    ///   - scale: This scale is the ratio between the backgroundNode and the scene in which it is been added.
    ///   - scene: Scene that will add this backgroundNode.
    /// - Returns: A scene with the backgroundNode and all the other nodes references.
    static func loadBackground(with scale: Scale? = nil, addBackgroundIn scene: SKNode) -> Self? {
        if let customScene = Self(fileNamed: String(describing: Self.self)),
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
