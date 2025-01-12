//
//  ErrorView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 11/01/2025.
//

import SwiftUI

struct ErrorView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let errorWrapper: ErrorWrapper
    
    var body: some View {
        NavigationStack {
            errorContent
                .padding()
                .multilineTextAlignment(.center)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .toolbar {
                    toolbarDismissButton
                }
        }
        .padding()
    }
    
    private var errorContent: some View {
        VStack(spacing: 16) {
            Text("An error has occurred:")
                .font(.title)
            Text(errorWrapper.error.localizedDescription)
                .font(.headline)
            Divider()
                .padding()
            Text(errorWrapper.guidance)
                .font(.caption)
            actionButton
                .padding()
        }
    }
    
    private var actionButton: some View {
        Button(action: errorWrapperAction) {
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                Text(errorWrapper.dismissAction?.title ?? "Dismiss")
                    .foregroundStyle(.accent.adaptedTextColor())
            }
            .frame(width: 200, height: 44)
        }
    }
    
    // MARK: Toolbar
    private var toolbarDismissButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Dismiss") {
                errorWrapperAction()
            }
            .disabled(!errorWrapper.isDismissable)
        }
    }
    
    // MARK: - Intents
    private func errorWrapperAction() {
        guard let dismissAction = errorWrapper.dismissAction else { return dismiss() }
        dismissAction.action()
        dismiss()
    }
}

#Preview("No Action") {
    ErrorView(errorWrapper: ErrorWrapper(error: ErrorWrapper.SampleError.sample,
                                         guidance: "Try again",
                                         isDismissable: true))
}

#Preview("Sign In") {
    ErrorView(errorWrapper: ErrorWrapper(error: ErrorWrapper.SampleError.sample,
                                         guidance: "Sign into your account",
                                         isDismissable: false,
                                         dismissAction: ErrorWrapper.ErrorAction(title: "Sign In") {}))
}
