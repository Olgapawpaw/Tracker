import Foundation
import UIKit

protocol NewHabitViewControllerDelegate: AnyObject {
    func updateCategory(newCategory: TrackerCategory)
}

final class NewHabitViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: NewHabitViewControllerDelegate?

    // MARK: - Private Properties
    private var sheduler = [WeekDay]()
    private var tracker = [Tracker]()
    private let namesCell = ["Категория", "Расписание"]
    private let trackerName = UITextField()
    private let createButton = UIButton()
    private let cancelButton = UIButton()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(NewHabitViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupTableView()
        setupTrackerName()
        setupButton()
    }
    
    // MARK: - IB Actions
    @objc private func onClickCreateButton() {
        guard let trackerName: String = trackerName.text,
              let emoji = UIImage(named: "emoji_1")
        else { return }
        let newTracker = Tracker(id: UUID(), name: trackerName, color: UIColor.colorSelection1, emoji: emoji, sheduler: sheduler)
        let newCategory = TrackerCategory(name: "Домашний уют", trackers: [newTracker])
        delegate?.updateCategory(newCategory: newCategory)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func onClickCancelButton() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func changeTrackerName() {
        if trackerName.text?.isEmpty == false {
            changeButton(tittle: "Создать",
                         colorTitle: UIColor.white,
                         colorBackround: UIColor.black,
                         borderWidth: 0,
                         button: createButton)
            createButton.isEnabled = true
        } else {
            changeButton(tittle: "Создать",
                         colorTitle: UIColor.white,
                         colorBackround: UIColor.ypLightGray,
                         borderWidth: 0,
                         button: createButton)
            createButton.isEnabled = false
        }
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 123),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTrackerName() {
        view.addSubview(trackerName)
        trackerName.translatesAutoresizingMaskIntoConstraints = false
        trackerName.backgroundColor = UIColor.ypLightGray
        trackerName.layer.cornerRadius = 16
        trackerName.layer.masksToBounds = true
        trackerName.placeholder = "Введите название трекера"
        trackerName.font = UIFont.systemFont(ofSize: 17)
        trackerName.clearButtonMode = .always
        trackerName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        trackerName.leftViewMode = .always
        trackerName.addTarget(self,
                              action: #selector(changeTrackerName),
                              for: .allEditingEvents)
        NSLayoutConstraint.activate([
            trackerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 24),
            trackerName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerName.heightAnchor.constraint(equalToConstant: 75),
        ])
    }
    
    private func setupButton() {
        changeButton(tittle: "Создать",
                     colorTitle: UIColor.white,
                     colorBackround: UIColor.ypLightGray,
                     borderWidth: 0,
                     button: createButton)
        changeButton(tittle: "Отменить",
                     colorTitle: UIColor.ypRed,
                     colorBackround: UIColor.white,
                     borderWidth: 2,
                     button: cancelButton)
        cancelButton.addTarget(self,
                               action: #selector(onClickCancelButton),
                               for: .touchUpInside)
        createButton.addTarget(self,
                               action: #selector(onClickCreateButton),
                               for: .touchUpInside)
        createButton.isEnabled = false
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            createButton.widthAnchor.constraint(equalToConstant: 166),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func changeButton(tittle: String, colorTitle: UIColor, colorBackround: UIColor, borderWidth: CGFloat, button: UIButton) {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(tittle, for: .normal)
        button.setTitleColor(colorTitle, for: .normal)
        button.layer.borderColor = colorTitle.cgColor
        button.layer.borderWidth = borderWidth
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = colorBackround
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NewHabitViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewHabitViewCell
        cell?.buttonLabel.text = namesCell[indexPath.item]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let viewController = NewHabitCategoryViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.viewControllers.first?.navigationItem.title = namesCell[indexPath.item]
            self.navigationController?.present(navigationController, animated: true)
        }
        if indexPath.item == 1 {
            let viewController = NewHabitShedulerViewController()
            viewController.delegate = self
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.viewControllers.first?.navigationItem.title = namesCell[indexPath.item]
            self.navigationController?.present(navigationController, animated: true)
        }
    }
}

// MARK: - NewHabitShedulerViewControllerDelegate
extension NewHabitViewController: NewHabitShedulerViewControllerDelegate {
    func updateSheduler(sheduler: [WeekDay]) {
        self.sheduler = sheduler
    }
}
