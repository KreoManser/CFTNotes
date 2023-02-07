import UIKit

extension UITextView {
    func newAttributesForTextView(for textView: UITextView, with attributes: [NSAttributedString.Key : UIFont]) {
        let range = textView.selectedRange
        let string = NSMutableAttributedString(attributedString: textView.attributedText)
        let attrs = attributes
        string.addAttributes(attrs, range: range)
        textView.attributedText = string
        textView.selectedRange = range
    }
}
