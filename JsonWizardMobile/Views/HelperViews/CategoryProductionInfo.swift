//
//  CategoryProductionInfo.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 03/03/2025.
//

import SwiftUI

struct CategoryProductionInfo: View {
    
    let lastTransferDate: Date?
    let needsUpdate: Bool
    
    var transferDate: String {
        lastTransferDate?.toString() ?? String(localized: "None")
    }
    
    var body: some View {
        Section("section_production_info") {
            HStack {
                Text("text_last_transfer")
                Spacer()
                Text(transferDate)
                    .foregroundStyle(.secondary)
            }
            if lastTransferDate != nil {
                HStack {
                    Text("text_needs_update")
                    Spacer()
                    Text(needsUpdate ? String(localized: "Yes") : String(localized: "No"))
                        .foregroundStyle(needsUpdate ? .red : .green)
                }
            }
        }
    }
}
#Preview("No Data") {
    Form {
        CategoryProductionInfo(lastTransferDate: nil, needsUpdate: false)
    }
}

#Preview("With Data") {
    Form {
        CategoryProductionInfo(lastTransferDate: Date.now, needsUpdate: true)
    }
}
