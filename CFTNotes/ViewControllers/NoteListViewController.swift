//
//  NoteListViewController.swift
//  CFTNotes
//
//  Created by Сергей Бабич on 03.02.2023.
//

import UIKit

class NoteListViewController: UIViewController {
    private lazy var noteTableView: UITableView = .init(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews(noteTableView)
        setupConstraints()
        setupUI()
    }

    private func setSubviews(_ subviews: UIView...) {
        subviews.forEach { view.addSubview($0) }
    }

    private func setupUI() {
        view.backgroundColor = .white

        navigationItem.title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupConstraints() {
        noteTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            noteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noteTableView.topAnchor.constraint(equalTo: view.topAnchor),
            noteTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
