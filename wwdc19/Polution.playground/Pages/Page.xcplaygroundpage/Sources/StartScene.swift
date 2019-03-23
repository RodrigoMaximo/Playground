import SpriteKit
import GameplayKit
import AVFoundation
import PlaygroundSupport

class StartScene : SKScene {
    
    var planetNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        animatePlanet()
    }
    
    private func animatePlanet() {
        func animate() {
            let textures = [
                SKTexture(imageNamed: "happy-planet-2"),
                SKTexture(imageNamed: "happy-planet-3"),
                SKTexture(imageNamed: "happy-planet-4")
            ]
            let action = SKAction.animate(with: textures, timePerFrame: 0.3, resize: false, restore: false)
            planetNode.run(SKAction.wait(forDuration: 3.0)) { [weak self] in
                self?.planetNode.run(action)
            }
        }
        
        planetNode = self.childNode(withName: "planetNode") as? SKSpriteNode
        planetNode.size.width *= 2
        planetNode.size.height *= 2
        animate()
    }

}
