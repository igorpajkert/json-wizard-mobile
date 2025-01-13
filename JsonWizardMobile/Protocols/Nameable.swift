//
//  Nameable.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 08/01/2025.
//

import Foundation

/// A protocol that requires an entity to have a read-only `name` property.
///
/// Conforming types should provide a `name` string to describe or identify themselves.
protocol Nameable {
    /// The name of the conforming entity.
    var name: String { get }
}
