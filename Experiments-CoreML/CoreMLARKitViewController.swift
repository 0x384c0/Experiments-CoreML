//
//  CoreMLARKitViewController.swift
//  Experiments-CoreML
//
//  Created by Andrew Ashurov on 11/1/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class CoreMLARKitViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var sceneView: ARSCNView!
    
    //MARK: UI Actions
    @IBAction func sceneTap(_ sender: Any) {
        addDominatingObjectToScene()
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        setup()
    }
    override func viewDidAppear(_ animated: Bool) {
        run()
    }
    override func viewWillDisappear(_ animated: Bool) {
        pause()
    }
    
    //MARK: Others
    let imageNNetHelper =  ImageNNetHelper()
    
    var latestPrediction = "TEST LABEL"
    let bubbleDepth : Float = 0.01 // the 'depth' of 3D text
    
    
    var orient:UIInterfaceOrientation!
    var viewportSize:CGSize!
    
    func setup(){
        
        orient = UIApplication.shared.statusBarOrientation
        viewportSize = sceneView.bounds.size
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene = SCNScene()
        sceneView.autoenablesDefaultLighting = true
        sceneView.preferredFramesPerSecond = 30
    }
    func run(){
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    func pause(){
        sceneView.session.pause()
    }
    func addDominatingObjectToScene(){
        let screenCentre : CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
        let arHitTestResults : [ARHitTestResult] = sceneView.hitTest(screenCentre, types: [.featurePoint]) // Alternatively, we could use '.existingPlaneUsingExtent' for more grounded hit-test-points.
        if let closestResult = arHitTestResults.first {
            // Get Coordinates of HitTest
            let transform : matrix_float4x4 = closestResult.worldTransform
            let worldCoord : SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            // Create 3D Text
            let node : SCNNode = createNewBubbleParentNode(latestPrediction)
            sceneView.scene.rootNode.addChildNode(node)
            node.position = worldCoord
        }
    }
    func createNewBubbleParentNode(_ text : String) -> SCNNode {
        // Warning: Creating 3D Text is susceptible to crashing. To reduce chances of crashing; reduce number of polygons, letters, smoothness, etc.
        
        // TEXT BILLBOARD CONSTRAINT
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
        // BUBBLE-TEXT
        let bubble = SCNText(string: text, extrusionDepth: CGFloat(bubbleDepth))
        var font = UIFont(name: "Futura", size: 0.15)
        font = font?.withTraits(traits: .traitBold)
        bubble.font = font
        bubble.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        bubble.firstMaterial?.diffuse.contents = UIColor.orange
        bubble.firstMaterial?.specular.contents = UIColor.white
        bubble.firstMaterial?.isDoubleSided = true
        // bubble.flatness // setting this too low can cause crashes.
        bubble.chamferRadius = CGFloat(bubbleDepth)
        
        // BUBBLE NODE
        let (minBound, maxBound) = bubble.boundingBox
        let bubbleNode = SCNNode(geometry: bubble)
        // Centre Node - to Centre-Bottom point
        bubbleNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
        // Reduce default text size
        bubbleNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
        
        // CENTRE POINT NODE
        let sphere = SCNSphere(radius: 0.005)
        sphere.firstMaterial?.diffuse.contents = UIColor.cyan
        let sphereNode = SCNNode(geometry: sphere)
        
        // BUBBLE PARENT NODE
        let bubbleNodeParent = SCNNode()
        bubbleNodeParent.addChildNode(bubbleNode)
        bubbleNodeParent.addChildNode(sphereNode)
        bubbleNodeParent.constraints = [billboardConstraint]
        
        return bubbleNodeParent
    }
    
    deinit { print("deinit \(type(of: self))") }
}


extension CoreMLARKitViewController: ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let pixelBuffer = sceneView.session.currentFrame?.capturedImage{
            
            let transform = sceneView.session.currentFrame!.displayTransform(for: orient, viewportSize: viewportSize).inverted()
            let pixelBuffer = pixelBuffer.transform(transform: transform)
            
            imageNNetHelper.predict(pixelBuffer: pixelBuffer) {[weak self] (classLabel, _) in
                guard let `self` = self else {return}
                self.latestPrediction = classLabel
            }
        }
    }
}


extension UIFont {
    // Based on: https://stackoverflow.com/questions/4713236/how-do-i-set-bold-and-italic-on-uilabel-of-iphone-ipad
    func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
}
