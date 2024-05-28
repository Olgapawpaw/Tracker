import Foundation
import UIKit

protocol NewHabitViewControllerDelegate: AnyObject {
    func addCategory(newCategory: TrackerCategory)
}

final class NewHabitViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: NewHabitViewControllerDelegate?
    
    // MARK: - Private Properties
    private var categoryName = "Домашний уют"
    private var sheduler = [WeekDay]()
    private var tracker = [Tracker]()
    private let namesCell = ["Категория", "Расписание"]
    private let trackerName = UITextField()
    private let createButton = UIButton()
    private let cancelButton = UIButton()
    private let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let scrollView = UIScrollView()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(NewHabitTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    private let weekDayShortNames = [
        WeekDay.monday: "Пн",
        WeekDay.tuesday: "Вт",
        WeekDay.wednesday: "Ср",
        WeekDay.thursday: "Чт",
        WeekDay.friday: "Пт",
        WeekDay.saturday: "Сб",
        WeekDay.sunday: "Вс"
    ]
    private let colors: [UIColor] = [
        .colorSelection1, .colorSelection2, .colorSelection3,
        .colorSelection4, .colorSelection5, .colorSelection6,
        .colorSelection7, .colorSelection8, .colorSelection9,
        .colorSelection10, .colorSelection11, .colorSelection12,
        .colorSelection13, .colorSelection14, .colorSelection15,
        .colorSelection16, .colorSelection17, .colorSelection18
    ]
    private let emoji: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
                                   "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupScrollView()
        setupTableView()
        setupTrackerName()
        setupButton()
        //setupCollectionView(collectionView: emojiCollectionView)
        //setupCollectionView(collectionView: colorCollectionView)
    }
    
    // MARK: - IB Actions
    @objc private func onClickCreateButton() {
        guard let trackerName: String = trackerName.text,
              let emoji = UIImage(named: "emoji_1")
        else { return }
        let newTracker = Tracker(id: UUID(),
                                 name: trackerName,
                                 color: UIColor.colorSelection1,
                                 emoji: emoji, sheduler: sheduler,
                                 type: Type.habit)
        let newCategory = TrackerCategory(name: categoryName,
                                          trackers: [newTracker])
        delegate?.addCategory(newCategory: newCategory)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func onClickCancelButton() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func changeTrackerName() {
        activateCreateButton()
    }
    
    // MARK: - Private Methods
    private func activateCreateButton() {
        if trackerName.text?.isEmpty == true {
            changeButton(tittle: "Создать",
                         colorTitle: UIColor.white,
                         colorBackround: UIColor.ypGray,
                         borderWidth: 0,
                         button: createButton)
            createButton.isEnabled = false
        } else {
            changeButton(tittle: "Создать",
                         colorTitle: UIColor.white,
                         colorBackround: UIColor.black,
                         borderWidth: 0,
                         button: createButton)
            createButton.isEnabled = true
        }
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupCollectionView(collectionView: UICollectionView) {
        collectionView.register(NewHabitCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewHabitSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        scrollView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 42),
            collectionView.heightAnchor.constraint(equalToConstant: 222),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupTableView() {
        scrollView.addSubview(tableView)
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
        scrollView.addSubview(trackerName)
        trackerName.translatesAutoresizingMaskIntoConstraints = false
        trackerName.backgroundColor = UIColor.ypLightGray.withAlphaComponent(0.3)
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
                     colorBackround: UIColor.ypGray,
                     borderWidth: 0,
                     button: createButton)
        changeButton(tittle: "Отменить",
                     colorTitle: UIColor.ypRed,
                     colorBackround: UIColor.white,
                     borderWidth: 1,
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
        scrollView.addSubview(button)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let cell = cell as? NewHabitTableViewCell else {
            return NewHabitTableViewCell()
        }
        switch indexPath.item {
        case 0:
            if categoryName.isEmpty == true {
                cell.titleLabel.text = namesCell[indexPath.item]
            } else {
                cell.titleLabel.attributedText = createAtributedText(cell: cell, indexPath: indexPath, text: categoryName)
            }
        case 1:
            if sheduler.isEmpty == true {
                cell.titleLabel.text = namesCell[indexPath.item]
            } else {
                switch sheduler {
                case WeekDay.allCases:
                    cell.titleLabel.attributedText = createAtributedText(cell: cell, indexPath: indexPath, text: "Каждый день")
                default:
                    cell.titleLabel.attributedText = createAtributedText(cell: cell, indexPath: indexPath, text: createStrWeekDayShortName())
                }
            }
        default: break
        }
        if indexPath.item == namesCell.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let viewController = NewCategoryViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.viewControllers.first?.navigationItem.title = namesCell[indexPath.item]
            self.navigationController?.present(navigationController, animated: true)
        }
        if indexPath.item == 1 {
            let viewController = NewHabitShedulerViewController()
            viewController.delegate = self
            viewController.sheduler = sheduler
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.viewControllers.first?.navigationItem.title = namesCell[indexPath.item]
            self.navigationController?.present(navigationController, animated: true)
        }
    }
    
    func createAtributedText(cell: NewHabitTableViewCell?, indexPath: IndexPath, text: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        let stringValue = "\(namesCell[indexPath.item])\n\(text)"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue, attributes: [ NSAttributedString.Key.paragraphStyle: paragraphStyle])
        attributedString.setColor(color: UIColor.ypGray, forText: text)
        return attributedString
    }
    
    func createStrWeekDayShortName() -> String {
        var strWeekDayShortName = String()
        for (count, i) in sheduler.enumerated() {
            if count == 0 {
                strWeekDayShortName = weekDayShortNames[i] ?? ""
            } else {
                strWeekDayShortName = strWeekDayShortName + ", " + (weekDayShortNames[i] ?? "")
            }
        }
        return strWeekDayShortName
    }
}

// MARK: - NewHabitShedulerViewControllerDelegate
extension NewHabitViewController: NewHabitShedulerViewControllerDelegate {
    func updateSheduler(sheduler: [WeekDay]) {
        self.sheduler = sheduler
    }
    
    func updateTable() {
        tableView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension NewHabitViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in: UICollectionView) -> Int { //количество секций
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //количество ячеек в секции
        return emoji.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {     //ячейка для заданной позиции IndexPath
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) // экземпляр ячейки
        guard let cell = cell as? NewHabitCollectionViewCell else {
            return  NewHabitCollectionViewCell()
        }
        cell.label.text = emoji[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {     //для задания хедера
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! NewHabitSupplementaryView
        header.titleLabel.text = "Emoji"
        return header
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { //расположение и размер ячеек
        return CGSize(width: 52,
                      height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { // задаёт минимальный отступ между строками коллекции
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { //Устанавливает минимальный отступ между ячейками
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize { //расположение и размер хедера
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}
