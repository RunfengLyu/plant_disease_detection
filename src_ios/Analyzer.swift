//
//  Analyzer.swift
//  Chloris.AI
//
//  Created by Mathias Tahas on 02.10.22.
//

import CoreFoundation
import TensorFlowLite

func detectTomato(image: UIImage) -> [String:Double] {
    let modelPath = Bundle.main.path(forResource: "tf_model_tomato", ofType: "tflite")!
    let model = try! Interpreter(modelPath: modelPath)
    try! model.allocateTensors()
    let inputTensor = try! model.input(at: 0)
    let imageData = image.cgImage!.dataProvider!.data! as Data
    try! model.copy(imageData, toInputAt: 0)
    try! model.invoke()
    let outpurTensor = try! model.output(at: 0)
    return [:]
}
