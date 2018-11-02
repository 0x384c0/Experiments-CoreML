//
//  CameraViewController.swift
//  Experiments-CoreML
//
//  Created by Andrew Ashurov on 11/2/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        setupCamera()
    }
    override func viewDidAppear(_ animated: Bool) {
        cameraHelper.start()
    }
    override func viewWillDisappear(_ animated: Bool) {
        cameraHelper.stop()
    }
    
    //MARK: Others
    private let
    cameraHelper = CameraHelper()
    private func setupCamera(){
        if !cameraHelper.setup(cameraView: self.view){
            let vc = UIAlertController(title: "Warning", message: "No camera", preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            present(vc, animated: true, completion: nil)
        }
    }
}
