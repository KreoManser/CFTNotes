//
//  NoteViewController.swift
//  CFTNotes
//
//  Created by Сергей Бабич on 03.02.2023.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {

    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private lazy var noteTextView: UITextView = {
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
        let note = Note(context: viewContext)
        note.title = noteTextView.text?.components(separatedBy: "\n")[0]
        note.body = noteTextView.text?.substring(from: (title?.count ?? 0) + 1)

        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
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

}
