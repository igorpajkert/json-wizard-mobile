//
//  Color+Luminance.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI
import UIKit

extension Color {
    func luminance() -> Double {
        let uiColor = UIColor(self)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return 0.2126 * Double(red) + 0.7152 * Double(green) + 0.0722 * Double(blue)
    }
    
    func isLight() -> Bool {
        luminance() > 0.5
    }
    
    func adaptedTextColor() -> Color {
        isLight() ? Color.black : Color.white
    }
}
