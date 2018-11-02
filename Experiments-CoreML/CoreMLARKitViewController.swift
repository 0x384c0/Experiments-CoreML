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

@available(iOS 11.0, *)
class CoreMLARKitViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var propsTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: UI Actions
    @IBAction func sceneTap(_ sender: Any) {
        if let latestPrediction = latestPrediction{
            arKitHelper.addLabel(text: latestPrediction)
        }
    }
    @IBAction func debuInfoSwitch(_ sender: UISwitch) {
        arKitHelper.showsStatistics = sender.isOn
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
        arKitHelper.planeFoundHandler = {[weak self] in
            guard let `self` = self else {return}
            self.activityIndicator.stopAnimating()
        }
    }
    private func makePrediction(_ pixelBuffer:CVPixelBuffer){
        if
            imageNNetHelper.isNNetFree{
            let pixelBuffer = pixelBuffer.transform(transform: arKitHelper.transform)
            imageNNetHelper.predict(pixelBuffer: pixelBuffer) {[weak self] (classLabel, sortedProps) in
                guard let `self` = self else {return}
                self.latestPrediction = classLabel
                self.classLabel.text = classLabel
                self.propsTextView.text = sortedProps.map{"\($0.value) \t\($0.key)"}.joined(separator: "\n")
            }
        }
    }
    
    
    deinit { print("deinit \(type(of: self))") }
}



