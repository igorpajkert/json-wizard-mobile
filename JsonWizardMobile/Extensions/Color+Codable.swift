//
//  Color+Codable.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI
import UIKit

extension Color: Codable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let uiColor = UIColor(self)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        try container.encode(red, forKey: .red)
        try container.encode(green, forKey: .green)
        try container.encode(blue, forKey: .blue)
        try container.encode(alpha, forKey: .opacity)
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let red = try container.decode(CGFloat.self, forKey: .red)
        let green = try container.decode(CGFloat.self, forKey: .green)
        let blue = try container.decode(CGFloat.self, forKey: .blue)
        let opacity = try container.decode(CGFloat.self, forKey: .opacity)
        
        self = Color(red: red, green: green, blue: blue, opacity: opacity)
    }
    
    private enum CodingKeys: String, CodingKey {
        case red, green, blue, opacity
    }
}
