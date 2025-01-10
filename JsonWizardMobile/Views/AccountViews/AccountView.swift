//
//  AccountView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 10/01/2025.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(.avatarIgor)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .shadow(radius: 4)
            Text("Igor Pajkert")
                .font(.title)
                .fontWeight(.semibold)
            Text("pajkert.igor@gmail.com")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("Administrator")
                .foregroundStyle(.secondary)
            Divider()
            Button("Edit Profile") {}
                .frame(minWidth: 150, minHeight: 35)
                .background(RoundedRectangle(cornerRadius: 64).fill(.accent))
                .foregroundStyle(.accent.adaptedTextColor())
            Spacer()
            Button("Log Out") {}
                .foregroundStyle(.red)
        }
        .padding()
    }
}

#Preview {
    AccountView()
}
