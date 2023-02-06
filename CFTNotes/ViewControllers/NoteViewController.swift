import UIKit
import PhotosUI

class NoteViewController: UIViewController {
    var delegate: NoteListViewControllerDelegate!
    var note: Note?

    lazy var noteTextView: UITextView = {
        var textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        textView.font = .systemFont(ofSize: 18)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard
            let userInfo: NSDictionary = notification.userInfo as? NSDictionary
        else { return }
        guard
            let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        else { return }
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        noteTextView.contentInset = contentInsets
        noteTextView.scrollIndicatorInsets = contentInsets
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        noteTextView.contentInset = .zero
        noteTextView.scrollIndicatorInsets = .zero
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                barButtonSystemItem: .save,
                target: self,
                action: #selector(saveNote)
            ),
            UIBarButtonItem(
                title: "_",
                style: .plain,
                target: self,
                action: #selector(addUnderlineStyle)
            ),
            UIBarButtonItem(
                title: "I",
                style: .plain,
                target: self,
                action: #selector(addItalicStyle)
            ),
            UIBarButtonItem(
                title: "B",
                style: .plain,
                target: self,
                action: #selector(addBoldStyle)
            ),
            UIBarButtonItem(
                title: "N",
                style: .plain,
                target: self,
                action: #selector(addNormalStyle)
            ),
            UIBarButtonItem(
                title: "Photo",
                style: .plain,
                target: self,
                action: #selector(addPhoto)
            )
        ]
        navigationController?.navigationBar.tintColor = .black
        navigationItem.largeTitleDisplayMode = .never
    }

    @objc
    private func saveNote() {
        let body = noteTextView.attributedText
        if note != nil {
            StorageManager.shared.update(note!, newBody: body ?? NSAttributedString(string: ""))
        } else {
            StorageManager.shared.create(body ?? NSAttributedString(string: ""))
        }
        delegate.reloadData()
        navigationController?.popViewController(animated: true)
    }
}

extension NoteViewController: PHPickerViewControllerDelegate {
    @objc
    private func addBoldStyle() {
        let range = noteTextView.selectedRange
        let string = NSMutableAttributedString(attributedString: noteTextView.attributedText)
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
        string.addAttributes(boldAttribute, range: range)
        noteTextView.attributedText = string
        noteTextView.selectedRange = range
    }

    @objc
    private func addItalicStyle() {
        let range = noteTextView.selectedRange
        let string = NSMutableAttributedString(attributedString: noteTextView.attributedText)
        let italicAttribute = [
            NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 18)
        ]
        string.addAttributes(italicAttribute, range: range)
        noteTextView.attributedText = string
        noteTextView.selectedRange = range
    }

    @objc
    private func addUnderlineStyle() {
        let range = noteTextView.selectedRange
        let string = NSMutableAttributedString(attributedString: noteTextView.attributedText)
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        string.addAttributes(underlineAttribute, range: range)
        noteTextView.attributedText = string
        noteTextView.selectedRange = range
    }

    @objc
    private func addNormalStyle() {
        let range = noteTextView.selectedRange
        let string = NSMutableAttributedString(attributedString: noteTextView.attributedText)
        let normalAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)
        ]
        string.addAttributes(normalAttribute, range: range)
        noteTextView.attributedText = string
        noteTextView.selectedRange = range
    }

    @objc
    private func addPhoto() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        for result in results {
            result.itemProvider.loadObject(
                ofClass: UIImage.self, completionHandler: { (object, error) in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async { [unowned self] in
                            guard let range = noteTextView.selectedTextRange else { return }
                            let cursorPosition = noteTextView.offset(
                                from: noteTextView.beginningOfDocument,
                                to: range.start
                            )
                            let attributedString = NSMutableAttributedString(
                                attributedString: noteTextView.attributedText
                            )
                            let textAttachment = NSTextAttachment()
                            textAttachment.image = image
                            guard let imageAttach = textAttachment.image else { return }
                            let scale = imageAttach.size.width / (noteTextView.frame.size.width - 40);
                            guard let cgImage = imageAttach.cgImage else { return }
                            textAttachment.image = UIImage(
                                cgImage: cgImage,
                                scale: scale,
                                orientation: .up
                            )
                            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                            attributedString.insert(attrStringWithImage, at: cursorPosition)
                            attributedString.insert(
                                NSAttributedString(
                                    string: "\n",
                                    attributes: [
                                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)
                                    ]
                                ), at: cursorPosition + 1
                            )
                            noteTextView.attributedText = attributedString
                        }
                    }
                }
            )
        }
    }
}

extension NoteViewController {
    private func setupUI() {
        view.backgroundColor = .white

        setSubviews(noteTextView)
    }

    private func setSubviews(_ subviews: UIView...) {
        subviews.forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        noteTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noteTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            noteTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
