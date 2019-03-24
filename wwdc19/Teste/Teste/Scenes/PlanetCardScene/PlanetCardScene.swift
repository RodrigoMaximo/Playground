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
    var backgroundCrop: SKSpriteNode!
    
    enum Stage: Int {
        case zero = 0
        case one
        case two
        case three
    }
    
    var backgroundNode: SKSpriteNode!
    var skyNode: SKEmitterNode!
    var planetNode: SKSpriteNode!
    var buttonNode: SKSpriteNode!
    var labelNode: SKLabelNode!
    
    var currentStage: Stage = .zero
    var showWWDC: Bool = false {
        didSet {
            if showWWDC { animateShowWWDC() }
        }
    }
    
    var selectionNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        load()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scene = self.scene!
        let touch = touches.first!
        let viewTouchLocation = touch.location(in: self)
        let touchedNode = scene.atPoint(viewTouchLocation)
        self.touchDown(touchedNode: touchedNode)
    }
    
    private func touchDown(touchedNode: SKNode) {
        presentGameScene()
    }
    
    private func presentGameScene() {
        let transition: SKTransition = SKTransition.fade(withDuration: 1)
        if let scene = GameScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFit
            self.view?.presentScene(scene, transition: transition)
        }
    }
    
    func load() {
        backgroundNode = self.childNode(withName: "backgroundNode") as? SKSpriteNode
        skyNode = backgroundNode.childNode(withName: "skyNode") as? SKEmitterNode
        planetNode = backgroundNode.childNode(withName: "planetNode") as? SKSpriteNode
        labelNode = backgroundNode.childNode(withName: "labelNode") as? SKLabelNode
        buttonNode = backgroundNode.childNode(withName: "buttonNode") as? SKSpriteNode
    }
    
    func triggerInitialActions() {}
    
    func animatePlanetToNextStage(completion: Completion? = nil) {
        backgroundNode.run(.wait(forDuration: 0.3)) { [unowned self] in
            switch self.currentStage {
            case .zero:
                self.animatePlanetStageOne(completion: completion)
            case .one:
                self.animatePlanetStageTwo(completion: completion)
            case .two:
                self.animatePlanetStageThree(completion: completion)
            case .three:
                return
            }
            self.currentStage = Stage(rawValue: self.currentStage.rawValue + 1) ?? .three
        }
    }
    
    private func animatePlanetStageOne(completion: Completion?) {
        animatePlanet(forImageName: "sad-planet", completion: completion, label: "Still Sad 😢", color: .red)
    }
    
    private func animatePlanetStageTwo(completion: Completion?) {
        animatePlanet(forImageName: "low-sad-planet", completion: completion, label: "Not happy Yet 😕", color: .orange)
    }
    
    private func animatePlanetStageThree(completion: Completion?) {
        animatePlanet(forImageName: "happy-planet", completion: completion, label: "Happy 😃💪", color: .green)
    }
    
    private func animatePlanet(forImageName imageName: String, completion: Completion?, label: String, color: UIColor) {
        let initialTexture = SKTexture(imageNamed: "\(imageName)-1")
        var textures = [
            SKTexture(imageNamed: "\(imageName)-2"),
            SKTexture(imageNamed: "\(imageName)-3"),
            SKTexture(imageNamed: "\(imageName)-4"),
            SKTexture(imageNamed: "\(imageName)-5")
        ]
        if imageName == "happy-planet" {
            textures.append(SKTexture(imageNamed: "\(imageName)-6"))
        }
        planetNode.run(.wait(forDuration: Constants.timeBetweenAnimations)) { [weak self] in
            self?.planetNode.animate(with: textures, initialTexture: initialTexture, timePerFrame: Constants.Planet.timeInStageAnimation) {
                self?.labelNode.text = label
                self?.labelNode.fontColor = color
                completion?()
            }
        }
    }
    
    func hideButton() {
        self.buttonNode.isHidden = true
        self.labelNode.fontColor = .red
        self.labelNode.text = "Sad 😭"
        self.planetNode.texture = SKTexture(imageNamed: "sad-planet-1")
    }
    
    func animateShowWWDC() {
        self.buttonNode.isHidden = false
        self.labelNode.fontColor = .white
        animateWWDC()
    }
    
    private func animateWWDC() {
        self.labelNode.text = "WWDC 2019 👩‍💻👨‍💻"
        self.buttonNode.isHidden = true
        self.labelNode.alpha = 0.0
        labelNode.run(SKAction.fadeIn(withDuration: 1.0)) { [weak self] in
            self?.labelNode.run(.wait(forDuration: 10.0)) {
                self?.labelNode.text = "Restart"
                self?.labelNode.fontColor = .black
                self?.buttonNode.isHidden = false
            }
        }
    }
}
