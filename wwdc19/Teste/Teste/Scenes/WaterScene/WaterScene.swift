//
//  WaterScene.swift
//  Teste
//
//  Created by Rodrigo Maximo on 24/03/19.
//  Copyright © 2019 Rodrigo Maximo. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class WaterScene: SKScene, CustomScene {
    
    var backgroundNode: SKSpriteNode!
    var wasteNode1: SKSpriteNode!
    var wasteNode2: SKSpriteNode!
    var oceanNode1: SKSpriteNode!
    var oceanNode2: SKSpriteNode!
    var oceanNode3: SKSpriteNode!
    var oceanNode4: SKSpriteNode!
    var canNode1: SKSpriteNode!
    var canNode2: SKSpriteNode!
    var bottleNode: SKSpriteNode!
    var oilNode: SKSpriteNode!
    var fishNode1: SKSpriteNode!
    var fishNode2: SKSpriteNode!
    var fishNode3: SKSpriteNode!
    var trashNodes: [SKSpriteNode]!
    
    var objectsTouched: Int = 0
    var isNextLevel: Bool {
        return objectsTouched == 6
    }
    
    var selectionNode: SKSpriteNode!
    
    func load() {
        backgroundNode = self.childNode(withName: "backgroundNode") as? SKSpriteNode
        wasteNode1 = backgroundNode.childNode(withName: "wasteNode1") as? SKSpriteNode
        wasteNode2 = backgroundNode.childNode(withName: "wasteNode2") as? SKSpriteNode
        oceanNode1 = backgroundNode.childNode(withName: "oceanNode1") as? SKSpriteNode
        oceanNode2 = backgroundNode.childNode(withName: "oceanNode2") as? SKSpriteNode
        oceanNode3 = backgroundNode.childNode(withName: "oceanNode3") as? SKSpriteNode
        oceanNode4 = backgroundNode.childNode(withName: "oceanNode4") as? SKSpriteNode
        canNode1 = backgroundNode.childNode(withName: "canNode1") as? SKSpriteNode
        canNode2 = backgroundNode.childNode(withName: "canNode2") as? SKSpriteNode
        bottleNode = backgroundNode.childNode(withName: "bottleNode") as? SKSpriteNode
        oilNode = backgroundNode.childNode(withName: "oilNode") as? SKSpriteNode
        fishNode1 = backgroundNode.childNode(withName: "fishNode1") as? SKSpriteNode
        fishNode2 = backgroundNode.childNode(withName: "fishNode2") as? SKSpriteNode
        fishNode3 = backgroundNode.childNode(withName: "fishNode3") as? SKSpriteNode
        backgroundNode.isPaused = false
        trashNodes = [wasteNode1, wasteNode2, canNode1, canNode2, oilNode, bottleNode]
    }
    
    func triggerInitialActions() {
        
    }
    
    func touchTrash(node: SKNode, completion: ((Bool) -> Void)? = nil) {
        guard let node = node as? SKSpriteNode, trashNodes.contains(node) else {
            completion?(false)
            return
        }
        let hideAction = SKAction.fadeOut(withDuration: Constants.Water.timeToHideTrash)
        node.run(hideAction) { [weak self] in
            self?.objectsTouched += 1
            node.removeFromParent()
            completion?(true)
        }
    }
}
