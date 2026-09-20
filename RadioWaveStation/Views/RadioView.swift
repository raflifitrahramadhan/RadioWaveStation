//
//  RadioView.swift
//  RadioWaveStation
//
//  Created by Rafli Ramadhan on 31/08/26.
//


import SwiftUI

struct RadioView: View {
    @StateObject var viewModel = RadioViewModel()
    
    var backgroundText = LinearGradient(
        colors: [.white, .white.opacity(0.6)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                ZStack {
                    Image("PinkRadio")
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 350, height: 250)
                        .position(x: 200, y: 450)
                    
                    Button(action: { viewModel.togglePower() }) {
                        Image(viewModel.powerImageName)
                            .resizable()
                            .interpolation(.none)
                            .frame(width: 24, height: 24)
                    }
                    .position(x: 130, y: 410)
                    
                    effectButton(for: .underwater, x: 240, y: 410)
                    effectButton(for: .reverb, x: 260, y: 410)
                    effectButton(for: .delay, x: 280, y: 410)
                    
                    
                    Image("VolumeKnob")
                        .resizable()
                        .interpolation(.none)
                        .frame(width: 40, height: 40)
                        .rotationEffect(.degrees((viewModel.volume * 270) - 135))
                        .position(x: 273, y: 510)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let startValue = viewModel.volume
                                    let change = Double(-value.translation.height / 200)
                                    viewModel.updateVolume(to: startValue + change)
                                }
                        )
                    
                    Image("VolumeEffectKnob")
                        .resizable()
                        .interpolation(.none)
                        .frame(width: 40, height: 40)
                        .rotationEffect(.degrees((viewModel.effectMix * 270) - 135))
                        .position(x: 330, y: 510)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let startValue = viewModel.effectMix
                                    let change = Double(-value.translation.height / 200)
                                    viewModel.updateEffectMix(to: startValue + change)
                                }
                        )
                }
                VStack(spacing: -10) {
                    Text("Radio Wave")
                        .font(.custom("Monocraft", size: 30))
                        .fontWeight(.bold)
                        .offset(y: -610)
                    
                    Text("Station")
                        .font(.custom("Monocraft", size: 60))
                        .fontWeight(.heavy)
                        .offset(y: -610)
                    
                    Text("built for slow mornings")
                        .font(.custom("Monocraft", size: 20))
                        .fontWeight(.semibold)
                        .offset(y: -600)
                    
            }
                .foregroundStyle(backgroundText)
            
          
            }
            
        }
        
    }
    
    @ViewBuilder
    func effectButton(for type: AudioEffectType, x: CGFloat, y: CGFloat) -> some View {
        let isActive = viewModel.isEffectActive(type)
        
        Button(action: { viewModel.toggleEffect(type) }) {
            Image(viewModel.effectImageName(for: type))
                .resizable()
                .interpolation(.none)
                .frame(width: 16, height: 16)
                .offset(y: isActive ? 3 : 0)
                .shadow(color: isActive ? .clear : .black.opacity(0.5), radius: 0, x: 0, y: 2)
        }
        .position(x: x, y: y)
    }
}

#Preview {
    RadioView()
}
