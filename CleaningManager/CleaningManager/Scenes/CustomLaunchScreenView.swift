//
//  CustomLaunchScreenView.swift
//  CleaningManager
//
import SwiftUI

struct CustomLaunchScreenView: View {
    @State private var isAnimating = false
    @State private var showMainApp = false
    @State private var opacity: Double = 1.0

    private let animationDistance: CGFloat = 70
    private let animationDuration: Double = 0.3

    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()

            Image("free-icon-wet-clean-7674995")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 171, height: 171)
                .offset(y: isAnimating ? -animationDistance : 0)
                .opacity(opacity)
                .animation(
                    .easeInOut(duration: animationDuration)
                    .repeatCount(4, autoreverses: true),
                    value: isAnimating
                )
        }
        .opacity(opacity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimating = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                withAnimation(.easeOut(duration: 0.2)) {
                    opacity = 0.0
                }
                withAnimation(.easeIn(duration: 0.3)) {
                    showMainApp = true
                }
            }
        }
        .fullScreenCover(isPresented: $showMainApp) {
            MainAppWrapperView()
        }
    }
}

// MARK: - Переход на главное приложение
struct MainAppWrapperView: View {
    @State private var destinationView: AnyView?

    var body: some View {
        Group {
            if let destinationView = destinationView {
                destinationView
            } else {
                ProgressView()
                    .onAppear(perform: determineDestination)
            }
        }
    }

    private func determineDestination() {
        Task {
            let isAuthenticated = await AuthService.shared.isAuthenticated()

            await MainActor.run {
                if isAuthenticated {
                    NotificationCenter.default.post(name: .userDidLogin, object: nil)
                } else {
                    NotificationCenter.default.post(name: .userDidLogout, object: nil)
                }
            }
        }
    }
}
