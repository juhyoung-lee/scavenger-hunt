//
//  ARViewController.swift
//  DukeScavenger
//
//  Created by codeplus on 4/6/21.
//

import UIKit
import SceneKit
import ARKit
import AudioToolbox

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let vc = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        let sprite = vc.returnRiddleData(idnum: 101, select: "sprite")
        print(sprite)
        // Create a new scene
        let randomSelector = Int.random(in: 0...20)
        var sceneName = "art.scnassets/wilson-red-mango.usdz"
        /*
        if randomSelector == 1 {
            sceneName = "art.scnassets/bella-union.usdz"
        }
 */
        let scene = SCNScene(named: sceneName)!

        sceneView.scene = scene
        
        self.addSceneContent()
    }
    
    func addSceneContent() {

        let dummyNode = self.sceneView.scene.rootNode.childNode(withName: "DummyNode", recursively: true)
        
        let randomBin = Int.random(in: 0...1)
        var multiplier = 1
        if randomBin == 1 {
            multiplier = -1
        }
        let randomX = multiplier*Int.random(in: 2...10)
        let randomY = multiplier*Int.random(in: 2...10)
        let randomZ = multiplier*Int.random(in: 2...10)
        dummyNode?.position = SCNVector3(randomX, randomY, randomZ)
        dummyNode?.scale = SCNVector3(0.1, 0.1, 0.1)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                
        // Where exactly did this touch land in the sceneView's coordinate system?
        let location = touches.first!.location(in:sceneView)
                
        // Now that we know the 2D location in the scene view,
        // search the 3D scene for objects located along that line
        let hits = sceneView.hitTest(location,options: nil )
        
        if !hits.isEmpty {
            sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode() }
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
    }

    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
