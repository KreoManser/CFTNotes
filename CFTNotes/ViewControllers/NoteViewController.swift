//
//  NoteViewController.swift
//  CFTNotes
//
//  Created by Сергей Бабич on 03.02.2023.
//

import UIKit

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
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
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
                action: #selector(underlineStyle)
            ),
            UIBarButtonItem(
                title: "I",
                style: .plain,
                target: self,
                action: #selector(italicStyle)
            ),
            UIBarButtonItem(
                title: "B",
                style: .plain,
                target: self,
                action: #selector(boldStyle)
            ),
        ]
        navigationController?.navigationBar.tintColor = .black
    }

    @objc
    private func saveNote() {
        let title = noteTextView.text?.components(separatedBy: "\n")[0]
        /// Изменить принцип body - теперь это сама заметка, а title только для table view
//        let body = noteTextView.attributedText
        let body = noteTextView.text?.substring(from: title?.count ?? 0)
        if note != nil {
            StorageManager.shared.update(note!, newName: title ?? "", newBody: body ?? "")
        } else {
            StorageManager.shared.create(title ?? "", body ?? "")
        }
        delegate.reloadData()
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func boldStyle() {
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
    private func italicStyle() {
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
    private func underlineStyle() {
        let range = noteTextView.selectedRange
        let string = NSMutableAttributedString(attributedString: noteTextView.attributedText)
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        string.addAttributes(underlineAttribute, range: range)
        noteTextView.attributedText = string
        noteTextView.selectedRange = range
    }

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
            noteTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
}

//    @IBAction func colourTapp(_ sender: Any) {
//        if let text = textView {
//            let range = text.selectedRange
//            let string = NSMutableAttributedString(attributedString: textView.attributedText)
//            let colorAttribute = [NSAttributedString.Key.foregroundColor: UIColor.red]
//            string.addAttributes(colorAttribute, range: textView.selectedRange)
//            textView.attributedText = string
//            textView.selectedRange = range
//        }
//    }
