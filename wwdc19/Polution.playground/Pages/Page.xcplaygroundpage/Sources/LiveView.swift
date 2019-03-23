import PlaygroundSupport
import SpriteKit

public func loadLiveView(width: CGFloat, height: CGFloat) {
    // Load the SKScene from 'GameScene.sks'
    let sceneView = SKView(frame: CGRect(x:0 , y:0, width: width, height: height))
    
    if let scene = StartScene(fileNamed: "StartScene") {
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFit
        
        // Present the scene
        sceneView.presentScene(scene)
    }
    
    sceneView.ignoresSiblingOrder = false
    
    PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
}
