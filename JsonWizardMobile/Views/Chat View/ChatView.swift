//
//  ChatView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 15/03/2025.
//

import SwiftUI

struct ChatView: View {
    
    @State private var chat = Chat()
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(chat.messages) { message in
                        MessageBubble(
                            message: message,
                            showSender: chat.showSender(for: message)
                        )
                    }
                }
                .onChange(of: chat.lastMessageId) { oldId, newId in
                    withAnimation {
                        proxy.scrollTo(newId, anchor: .bottom)
                    }
                }
            }
        }
        
        MessageField()
            .environment(chat)
    }
}

#Preview {
    NavigationStack {
        ChatView()
            .navigationTitle("Chat")
    }
}
