//
//  ExplainView.swift
//  Chloris.AI
//
//  Created by Mathias Tahas on 30.09.22.
//

import SwiftUI

struct ExplainView: View {
    
    @State private var phoneOffset = -400.0
    @State private var fingerOffset = 600.0
    @State private var showLoadingCircle = false
    @State private var showBadge = false
    @State private var done = false
    
    @Binding var tutorialDone: Bool
    
    var body: some View {
        ZStack {
            Color.white
            VStack(alignment: .center) {
                if done {
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
                ZStack {
                    Image("tomato_bush")
                        .scaleEffect(x: 0.5, y: 0.5, anchor: .center)
                    Image("phone")
                        .offset(x: phoneOffset, y: 0)
                    Image("leaf_green")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .mask {
                            Rectangle()
                                .frame(width: 290, height: 300)
                                .offset(x: phoneOffset, y: 0)
                        }
                    
                    if !done {
                        Image("hand_with_finger")
                            .offset(x: 15, y: fingerOffset)
                    }
                    
                    if (showLoadingCircle) {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(x: 3, y: 3, anchor: .center)
                    }
                    
                    if (showBadge) {
                        Image(systemName: "checkmark.seal")
                            .scaleEffect(x: 3, y: 3, anchor: .center)
                            .offset(x: 75, y: -75)
                            .foregroundColor(.green)
                    }
                    
                }.onAppear {
                    playAnimations()
                }
                
                if done {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            playAnimations()
                        }, label: {
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "repeat")
                                    .tint(.white)
                            }
                        })
                        Spacer()
                        Button(action: {
                            tutorialDone = true
                        }, label: {
                            ZStack {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "arrow.right")
                                    .tint(.white)
                            }
                        })
                        Spacer()
                    }
                    Spacer()
                }
            }
        }.onTapGesture {
            tutorialDone = true
        }
    }
    
    func playAnimations() {
        phoneOffset = -400.0
        fingerOffset = 600.0
        showLoadingCircle = false
        showBadge = false
        done = false
        
        withAnimation(.linear(duration: 1.5).delay(1.5)) {
            phoneOffset = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.linear(duration: 1)) {
                fingerOffset = 275
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            showLoadingCircle = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            showLoadingCircle = false
            showBadge = true
            done = true
        }
    }
}

struct ExplainView_Previews: PreviewProvider {
    static var previews: some View {
        ExplainView(tutorialDone: .constant(false))
    }
}
