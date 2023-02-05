//
//  SecureTransformer.swift
//  CFTNotes
//
//  Created by Сергей Бабич on 05.02.2023.
//

import Foundation

@objc(NSAttributedStringValueTransformer)
final class NSAttributedStringValueTransformer: NSSecureUnarchiveFromDataTransformer {

    static let name = NSValueTransformerName(rawValue: String(describing: NSAttributedString.self))

    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSAttributedString.self]
    }

    /// Registers the transformer.
    public static func register() {
        let transformer = NSAttributedStringValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
