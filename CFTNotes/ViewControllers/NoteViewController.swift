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
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveNote)
        )
        navigationController?.navigationBar.tintColor = .black
    }

    @objc
    private func saveNote() {
        let title = noteTextView.text?.components(separatedBy: "\n")[0]
        let body = noteTextView.text?.substring(from: title?.count ?? 0)
        if note != nil {
            StorageManager.shared.update(note!, newName: title ?? "", newBody: body ?? "")
        } else {
            StorageManager.shared.create(title ?? "", body ?? "")
        }
        delegate.reloadData()
        navigationController?.popViewController(animated: true)
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
            noteTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            noteTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            noteTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }

    //    private func createButton(
    //        withTitle title: String,
    //        andColor color: UIColor,
    //        action: UIAction
    //    ) -> UIButton {
    //        var attributes = AttributeContainer()
    //        attributes.font = UIFont.boldSystemFont(ofSize: 18)
    //
    //        var buttonConfiguration = UIButton.Configuration.filled ()
    //        buttonConfiguration.attributedTitle = AttributedString(title, attributes: attributes)
    //        buttonConfiguration.baseBackgroundColor = color
    //        return UIButton (configuration: buttonConfiguration, primaryAction: action)
    //    }
}

//class ViewController: UIViewController {
//
//    @IBOutlet weak var btnOutlet: UIButton!
//    @IBOutlet weak var textView: UITextView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    @IBAction func btnTapp(_ sender: Any) {
//        if let text = textView {
//            let range = text.selectedRange
//            let string = NSMutableAttributedString(attributedString: textView.attributedText)
//            let boldAttribute = [
//                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
//            ]
//            string.addAttributes(boldAttribute, range: textView.selectedRange)
//            textView.attributedText = string
//            textView.selectedRange = range
//        }
//    }
//
//    @IBAction func italicTapp(_ sender: Any) {
//        if let text = textView {
//            let range = text.selectedRange
//            let string = NSMutableAttributedString(attributedString: textView.attributedText)
//            let italicAttribute = [
//                NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 18.0)
//            ]
//            string.addAttributes(italicAttribute, range: textView.selectedRange)
//            textView.attributedText = string
//            textView.selectedRange = range
//        }
//    }
//
//    @IBAction func underlineTapp(_ sender: Any) {
//        if let text = textView {
//            let range = text.selectedRange
//            let string = NSMutableAttributedString(attributedString: textView.attributedText)
//            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
//            string.addAttributes(underlineAttribute, range: textView.selectedRange)
//            textView.attributedText = string
//            textView.selectedRange = range
//
//        }
//    }
//
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
//}
