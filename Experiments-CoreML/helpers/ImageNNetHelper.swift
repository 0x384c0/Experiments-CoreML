//
//  NNetHelper.swift
//  Experiments-CoreML
//
//  Created by Andrew Ashurov on 11/2/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import CoreVideo


@available(iOS 11.0, *)
class ImageNNetHelper {
    private(set) var isNNetFree = true
    typealias ImageNNetHelperCompletion = (String,[(key:String, value:Double)]) -> ()
    func predict(pixelBuffer:CVPixelBuffer,completion:@escaping ImageNNetHelperCompletion){
        DispatchQueue.global(qos: .background).async {[weak self] in
            guard let `self` = self else {return}
            if (self.isNNetFree){
                self.isNNetFree = false
                self.predictAndSort(pixelBuffer: pixelBuffer,completion:completion)
                self.isNNetFree = true
            }
        }
    }
    
    
    
    
    static var useCustomModel = false
    private let
    mobileNet = MobileNet(),
    customImageClassifier = CustomImageClassifier(),
    imageSize = CGSize(width: 224, height: 224)
    
    private func predictAndSort(pixelBuffer:CVPixelBuffer,completion:@escaping ImageNNetHelperCompletion){
        do {
            if ImageNNetHelper.useCustomModel{
                if  let pixelBuffer = ImageHelper.resize(pixelBuffer: pixelBuffer,to: imageSize){
                    let prediction = try customImageClassifier.prediction(image: pixelBuffer)
                    let sortedProps = prediction.classLabelProbs.sorted(by: {$0.value > $1.value})
                    DispatchQueue.main.async {
                        completion(prediction.classLabel, sortedProps)
                    }
                } else {
                    print("ImageNNetHelper predict error")
                }
            } else {
                if  let pixelBuffer = ImageHelper.resize(pixelBuffer: pixelBuffer,to: imageSize){
                    let prediction = try mobileNet.prediction(image: pixelBuffer)
                    let sortedProps = prediction.classLabelProbs.sorted(by: {$0.value > $1.value})
                    DispatchQueue.main.async {
                        completion(prediction.classLabel, sortedProps)
                    }
                } else {
                    print("ImageNNetHelper predict error")
                }
            }
        } catch {
            print(error)
        }
    }
    
    
}


