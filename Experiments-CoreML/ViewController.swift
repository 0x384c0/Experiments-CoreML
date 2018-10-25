//
//  ViewController.swift
//  Experiments-CoreML
//
//  Created by Andrew Ashurov on 10/25/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var cameraView: UIView!
    
    //MARK: LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        setupCamera()
    }
    
    //MARK: Others
    let
    mobileNet =  MobileNet(),
    cameraHelper = CameraHelper()
    
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
}

