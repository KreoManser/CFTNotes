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
        setupNavigationBar()
        setupUI()
        setupConstraints()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewNote)
        )
        navigationController?.navigationBar.tintColor = .black
    }

    @objc
    private func addNewNote() {
        let noteVC = NoteViewController()
        navigationController?.pushViewController(noteVC, animated: true)
    }

    private func setupUI() {
        view.backgroundColor = .white

        setSubviews(noteTableView)
    }

    private func setSubviews(_ subviews: UIView...) {
        subviews.forEach { view.addSubview($0) }
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
