//
//  ContentView.swift
//  VolumeSwipe
//
//  Created by Dmitiy Myachin on 21.10.2023.
//

import SwiftUI

struct ContentView: View {
    @State var volume: Double = 0.1
    @State var lastVolume: Double = 0.1
    
    var body: some View {
        ZStack{
            Color.cyan.ignoresSafeArea()
                .overlay(alignment: .center) {
                    VolumeSlider()
                }
        }
        }
    }

struct VolumeSlider: View{
    @State var volume: Double = 0.1
    @State var lastVolume: Double = 0.1
    
    @State var overVolume: Double = 0
    
    var body: some View{
        GeometryReader{ proxi in
            let height = proxi.size.height
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(.white)
                        .scaleEffect(y: volume, anchor: .bottom)
                }
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            let currentVolume = lastVolume - value.translation.height / height
                            volume = max(min(1, currentVolume), 0)
                            
                            withAnimation {
                                overVolume = max(min(0.06, currentVolume - volume), -0.06)
                            }
                        })
                        .onEnded({ _ in
                            withAnimation {
                                overVolume = 0
                            }
                            lastVolume = volume
                        })
                )
                .clipShape(.rect(cornerSize: CGSize(width: 20, height: 20), style: .continuous))
                .scaleEffect(y: 1 + abs(overVolume), anchor: overVolume > 0 ? .bottom : .top)
                .scaleEffect(x: 1 - abs(overVolume), anchor: .center)
        }
        .frame(width: 85,height: 170)
        .offset(y: -overVolume * 250)
    }
}
    
    #Preview {
        ContentView()
    }
