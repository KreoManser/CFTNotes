import UIKit

protocol NoteListViewControllerDelegate {
    func reloadData()
}

class NoteListViewController: UIViewController {
    private lazy var noteTableView: UITableView = .init(frame: .zero)
    private let identifier = "NoteCell"
    private var noteList: [Note] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }

    @objc
    private func addNewNote() {
        let noteVC = NoteViewController()
        noteVC.delegate = self
        navigationController?.pushViewController(noteVC, animated: true)
    }

    private func fetchData() {
        StorageManager.shared.fetchData { [unowned self] result in
            switch result {
            case .success(let noteList):
                self.noteList = noteList
            case .failure(let error):
                    showAlert(with: error.localizedDescription)
            }
        }
    }

    private func showAlert(with msg: String) {
        let alert = UIAlertController(
            title: title,
            message: "Something wrong!\n \(msg)",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        noteList.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let note = noteList[indexPath.row]
        var configuration = UIListContentConfiguration.sidebarCell()
        configuration.attributedText = note.body
        cell.contentConfiguration = configuration

        return cell
    }
}

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = noteList[indexPath.row]
        let noteVC = NoteViewController()
        noteVC.delegate = self
        noteVC.noteTextView.attributedText = note.body
        noteVC.note = note
        navigationController?.pushViewController(noteVC, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let note = noteList.remove(at: indexPath.row)
            noteTableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(note)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension NoteListViewController: NoteListViewControllerDelegate {
    func reloadData() {
        fetchData()
        noteTableView.reloadData()
    }
}

extension NoteListViewController {
    private func setupUI() {
        noteTableView.delegate = self
        noteTableView.dataSource = self

        view.backgroundColor = .white
        setupNavigationBar()
        setSubviews(noteTableView)
        setupConstraints()
        noteTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
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
