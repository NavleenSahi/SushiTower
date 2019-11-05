import UIKit
import SpriteKit
import GameplayKit
import WatchConnectivity

class ViewController: UIViewController {
    


    override func viewDidLoad() {
        super.viewDidLoad()
        ////////end watch code
        
        let scene = GameScene(size:self.view.bounds.size)
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        
        // property to show hitboxes
        skView.showsPhysics = true
        
        skView.presentScene(scene)
    }
   
}

