import PlaygroundSupport
import SpriteKit

public func loadLiveView() {
    // Load the SKScene from 'GameScene.sks'
    let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 700, height: 800))
    
    if let scene = PlanetCardScene(fileNamed: "PlanetCardScene") {
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFit
        
        // Present the scene
        sceneView.presentScene(scene)
    }
    
    sceneView.ignoresSiblingOrder = false
    
    PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
}
