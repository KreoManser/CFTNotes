import Foundation

@objc(NSAttributedStringValueTransformer)
final class NSAttributedStringValueTransformer: NSSecureUnarchiveFromDataTransformer {

    static let name = NSValueTransformerName(rawValue: String(describing: NSAttributedString.self))

    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSAttributedString.self]
    }

    public static func register() {
        let transformer = NSAttributedStringValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
