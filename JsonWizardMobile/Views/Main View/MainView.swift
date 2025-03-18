//
//  MainView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 07/02/2025.
//

import SwiftUI

struct MainView: View {
    
    @State private var viewModel = MainView.ViewModel()
    
    var body: some View {
        TabView {
            Tab("tab_categories", systemImage: "square.stack.3d.up") {
                NavigationStack {
                    CategoriesView()
                        .navigationTitle("title_categories")
                }
            }
            Tab("tab_all_questions", systemImage: "rectangle.stack") {
                NavigationStack {
                    QuestionsView(parentCategory: nil)
                        .navigationTitle("title_all_questions")
                }
            }
            Tab("tab_account", systemImage: "person.crop.circle") {
                NavigationStack {
                    AccountView()
                        .navigationTitle("title_account")
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
            if !viewModel.isUserSignedIn {
                viewModel.presentSignInSheet()
            }
        }
    }
}

#Preview {
    MainView()
}
