//
//  ErrorSheet.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 11/01/2025.
//

import SwiftUI

struct ErrorSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let errorWrapper: ErrorWrapper
    
    var body: some View {
        NavigationStack {
            ScrollView {
                errorContent
                    .multilineTextAlignment(.center)
                    .navigationTitle("title_error")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        toolbarDismissButton
                    }
                    .padding()
            }
        }
    }
    
    private var errorSymbol: some View {
        Image(systemName: "xmark.circle")
            .font(.title)
            .imageScale(.large)
            .foregroundStyle(.red)
    }
    
    private var errorContent: some View {
        VStack(spacing: 16) {
            errorSymbol
                .padding(.top)
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
                Text(errorWrapper.dismissAction?.title ?? "button_dismiss")
                    .foregroundStyle(.accent.adaptedTextColor())
                    .padding()
            }
        }
        .padding()
    }
    
    // MARK: Toolbar
    private var toolbarDismissButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("button_dismiss") {
                dismiss()
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
    ErrorSheet(errorWrapper: ErrorWrapper(
        error: ErrorWrapper.SampleError.sample,
        guidance: "Try again later.",
        isDismissable: true))
}

#Preview("Sign In") {
    ErrorSheet(errorWrapper: ErrorWrapper(
        error: ErrorWrapper.SampleError.sample,
        guidance: "Sign into your account.",
        isDismissable: false,
        dismissAction: ErrorWrapper.ErrorAction(title: "Sign In") {}))
}
