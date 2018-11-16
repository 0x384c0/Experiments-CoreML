//import CreateML
//import Foundation
//
//let project_dir = "~/Desktop/image_classifier/tmp/"
//
//print("init MLImageClassifier")
//let trainingDataPath = project_dir + "Training_Data/"
//let trainingData = MLImageClassifier.DataSource.labeledDirectories(at: URL(fileURLWithPath: trainingDataPath))
//let parameter = MLImageClassifier.ModelParameters(maxIterations: 20, augmentationOptions:  .allOptions )
//let model = try MLImageClassifier(
//    trainingData: trainingData,
//    parameters:parameter)
//
//print("validation")
//let testingDataPath = Bundle.main.path(forResource: "Testing_Data", ofType: nil, inDirectory: ".")!
//let testingData = MLImageClassifier.DataSource.labeledDirectories(at: URL(fileURLWithPath: testingDataPath))
//model.evaluation(on: testingData)
//
//print("saving")
//try model.write(toFile: project_dir + "imageClassifier.mlmodel")

import CreateMLUI

let builder = MLImageClassifierBuilder()
builder.showInLiveView() // open assistaint editor

