//
//  CameraHelper.swift
//  Experiments-CoreML
//
//  Created by Andrew Ashurov on 10/25/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import AVFoundation
import UIKit

class CameraHelper: NSObject{
    //MARK: basic camera functions
    var didOutputHandler:((CVPixelBuffer)->())?
    func setup(cameraView:UIView) -> Bool {
        self.cameraView = cameraView
        //setup device
        var deviceMaybe:AVCaptureDevice?
        if #available(iOS 10.0, *) {
            deviceMaybe = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        } else {
            deviceMaybe = AVCaptureDevice.devices(for: .video)
                .map { $0 }
                .filter { $0.position == .back}
                .first
        }
        
        guard let device = deviceMaybe else {
            return false
        }
        let input = try! AVCaptureDeviceInput(device: device)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: sampleQueue)
        
        session.beginConfiguration()
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        session.commitConfiguration()
        let settings: [AnyHashable: Any] = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: Int(kCVPixelFormatType_32BGRA)]
        output.videoSettings = settings as? [String : Any]
        
        
        //add video layer
        layer.videoGravity = .resizeAspectFill
        layer.backgroundColor = UIColor.black.cgColor
        
        cameraView.layer.addSublayer(layer)
        
        return true
    }
    
    func start(){
        cameraView.setNeedsLayout()
        cameraView.layoutIfNeeded()
        layer.bounds = cameraView.bounds
        layer.frame = cameraView.frame
        layer.position = CGPoint(x: cameraView.bounds.midX, y: cameraView.bounds.midY)
        
        session.startRunning()
    }
    func stop(){
        session.stopRunning()
    }
    
    //MARK: private
    private weak var cameraView:UIView!
    private let layer = AVSampleBufferDisplayLayer()
    private var session = AVCaptureSession()
    private let sampleQueue = DispatchQueue(label: "CameraHelper.sampleQueue", attributes: [])
    
}


extension CameraHelper : AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = .portrait
        layer.enqueue(sampleBuffer)
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer){
            didOutputHandler?(pixelBuffer)
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("didDrop sampleBuffer")
    }
}
