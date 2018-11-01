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
    override func viewDidAppear(_ animated: Bool) {
        setupCamera()
        setupNN()
    }
    
    //MARK: Others
    let
    mobileNet =  MobileNet(),
    cameraHelper = CameraHelper()
    var isNNetFree = true
    
    func setupCamera(){
        let cameraFounded = cameraHelper.openSession()
        if cameraFounded{
            let layer = cameraHelper.layer
            layer.frame = cameraView.frame
            cameraView.layer.addSublayer(layer)
            view.layoutIfNeeded()
        } else {
            let vc = UIAlertController(title: "Warning", message: "No camera", preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            present(vc, animated: true, completion: nil)
        }
    }
    func setupNN(){
        cameraHelper.didOutputHandler = { pixelBuffer in
            DispatchQueue.global(qos: .background).async {
                if (self.isNNetFree){
                    self.isNNetFree = false
                    self.predictAndRender(pixelBuffer: pixelBuffer)
                    self.isNNetFree = true
                }
            }
        }
    }
    
    func predictAndRender(pixelBuffer:CVPixelBuffer){
        if  let pixelBuffer = ImageHelper.resize(pixelBuffer: pixelBuffer,to: CGSize(width: 224, height: 224)),
            let prediction = try? self.mobileNet.prediction(image: pixelBuffer){
            DispatchQueue.main.async {
                self.classLabel.text = prediction.classLabel
                let sortedProps = prediction.classLabelProbs.sorted(by: {$0.value > $1.value}).map{"\($0.value) \t\($0.key)"}
                self.propsTextView.text = sortedProps.joined(separator: "\n")
            }
        } else {
            print("predict error")
        }
    }
}
