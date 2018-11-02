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
        if let latestPrediction = latestPrediction{
            arKitHelper.addLabel(text: latestPrediction)
        }
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        arKitHelper.setup(sceneView: sceneView)
        setupNNet()
    }
    override func viewDidAppear(_ animated: Bool) {
        arKitHelper.start()
    }
    override func viewWillDisappear(_ animated: Bool) {
        arKitHelper.stop()
    }
    
    //MARK: Others
    private let
    imageNNetHelper = ImageNNetHelper(),
    arKitHelper = ARKitHelper()
    private var latestPrediction:String?
    
    private func setupNNet(){
        arKitHelper.didOutputHandler = {[weak self] pixelBuffer in
            guard let `self` = self else {return}
            self.makePrediction(pixelBuffer)
        }
    }
    private func makePrediction(_ pixelBuffer:CVPixelBuffer){
        if
            imageNNetHelper.isNNetFree{
            let pixelBuffer = pixelBuffer.transform(transform: arKitHelper.transform)
            imageNNetHelper.predict(pixelBuffer: pixelBuffer) {[weak self] (classLabel, _) in
                guard let `self` = self else {return}
                self.latestPrediction = classLabel
            }
        }
    }
    
    
    deinit { print("deinit \(type(of: self))") }
}



