//
//  ContentView.swift
//  Chloris.AI
//
//  Created by Mathias Tahas on 30.09.22.
//

import SwiftUI

struct ContentView: View {
    
    @State var cameraImage: UIImage?
    @State var tutorialDone = false
    @State var entity: Entity?
    
    var body: some View {
        if !tutorialDone {
            ExplainView(tutorialDone: $tutorialDone)
        } else if let image = cameraImage {
            MainView(entity: entity!, image: image, cameraImage: $cameraImage)
        } else {
            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    RecordView(image: $cameraImage)
                    ZStack {
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: geometry.size.width, height: geometry.size.height - 108)
                            .offset(x: 0, y: 0)
                            .opacity(0.5)
                        
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 400, height: 400)
                            .offset(x: 0, y: 0)
                            .blendMode(.destinationOut)
                            
                        if entity != nil {
                            Image("leaf_me")
                                .frame(width: 114, height: 81)
                                .scaleEffect(x: 0.5, y: 0.5, anchor: .center)
                                .tint(.black)
                                .offset(x: 0, y: 0)
                                .opacity(0.5)
                        }
                    }
                    
                    if entity != nil {
                        Button(action: {
                            entity = nil
                        }) {
                            Image(systemName: "x.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .tint(Color.white)
                        }.position(x: 30, y: 30)
                    }
                    
                    if entity == nil {
                        ZStack {
                            Color.clear.allowsHitTesting(false)
                            HStack {
                                Spacer()
                                Button(action: {
                                    entity = .Tomato
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 150, height: 150)
                                        Image("tomato")
                                            .resizable()
                                            .frame(width: 75, height: 75)
                                        
                                    }
                                }
                                Spacer()
                                Button(action: {
                                    entity = .Cocoa
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 150, height: 150)
                                        Image("cocoa")
                                            .resizable()
                                            .frame(width: 75, height: 75)
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
