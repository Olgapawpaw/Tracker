import Foundation
import UIKit


protocol EditTrackerViewControllerDelegate: AnyObject {
    func updateCategory(newCategory: TrackerCategory, newTracker: Tracker, idEditedTracker: UUID)
}

final class EditTrackerViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: EditTrackerViewControllerDelegate?
    
    // MARK: - Private Properties
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }()
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 130)
    }
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.frame.size = contentSize
        contentView.backgroundColor = UIColor.viewBackgroundColor
        return contentView
    }()
    private let create = NSLocalizedString("save", comment: "")
    private let cancel = NSLocalizedString("cancel", comment: "")
    private let newTrackerName = NSLocalizedString("newTracker.name", comment: "")
    private let everyDay = NSLocalizedString("everyDay", comment: "")
    private let emojiText = NSLocalizedString("emoji", comment: "")
    private let color = NSLocalizedString("color", comment: "")
    private var selectedColor = UIColor()
    private var selectedEmoji = String()
    private var selectedCategory = String()
    private var idEditedTracker = UUID()
    private var trackerName = String()
    private var countCompletedDay = Int()
    private var sheduler = [WeekDay]()
    private var tracker = [Tracker]()
    private let namesCell = [NSLocalizedString("category", comment: ""),
                             NSLocalizedString("sheduler", comment: "")]
    private let countTrackerLabel = UILabel()
    private let trackerNameTextField = UITextField()
    private let createButton = UIButton()
    private let cancelButton = UIButton()
    private let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(CreateNewTrackerTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    private let weekDayShortNames = [
        WeekDay.monday: NSLocalizedString("mondayShort", comment: ""),
        WeekDay.tuesday: NSLocalizedString("tuesdayShort", comment: ""),
        WeekDay.wednesday: NSLocalizedString("wednesdayShort", comment: ""),
        WeekDay.thursday: NSLocalizedString("thursdayShort", comment: ""),
        WeekDay.friday: NSLocalizedString("fridayShort", comment: ""),
        WeekDay.saturday: NSLocalizedString("saturdayShort", comment: ""),
        WeekDay.sunday: NSLocalizedString("sundayShort", comment: "")
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
    
    // MARK: - Init Methods
    init(selectedColor: UIColor, selectedEmoji: String, selectedCategory: String, sheduler: [WeekDay], trackerName: String, countCompletedDay: Int, id: UUID) {
        self.selectedColor = selectedColor
        self.selectedEmoji = selectedEmoji
        self.selectedCategory = selectedCategory
        self.sheduler = sheduler
        self.trackerName = trackerName
        self.countCompletedDay = countCompletedDay
        self.idEditedTracker = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.viewBackgroundColor
        setupScrollView()
        setupTableView()
        setupTrackerName()
        setupButton()
        setupCountTrackerLabel()
        setupCollectionView(collectionView: emojiCollectionView, distanceToTableView: 383)
        setupCollectionView(collectionView: colorCollectionView, distanceToTableView: 621)
        activateCreateButton()
    }
    
    // MARK: - IB Actions
    @objc private func onClickCreateButton() {
        guard let trackerNameTextField: String = trackerNameTextField.text
        else { return }
        let newTracker = Tracker(id: UUID(),
                                 name: trackerNameTextField,
                                 color: selectedColor,
                                 emoji: selectedEmoji,
                                 sheduler: sheduler)
        let newCategory = TrackerCategory(name: selectedCategory, trackers: [newTracker])
        delegate?.updateCategory(newCategory: newCategory, newTracker: newTracker, idEditedTracker: idEditedTracker)
        self.dismiss(animated: true)
    }
    
    @objc private func onClickCancelButton() {
        self.dismiss(animated: true)
    }
    
    @objc private func changeTrackerName() {
        activateCreateButton()
    }
    
    // MARK: - Private Methods
    private func setupCountTrackerLabel() {
        contentView.addSubview(countTrackerLabel)
        countTrackerLabel.translatesAutoresizingMaskIntoConstraints = false
        let format = NSLocalizedString("numberOfDay", comment: "")
        let text = String.localizedStringWithFormat (format, countCompletedDay)
        countTrackerLabel.text = text
        countTrackerLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        countTrackerLabel.textColor = UIColor.ypBlack
        countTrackerLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            countTrackerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            countTrackerLabel.heightAnchor.constraint(equalToConstant: 38),
            countTrackerLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            countTrackerLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
    }
    
    private func activateCreateButton() {
        if trackerNameTextField.text?.isEmpty == true || sheduler.isEmpty {
            changeButton(tittle: create,
                         colorTitle: UIColor.white,
                         colorBackround: UIColor.ypGray,
                         borderWidth: 0,
                         button: createButton)
            createButton.isEnabled = false
        } else {
            changeButton(tittle: create,
                         colorTitle: UIColor.white,
                         colorBackround: UIColor.black,
                         borderWidth: 0,
                         button: createButton)
            createButton.isEnabled = true
        }
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func setupCollectionView(collectionView: UICollectionView, distanceToTableView: CGFloat) {
        collectionView.register(CreateNewTrackerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(CreateNewTrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: distanceToTableView),
            collectionView.heightAnchor.constraint(equalToConstant: 224),
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 18),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -18),
        ])
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupTableView() {
        contentView.addSubview(tableView)
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 201),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
    }
    
    private func setupTrackerName() {
        contentView.addSubview(trackerNameTextField)
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        trackerNameTextField.backgroundColor = UIColor.ypLightGray.withAlphaComponent(0.3)
        trackerNameTextField.layer.cornerRadius = 16
        trackerNameTextField.layer.masksToBounds = true
        trackerNameTextField.placeholder = newTrackerName
        trackerNameTextField.text = trackerName
        trackerNameTextField.font = UIFont.systemFont(ofSize: 17)
        trackerNameTextField.clearButtonMode = .always
        trackerNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        trackerNameTextField.leftViewMode = .always
        trackerNameTextField.addTarget(self,
                                       action: #selector(changeTrackerName),
                                       for: .allEditingEvents)
        NSLayoutConstraint.activate([
            trackerNameTextField.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 102),
            trackerNameTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            trackerNameTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setupButton() {
        changeButton(tittle: create,
                     colorTitle: UIColor.white,
                     colorBackround: UIColor.ypGray,
                     borderWidth: 0,
                     button: createButton)
        changeButton(tittle: cancel,
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
            cancelButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 859),
            cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 859),
            createButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            createButton.widthAnchor.constraint(equalToConstant: 166),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func changeButton(tittle: String, colorTitle: UIColor, colorBackround: UIColor, borderWidth: CGFloat, button: UIButton) {
        contentView.addSubview(button)
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
extension EditTrackerViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let cell = cell as? CreateNewTrackerTableViewCell else {
            return CreateNewTrackerTableViewCell()
        }
        switch indexPath.item {
        case 0:
            if selectedCategory.isEmpty {
                cell.updateTitleLabelText(text: namesCell[indexPath.item])
            } else {
                cell.updateTitleLabelAttributedText(attribut: createAtributedText(cell: cell, indexPath: indexPath, text: selectedCategory))
            }
        case 1:
            if sheduler.isEmpty {
                cell.updateTitleLabelText(text: namesCell[indexPath.item])
            } else {
                if sheduler.contains(WeekDay.monday) && sheduler.contains(WeekDay.thursday) && sheduler.contains(WeekDay.wednesday) && sheduler.contains(WeekDay.tuesday) && sheduler.contains(WeekDay.friday) && sheduler.contains(WeekDay.saturday) && sheduler.contains(WeekDay.sunday) {
                    cell.updateTitleLabelAttributedText(attribut: createAtributedText(cell: cell, indexPath: indexPath, text: everyDay))
                } else {
                    cell.updateTitleLabelAttributedText(attribut: createAtributedText(cell: cell, indexPath: indexPath, text: createStrWeekDayShortName()))
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
            let newCategoryModel = NewCategoryModel()
            newCategoryModel.delegate = self
            newCategoryModel.selectedCategory = selectedCategory
            let newCategoryViewModel = NewCategoryViewModel(for: newCategoryModel)
            let viewController = NewCategoryViewController(viewModel: newCategoryViewModel)
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
    
    func createAtributedText(cell: CreateNewTrackerTableViewCell?, indexPath: IndexPath, text: String) -> NSMutableAttributedString {
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
    
    func compareColors(color1: UIColor, color2: UIColor) -> Bool {
        var red:CGFloat = 0
        var green:CGFloat  = 0
        var blue:CGFloat = 0
        var alpha:CGFloat  = 0
        color1.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var red2:CGFloat = 0
        var green2:CGFloat  = 0
        var blue2:CGFloat = 0
        var alpha2:CGFloat  = 0
        color2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        let distance = sqrt(pow((red - red2), 2) + pow((green - green2), 2) + pow((blue - blue2), 2) )
        if distance <= 0.001 {
            return true
        } else {
            return false
        }
    }
}

// MARK: - NewHabitShedulerViewControllerDelegate, NewCategoryModelDelegate
extension EditTrackerViewController: NewHabitShedulerViewControllerDelegate, NewCategoryModelDelegate {
    func updateSheduler(sheduler: [WeekDay]) {
        self.sheduler = sheduler
    }
    
    func updateTable() {
        tableView.reloadData()
        activateCreateButton()
    }
    
    func updateSelectedCategory(selectedCategory: String) {
        self.selectedCategory = selectedCategory
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension EditTrackerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in: UICollectionView) -> Int { //количество секций
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //количество ячеек в секции
        if collectionView == emojiCollectionView {
            return emoji.count
        } else {
            return colors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {     //ячейка для заданной позиции IndexPath
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let cell = cell as? CreateNewTrackerCollectionViewCell else {
            return  CreateNewTrackerCollectionViewCell()
        }
        if collectionView == emojiCollectionView {
            cell.updateLabelText(text: emoji[indexPath.item])
            cell.contentView.backgroundColor = .clear
            cell.layer.masksToBounds = false
            if emoji[indexPath.item] == selectedEmoji {
                cell.contentView.backgroundColor = UIColor.ypLightGray
                cell.layer.cornerRadius = 16
                cell.layer.masksToBounds = true
            }
        }
        if collectionView == colorCollectionView {
            cell.updateLabelBackgroundColor(color: colors[indexPath.item])
            cell.layer.masksToBounds = false
            cell.layer.borderWidth = 0
            if compareColors(color1: colors[indexPath.item], color2: selectedColor) {
                cell.layer.cornerRadius = 12
                cell.layer.masksToBounds = true
                cell.layer.borderColor = colors[indexPath.item].withAlphaComponent(0.3).cgColor
                cell.layer.borderWidth = 3
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {     //для задания хедера
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! CreateNewTrackerSupplementaryView
        if collectionView == emojiCollectionView {
            header.updateTitleLabel(text: emojiText)
        }
        if collectionView == colorCollectionView {
            header.updateTitleLabel(text: color)
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if collectionView == emojiCollectionView {
            selectedEmoji = emoji[indexPath.item]
            collectionView.reloadData()
        }
        if collectionView == colorCollectionView {
            selectedColor = colors[indexPath.item]
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath){
        let selectedCell: CreateNewTrackerCollectionViewCell = collectionView.cellForItem(at: indexPath)! as! CreateNewTrackerCollectionViewCell
        selectedCell.contentView.backgroundColor = UIColor.clear
        selectedCell.layer.borderWidth = 0
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension EditTrackerViewController: UICollectionViewDelegateFlowLayout {
    
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
        return CGSize(width: collectionView.frame.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
}
