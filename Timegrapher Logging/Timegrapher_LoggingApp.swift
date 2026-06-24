//
//  Timegrapher_LoggingApp.swift
//  Timegrapher Logging
//
//  Created by Dan on 6/22/26.
//

import SwiftUI

@main
struct TimegrapherLoggingApp: App {
    @State private var isActive = false

    var body: some Scene {
        WindowGroup {
            if isActive {
                ContentView()
            } else {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isActive = true
                            }
                        }
                    }
            }
        }
    }
}

struct SplashView: View {
    @State private var titleOpacity = 0.0
    @State private var scale: CGFloat = 0.85

    var body: some View {
        ZStack {
            // Background using the two-color watch mechanics cover image, scaled to cover entire screen
            Image("splash_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Text("Timegrapher Logging")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.black)
                    .shadow(color: .white, radius: 3, x: 0, y: 0)
                    .shadow(color: .white, radius: 3, x: 0, y: 0)
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                    .opacity(titleOpacity)
                    .scaleEffect(scale)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.85))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                titleOpacity = 1.0
                scale = 1.0
            }
        }
    }
}

