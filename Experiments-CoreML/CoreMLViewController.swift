//
//  ViewController.swift
//  Experiments-CoreML
//
//  Created by Andrew Ashurov on 10/25/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import UIKit

class CoreMLViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var propsTextView: UITextView!
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        setupCamera()
        setupNN()
    }
    override func viewDidAppear(_ animated: Bool) {
        cameraHelper.start()
    }
    override func viewWillDisappear(_ animated: Bool) {
        cameraHelper.stop()
    }
    
    //MARK: Others
    private let imageNNetHelper = ImageNNetHelper()
    
    private let
    cameraHelper = CameraHelper()
    
    private func setupCamera(){
        if !cameraHelper.setup(cameraView: cameraView){
            let vc = UIAlertController(title: "Warning", message: "No camera", preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            present(vc, animated: true, completion: nil)
        }
    }
    private func setupNN(){
        cameraHelper.didOutputHandler = {[weak self] pixelBuffer in
            guard let `self` = self else {return}
            self.makePrediction(pixelBuffer)
        }
    }
    private func makePrediction(_ pixelBuffer:CVPixelBuffer){
        imageNNetHelper.predict(pixelBuffer: pixelBuffer, completion: {[weak self] (classLabel, sortedProps)  in
            guard let `self` = self else {return}
            self.classLabel.text = classLabel
            self.propsTextView.text = sortedProps.map{"\($0.value) \t\($0.key)"}.joined(separator: "\n")
        })
    }
    
    deinit { print("deinit \(type(of: self))") }
}
