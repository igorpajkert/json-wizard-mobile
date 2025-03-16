//
//  MessageField.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 15/03/2025.
//

import SwiftUI

struct MessageField: View {
    
    @State private var message = ""
    
    @Environment(Chat.self) private var chat
    
    var body: some View {
        HStack {
            MessageTextField(
                placeholder: Text("text_enter_message"),
                text: $message
            )
            .frame(height: 52)
            .autocorrectionDisabled(true)
            .foregroundStyle(.black)
            
            Button {
                chat.sendMessage(with: message)
                message.clear()
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.accent)
                    .clipShape(Circle())
            }
            .disabled(message.isEmpty)
        }
        .padding(.horizontal)
        .background(Color.lightLavender)
        .cornerRadius(32)
        .padding()
    }
}

#Preview {
    MessageField()
        .environment(Chat())
}

struct MessageTextField: View {
    
    var placeholder: Text
    @Binding var text: String
    var onEditingChanged: (Bool) -> () = { _ in }
    var onCommit: () -> () = {}
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            if text.isEmpty {
                placeholder
                    .opacity(0.5)
            }
            
            TextField(
                "",
                text: $text,
                onEditingChanged: onEditingChanged,
                onCommit: onCommit
            )
        }
    }
}
