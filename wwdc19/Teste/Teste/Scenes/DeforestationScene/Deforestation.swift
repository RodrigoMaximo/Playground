//
//  Deforestation.swift
//  Teste
//
//  Created by Rodrigo Maximo on 24/03/19.
//  Copyright © 2019 Rodrigo Maximo. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class DeforestationScene: SKScene, CustomScene {
    
    var backgroundNode: SKSpriteNode!
    var noTreesNode: SKSpriteNode!
    var falledTrees: SKSpriteNode!
    var cloudsNode1: SKSpriteNode!
    var cloudsNode2: SKSpriteNode!
    var cloudsNode3: SKSpriteNode!
    var chainSawNode: SKSpriteNode!
    var treeNode1: SKSpriteNode!
    var treeNode2: SKSpriteNode!
    var treeNode3: SKSpriteNode!
    var treeNode4: SKSpriteNode!
    var treeNode5: SKSpriteNode!
    var treeNode6: SKSpriteNode!
    var targetNodes: [SKSpriteNode]!
    
    var objectsTouched: Int = 0
    var isNextLevel: Bool {
        return objectsTouched == 2
    }
    
    var selectionNode: SKSpriteNode!
    var backgroundCrop: SKSpriteNode!
    
    func load() {
        backgroundNode = self.childNode(withName: "backgroundNode") as? SKSpriteNode
        backgroundCrop = backgroundNode.childNode(withName: "backgroundCrop") as? SKSpriteNode
        noTreesNode = backgroundCrop.childNode(withName: "noTreesNode") as? SKSpriteNode
        falledTrees = backgroundCrop.childNode(withName: "falledTrees") as? SKSpriteNode
        cloudsNode1 = backgroundCrop.childNode(withName: "cloudsNode1") as? SKSpriteNode
        cloudsNode2 = backgroundCrop.childNode(withName: "cloudsNode2") as? SKSpriteNode
        cloudsNode3 = backgroundCrop.childNode(withName: "cloudsNode3") as? SKSpriteNode
        chainSawNode = backgroundCrop.childNode(withName: "chainSawNode") as? SKSpriteNode
        treeNode1 = backgroundCrop.childNode(withName: "treeNode1") as? SKSpriteNode
        treeNode2 = backgroundCrop.childNode(withName: "treeNode2") as? SKSpriteNode
        treeNode3 = backgroundCrop.childNode(withName: "treeNode3") as? SKSpriteNode
        treeNode4 = backgroundCrop.childNode(withName: "treeNode4") as? SKSpriteNode
        treeNode5 = backgroundCrop.childNode(withName: "treeNode5") as? SKSpriteNode
        treeNode6 = backgroundCrop.childNode(withName: "treeNode6") as? SKSpriteNode
        backgroundNode.isPaused = false
        targetNodes = [noTreesNode, chainSawNode]
        cropBackground()
    }
    
    func triggerInitialActions() {
        animateClouds()
        animateChainSaw()
    }
    
    private func animateClouds() {
        func actionCloud(duration: TimeInterval) -> SKAction {
            let fadeInAction = SKAction.fadeAlpha(to: 0.6, duration: 0)
            let firstAction = SKAction.moveTo(x: -600, duration: 0)
            let moveAction = SKAction.moveTo(x: 600, duration: duration)
            let actionFadeout = SKAction.fadeOut(withDuration: 0)
            return SKAction.sequence([fadeInAction, moveAction, actionFadeout, firstAction])
        }
        let action1 = actionCloud(duration: Constants.Deforestation.timeToCloud1)
        let action2 = actionCloud(duration: Constants.Deforestation.timeToCloud2)
        let action3 = actionCloud(duration: Constants.Deforestation.timeToCloud3)
        cloudsNode1.run(.repeatForever(action1))
        cloudsNode2.run(.repeatForever(action2))
        cloudsNode3.run(.repeatForever(action3))
    }
    
    private func animateChainSaw() {
        let movementValue = Constants.Deforestation.chainSawMovement
        let duration = Constants.Deforestation.timeToChain
        let actions: [SKAction] = [
            SKAction.moveBy(x: movementValue, y: 0, duration: duration),
            SKAction.moveBy(x: 0, y: movementValue, duration: duration),
            SKAction.moveBy(x: -movementValue, y: 0, duration: duration),
            SKAction.moveBy(x: 0, y: -movementValue, duration: duration)
        ]
        chainSawNode.run(SKAction.repeatForever(SKAction.sequence(actions)))
    }
    
    func touchTargets(node: SKNode, completion: ((Bool) -> Void)? = nil) {
        guard let node = node as? SKSpriteNode, targetNodes.contains(node) else {
            completion?(false)
            return
        }
        let hideAction = SKAction.fadeOut(withDuration: Constants.Deforestation.timeToHide)
        node.run(hideAction) { [weak self] in
            self?.objectsTouched += 1
            node.removeFromParent()
            completion?(true)
        }
    }
    
    func animatePlantTrees(completion: Completion? = nil) {
        let duration = Constants.Deforestation.timeToShowTree
        let action1 = SKAction.fadeIn(withDuration: duration)
        let action2 = SKAction.fadeIn(withDuration: duration)
        let action3 = SKAction.fadeIn(withDuration: duration)
        let action4 = SKAction.fadeIn(withDuration: duration)
        let action5 = SKAction.fadeIn(withDuration: duration)
        let action6 = SKAction.fadeIn(withDuration: duration)
        treeNode1.run(action1) { [weak self] in
            self?.treeNode2.run(action2) {
                self?.treeNode3.run(action3) {
                    self?.treeNode4.run(action4) {
                        self?.treeNode5.run(action5) {
                            self?.treeNode6.run(action6) {
                                completion?()
                            }
                        }
                    }
                }
            }
        }
    }
}
