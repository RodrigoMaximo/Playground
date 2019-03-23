import SpriteKit
import GameplayKit
import AVFoundation
import PlaygroundSupport

class StartScene : SKScene {
    
    var node: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        node = SKSpriteNode(color: #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), size: CGSize(width: 200, height: 200))
        self.addChild(node)
    }

}
