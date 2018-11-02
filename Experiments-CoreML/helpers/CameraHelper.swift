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
    var didOutputHandler:((CVPixelBuffer)->())?
    func setup(cameraView:UIView) -> Bool {
        //setup device
        let deviceMaybe = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        
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
        layer.frame = cameraView.frame
        cameraView.layer.addSublayer(layer)
        
        return true
    }
    
    func start(){
        session.startRunning()
    }
    func stop(){
        session.stopRunning()
    }
    
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
