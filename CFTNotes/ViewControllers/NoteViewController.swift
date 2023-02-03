//
//  NoteViewController.swift
//  CFTNotes
//
//  Created by Сергей Бабич on 03.02.2023.
//

import UIKit

class NoteViewController: UIViewController {

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
            action: #selector(addddddd)
        )
        navigationController?.navigationBar.tintColor = .black
    }

    @objc
    private func addddddd() {

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
