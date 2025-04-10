//
//  MessageBubble.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 15/03/2025.
//

import SwiftUI

struct MessageBubble: View {
    
    @State private var showTime = false
    
    var message: Message
    var showSender: Bool = false
    
    var isSender: Bool {
        guard let userId = Authentication.shared.user?.uid else {
            return false
        }
        return userId == message.senderId ? true : false
    }
    
    var backgroundColor: Color {
        isSender ? Color.lavender : Color.lightLavender
    }
    
    var body: some View {
        VStack(alignment: isSender ? .trailing : .leading) {
            
            if showSender {
                Label(message.senderName, systemImage: "person.fill")
                    .font(.headline)
            }
            
            HStack {
                Text(message.text)
                    .padding()
                    .background(backgroundColor)
                    .foregroundStyle(backgroundColor.adaptedTextColor())
                    .clipShape(.rect(cornerRadius: 32))
            }
            .frame(maxWidth: 300, alignment: isSender ? .trailing : .leading)
            .onTapGesture {
                showTime.toggle()
            }
            
            if showTime {
                Text(String(message.timestamp.formatted(.dateTime.hour().minute())))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(isSender ? .trailing : .leading, 25)
            }
        }
        .frame(maxWidth: .infinity, alignment: isSender ? .trailing : .leading)
        .padding(isSender ? .trailing : .leading)
        .padding(.horizontal, 10)
    }
}

#Preview {
    MessageBubble(
        message: .init(
            text: "Hello! This is sample message text in my own chat view! How are you? I'm writing because I need longer sample text to see how it looks in my chat view. I hope it will be enough!",
            senderId: "DyVx5OHoR7eYTttZS5STsy2tn1D2",
            senderName: "Igor",
            timestamp: .distantPast
        ),
        showSender: true
    )
}
