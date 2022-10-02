//
//  MainView.swift
//  Chloris.AI
//
//  Created by Mathias Tahas on 01.10.22.
//

import SwiftUI

struct MainView: View {
    
    @State var entity: Entity
    @State var image: UIImage
    @Binding var cameraImage: UIImage?
    
    @State var doneProcessing = false
    @State var isHealthy = false
    @State var confidence: Int = 0
    @State var prediction: String?
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            
            if !doneProcessing {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(x: 2, y: 2, anchor: .center)
            } else {
                VStack {
                    if !isHealthy {
                        Link(destination: URL(string: tomatoDiseaseHelpLinks[prediction!]!)!) {
                            HStack(spacing: 10) {
                                Text(prediction!)
                                Image(systemName: "info.circle.fill")
                            }
                        }
                    }
                    Text("\(String(confidence))%")
                    
                    Spacer()
                    
                    if isHealthy {
                        Image(systemName: "checkmark.seal")
                    } else {
                        Image("danger")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        reset()
                    }, label: {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "repeat")
                                .tint(.white)
                        }
                    })
                }
            }
        }.task {
            let receivedResult = await uploadImage(image: image, entity: entity)
            // let test = detectTomato(image: image)
            let max = receivedResult.max { a, b in a.value < b.value }!
            
            confidence = Int((max.value * 100.0).rounded())
            
            if max.key == tomatoHealthyLabel  {
                isHealthy = true
            } else {
                isHealthy = false
                prediction = String(max.key.dropFirst(9))
            }
            
            doneProcessing = true
        }
    }
    
    func reset() {
        cameraImage = nil
        doneProcessing = false
        isHealthy = false
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(entity: .Tomato, image: UIImage(systemName: "checkmark.seal")!, cameraImage: .constant(nil))
    }
}
