//
//  MainView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 07/02/2025.
//

import SwiftUI

struct MainView: View {
    
    @State private var viewModel = MainView.ViewModel()
    
    var isTesting = false
    
    var body: some View {
        TabView {
            TabSection("section_modes") {
                Tab("tab_main_mode", systemImage: "square.stack.3d.up") {
                    NavigationStack {
                        MainModeView()
                    }
                }
                Tab("tab_swipe_mode", systemImage: "square.stack") {
                    NavigationStack {
                        SwipeModeView()
                    }
                }
            }
            Tab("tab_account", systemImage: "person.crop.circle") {
                NavigationStack {
                    AccountView()
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .sheet(item: $viewModel.errorWrapper) { wrapper in
            ErrorSheet(errorWrapper: wrapper)
        }
        .sheet(
            isPresented: $viewModel.isPresentingSignInSheet,
            onDismiss: viewModel.dismissSignInSheet
        ) {
            SignInSheet()
        }
        .task {
            if !viewModel.isUserSignedIn && !isTesting {
                viewModel.presentSignInSheet()
            }
        }
    }
}

#Preview {
    MainView(isTesting: true)
}
