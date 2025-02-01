//
//  UserData.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 17/01/2025.
//

import Foundation

@Observable
final class UserData: Identifiable, Codable, Equatable {
    
    let id: String
    let name: String
    let role: UserRole?
    
    init(id: String, name: String, role: UserRole? = nil) {
        self.id = id
        self.name = name
        self.role = role
    }
    
    // MARK: - Codable Conformance | Custom encoding & decoding
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(String.self, forKey: .id)
        
        // Decode role as a String and initialize the UserRole enum
        if let roleString = try container.decodeIfPresent(String.self, forKey: .role) {
            guard let role = UserRole(rawValue: roleString) else {
                throw DecodingError.dataCorruptedError(forKey: .role, in: container, debugDescription: "Invalid user role.")
            }
            self.role = role
        } else {
            self.role = nil
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        
        // Encode role as its rawValue (String) if not nil
        if let role = role {
            try container.encode(role.rawValue, forKey: .role)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, role
    }
    
    // MARK: - Equatable Conformance
    static func == (lhs: UserData, rhs: UserData) -> Bool {
        lhs.id == rhs.id
    }
}

enum UserRole: String, CaseIterable, Identifiable, Hashable, Codable, Nameable {
    
    case admin = "Admin"
    case author = "Creator"
    case user = "User"
    
    var name: String {
        rawValue
    }
    
    var id: String {
        name
    }
}
