import Foundation
import UIKit


protocol TrackersViewControllerDelegate: AnyObject {
    func changeDatePicker()
}

final class TrackersViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: TrackersViewControllerDelegate?
    var selectedCategories = [TrackerCategory]()
    
    // MARK: - Private Properties
    private let emptyTrekers = NSLocalizedString("emptyTrekers", comment: "Text displayed if no trakers")
    private let noSelectedTrakers = NSLocalizedString("noSelectedTrakers", comment: "Text displayed if no trakers before filtered")
    private let contextMenuPinTitle = NSLocalizedString("pin", comment: "")
    private let contextMenuUnPinTitle = NSLocalizedString("unPin", comment: "")
    private let contextMenuEditTitle = NSLocalizedString("edit", comment: "")
    private let contextMenuDeleteTitle = NSLocalizedString("delete", comment: "")
    private let pinCategory = NSLocalizedString("pinCategory", comment: "")
    private let editHabbitTitle = NSLocalizedString("editHabbit.title", comment: "")
    private let actionSheetMessage = NSLocalizedString("deleteTracker", comment: "")
    private let cancel = NSLocalizedString("cancel", comment: "")
    private let filterButtonTitle = NSLocalizedString("filters", comment: "")
    private let filterAllTrackers = NSLocalizedString("filter.allTrackers", comment: "")
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let scrollView = UIScrollView()
    private let noTrackersImage = UIImageView()
    private let noTrackersLabel = UILabel()
    private var filterButton = UIButton()
    private var selectedDate = Date()
    private var weekDay = Int()
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private var isNoTracker = Bool()
    private var selectedFilter = String()
    private var isShowOnlyCompletedTracker = Bool()
    private var isShowOnlyUnCompletedTracker = Bool()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.viewBackgroundColor
        setupScrollView()
        createCollection()
        selectedFilter = filterAllTrackers
        updateSelectedCategories(selectedDate: Helpers.getNowDate(), weekday: Helpers.getNowWeekday())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AnalyticsService.report(event: "open", params: ["screen" : "Main"])
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AnalyticsService.report(event: "close", params: ["screen" : "Main"])
        super.viewWillDisappear(animated)
    }
    
    // MARK: - IB Actions
    @objc func onClickFilterButton() {
        AnalyticsService.report(event: "click", params: ["screen" : "Main", "item" : "filter"])
        let viewController = FilterViewController(selectedFilter: selectedFilter)
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.viewControllers.first?.navigationItem.title = filterButtonTitle
        self.navigationController?.present(navigationController, animated: true)
    }
    
    // MARK: - Public Methods
    func addCategory(newCategory: TrackerCategory, newTracker: Tracker) {
        let trackerCategoryForCoreData = TrackerCategoryForCoreData(name: newCategory.name, id: newTracker.id, oldCategoryName: nil)
        try? trackerStore.addNewTracker(newTracker, trackerCategory: trackerCategoryForCoreData)
        updateSelectedCategories(selectedDate: selectedDate, weekday: weekDay)
    }
    
    func updateSearchSelectedCategories(text: String) {
        do {
            let trackerCoreData = try trackerStore.getSearchTrackers(text: text, day: weekDay)
            selectedCategories = trackerCategoryStore.getTrackerCategory(trackerCoreData: trackerCoreData)
        } catch let error as NSError {
            print(error.userInfo)
        }
        didUpdate()
    }
    
    func updateSelectedCategories(selectedDate: Date, weekday: Int) {
        if isShowOnlyCompletedTracker{
            do {
                let trackerRecordCoreData = try trackerRecordStore.getCompletedTrackersForToday(day: selectedDate)
                let trackerCoreData = try trackerStore.getSelectedCompletedTrackers(day: weekday, trackerRecordCoreData: trackerRecordCoreData)
                selectedCategories = trackerCategoryStore.getTrackerCategory(trackerCoreData: trackerCoreData)
            } catch let error as NSError {
                print(error.userInfo)
            }
        } else {
            if isShowOnlyUnCompletedTracker {
                do {
                    let trackerRecordCoreData = try trackerRecordStore.getCompletedTrackersForToday(day: selectedDate)
                    let trackerCoreData = try trackerStore.getSelectedUnCompletedTrackers(day: weekday, trackerRecordCoreData: trackerRecordCoreData)
                    selectedCategories = trackerCategoryStore.getTrackerCategory(trackerCoreData: trackerCoreData)
                } catch let error as NSError {
                    print(error.userInfo)
                }
            } else {
                do {
                    let trackerCoreData = try trackerStore.getSelectedTrackers(day: weekday)
                    selectedCategories = trackerCategoryStore.getTrackerCategory(trackerCoreData: trackerCoreData)
                } catch let error as NSError {
                    print(error.userInfo)
                }
            }
        }
        isNoTracker = trackerStore.checkExistTrackers()
        self.selectedDate = selectedDate
        self.weekDay = weekday
        didUpdate()
    }
    
    // MARK: - Private Methods
    private func setupButton() {
        scrollView.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.backgroundColor = UIColor.ypBlue
        filterButton.setTitle(filterButtonTitle, for: .normal)
        filterButton.setTitleColor(UIColor.white, for: .normal)
        filterButton.addTarget(self,
                               action: #selector(onClickFilterButton),
                               for: .touchUpInside)
        filterButton.layer.cornerRadius = 16
        filterButton.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func showNoTracker() {
        setupNoTracker(title: emptyTrekers, imageName: "MainViewError")
    }
    
    private func showNoTrackerAfterFiltering() {
        setupNoTracker(title: noSelectedTrakers, imageName: "NoTrackerAfterFiltering")
    }
    
    private func setupNoTracker(title: String, imageName: String) {
        [noTrackersImage, noTrackersLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        noTrackersImage.image = UIImage(named: imageName)
        noTrackersLabel.text = title
        noTrackersLabel.textColor = UIColor.ypBlack
        noTrackersLabel.font = UIFont.systemFont(ofSize: 12)
        NSLayoutConstraint.activate([
            noTrackersImage.heightAnchor.constraint(equalToConstant: 80),
            noTrackersImage.widthAnchor.constraint(equalToConstant: 80),
            noTrackersImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            noTrackersImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noTrackersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noTrackersLabel.topAnchor.constraint(equalTo: noTrackersImage.bottomAnchor, constant: 8),
        ])
    }
    
    private func hideNoTracker() {
        noTrackersImage.removeFromSuperview()
        noTrackersLabel.removeFromSuperview()
    }
    
    private func createCollection() {
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "cell") //регистрируем ячейки для отображения
        collectionView.register(TrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header") // регистрируем хедер
        scrollView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        collectionView.dataSource = self //объявлем что поддерживается UICollectionViewDataSource указаннный в extension
        collectionView.delegate = self
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.viewBackgroundColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func pin(indexPath: IndexPath) {
        let trackerCategoryForCoreData = TrackerCategoryForCoreData(name: pinCategory, id: selectedCategories[indexPath.section].trackers[indexPath.item].id, oldCategoryName: selectedCategories[indexPath.section].name)
        try? trackerStore.deleteTracker(selectedCategories[indexPath.section].trackers[indexPath.item].id)
        try? trackerCategoryStore.deleteTrackerCategory(selectedCategories[indexPath.section].trackers[indexPath.item].id)
        try? trackerStore.addNewTracker(selectedCategories[indexPath.section].trackers[indexPath.item],
                                        trackerCategory: trackerCategoryForCoreData)
        updateSelectedCategories(selectedDate: selectedDate, weekday: weekDay)
    }
    
    private func unPin(indexPath: IndexPath) {
        let oldCategoryName = trackerCategoryStore.getOldCategory(selectedCategories[indexPath.section].trackers[indexPath.item].id)
        let trackerCategoryForCoreData = TrackerCategoryForCoreData(name: oldCategoryName, id: selectedCategories[indexPath.section].trackers[indexPath.item].id, oldCategoryName: nil)
        try? trackerStore.deleteTracker(selectedCategories[indexPath.section].trackers[indexPath.item].id)
        try? trackerCategoryStore.deleteTrackerCategory(selectedCategories[indexPath.section].trackers[indexPath.item].id)
        try? trackerStore.addNewTracker(selectedCategories[indexPath.section].trackers[indexPath.item],
                                        trackerCategory: trackerCategoryForCoreData)
        updateSelectedCategories(selectedDate: selectedDate, weekday: weekDay)
    }
    
    private func edit(indexPath: IndexPath) {
        AnalyticsService.report(event: "click", params: ["screen" : "Main", "item" : "edit"])
        let trackerRecord = TrackerRecord(id: selectedCategories[indexPath.section].trackers[indexPath.item].id, date: selectedDate)
        let countCompletedDay = trackerRecordStore.countTrackerRecord(trackerRecord)
        let viewController = EditTrackerViewController(selectedColor: selectedCategories[indexPath.section].trackers[indexPath.item].color,
                                                       selectedEmoji: selectedCategories[indexPath.section].trackers[indexPath.item].emoji,
                                                       selectedCategory: selectedCategories[indexPath.section].name,
                                                       sheduler: selectedCategories[indexPath.section].trackers[indexPath.item].sheduler,
                                                       trackerName: selectedCategories[indexPath.section].trackers[indexPath.item].name,
                                                       countCompletedDay: countCompletedDay,
                                                       id: selectedCategories[indexPath.section].trackers[indexPath.item].id)
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.viewControllers.first?.navigationItem.title = editHabbitTitle
        self.navigationController?.present(navigationController, animated: true)
    }
    
    private func delete(indexPath: IndexPath) {
        AnalyticsService.report(event: "click", params: ["screen" : "Main", "item" : "delete"])
        let actionSheet = UIAlertController(title: nil, message: actionSheetMessage, preferredStyle: .actionSheet)
        let doingAction = UIAlertAction(title: contextMenuDeleteTitle, style: .destructive) { [weak self] _ in
            guard let self = self else {return}
            try? trackerStore.deleteTracker(selectedCategories[indexPath.section].trackers[indexPath.item].id)
            try? trackerCategoryStore.deleteTrackerCategory(selectedCategories[indexPath.section].trackers[indexPath.item].id)
            updateSelectedCategories(selectedDate: selectedDate, weekday: weekDay)
        }
        actionSheet.addAction(doingAction)
        actionSheet.addAction(UIAlertAction(title: cancel, style: .cancel))
        self.present(actionSheet, animated: true)
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in: UICollectionView) -> Int { //количество секций
        return selectedCategories.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //количество ячеек в секции
        if section != selectedCategories.count {
            return selectedCategories[section].trackers.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {     //ячейка для заданной позиции IndexPath
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let tracker = TrackerRecord(id: selectedCategories[indexPath.section].trackers[indexPath.item].id, date: selectedDate)
        let istTrackerRecord = trackerRecordStore.checkExistTrackerRecord(tracker)
        let countComletedTrackers = trackerRecordStore.countTrackerRecord(tracker)
        guard let cell = cell as? TrackerCollectionViewCell else {
            return TrackerCollectionViewCell()
        }
        cell.delegate = self
        let format = NSLocalizedString("numberOfDay", comment: "")
        let text = String.localizedStringWithFormat (format, countComletedTrackers)
        cell.updateCountLabel(text: text)
        cell.updateTitleLabel(text: selectedCategories[indexPath.section].trackers[indexPath.item].name)
        cell.updateColorImage(color: selectedCategories[indexPath.section].trackers[indexPath.item].color)
        cell.updateEmoji(text: selectedCategories[indexPath.section].trackers[indexPath.item].emoji)
        if !istTrackerRecord {
            cell.updateButton(backgroundColor: UIColor.ypWhite.withAlphaComponent(1.0),
                              tintColor: selectedCategories[indexPath.section].trackers[indexPath.item].color.withAlphaComponent(1.0),
                              imageButton: UIImage(named:"AddDay")?.withRenderingMode(.alwaysTemplate) ?? UIImage())
        } else {
            cell.updateButton(backgroundColor: selectedCategories[indexPath.section].trackers[indexPath.item].color.withAlphaComponent(0.3),
                              tintColor: UIColor.ypWhite,
                              imageButton: UIImage(named:"DoneDay")?.withRenderingMode(.alwaysTemplate) ?? UIImage())
        }
        if selectedCategories[indexPath.section].name == pinCategory {
            cell.showImagePin()
        } else {
            cell.hideImagePin()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {     //для задания хедера
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! TrackerSupplementaryView
        if indexPath.section != selectedCategories.count {
            header.updateTitleLabel(text: selectedCategories[indexPath.section].name)
            return header
        } else {
            header.updateTitleLabel(text: "")
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else { return nil }
        return UITargetedPreview(view: cell.topContainer)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        let indexPath = indexPaths[0]
        if selectedCategories[indexPath.section].name == pinCategory {
            return UIContextMenuConfiguration(actionProvider: { actions in
                return UIMenu(children: [
                    UIAction(title: self.contextMenuUnPinTitle) { [weak self] _ in
                        self?.unPin(indexPath: indexPath)
                    },
                    UIAction(title: self.contextMenuEditTitle) { [weak self] _ in
                        self?.edit(indexPath: indexPath)
                    },
                    UIAction(title: self.contextMenuDeleteTitle, attributes: .destructive) { [weak self] _ in
                        self?.delete(indexPath: indexPath)
                    },
                ])
            })
        } else {
            return UIContextMenuConfiguration(actionProvider: { actions in
                return UIMenu(children: [
                    UIAction(title: self.contextMenuPinTitle) { [weak self] _ in
                        self?.pin(indexPath: indexPath)
                    },
                    UIAction(title: self.contextMenuEditTitle) { [weak self] _ in
                        self?.edit(indexPath: indexPath)
                    },
                    UIAction(title: self.contextMenuDeleteTitle, attributes: .destructive) { [weak self] _ in
                        self?.delete(indexPath: indexPath)
                    },
                ])
            })
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { //расположение и размер ячеек
        return CGSize(width: (collectionView.bounds.width / 2) - 4.5,
                      height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { // задаёт минимальный отступ между строками коллекции
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { //Устанавливает минимальный отступ между ячейками
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize { //расположение и размер хедера
        return CGSize(width: collectionView.frame.width, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
}


// MARK: - TrackerCollectionViewCellDelegate
extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func changeCompletedTrackers(_ cell: TrackerCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell)
        else { return }
        let nowDate = Helpers.getNowDate()
        let tracker = TrackerRecord(id: selectedCategories[indexPath.section].trackers[indexPath.item].id, date: selectedDate)
        let isTrackerRecord = trackerRecordStore.checkExistTrackerRecord(tracker)
        
        if selectedDate <= nowDate {
            if !isTrackerRecord {
                do {
                    try trackerRecordStore.addNewTrackerRecord(tracker)
                } catch let error as NSError {
                    print(error.userInfo)
                }
            } else {
                do {
                    try trackerRecordStore.deleteTrackerRecord(tracker)
                } catch let error as NSError {
                    print(error.userInfo)
                }
            }
            didUpdate()
            updateSelectedCategories(selectedDate: selectedDate, weekday: weekDay)
        }
    }
}

// MARK: - TrackerCategoryStoreDelegate
extension TrackersViewController: TrackerCategoryStoreDelegate {
    func didUpdate() {
        if isNoTracker {
            collectionView.reloadData()
            setupNoTracker(title: emptyTrekers, imageName: "MainViewError")
            filterButton.removeFromSuperview()
        } else {
            if selectedCategories.isEmpty {
                collectionView.reloadData()
                setupNoTracker(title: noSelectedTrakers, imageName: "NoTrackerAfterFiltering")
                filterButton.removeFromSuperview()
            } else {
                setupButton()
                hideNoTracker()
                collectionView.reloadData()
            }
        }
    }
}

// MARK: - EditTrackerViewControllerDelegate
extension TrackersViewController: EditTrackerViewControllerDelegate {
    func updateCategory(newCategory: TrackerCategory, newTracker: Tracker, idEditedTracker: UUID) {
        let trackerCategoryForCoreData = TrackerCategoryForCoreData(name: newCategory.name, id: newTracker.id, oldCategoryName: nil)
        try? trackerStore.addNewTracker(newTracker, trackerCategory: trackerCategoryForCoreData)
        try? trackerStore.deleteTracker(idEditedTracker)
        try? trackerCategoryStore.deleteTrackerCategory(idEditedTracker)
        updateSelectedCategories(selectedDate: selectedDate, weekday: weekDay)
    }
}

// MARK: - EditTrackerViewControllerDelegate
extension TrackersViewController: FilterViewControllerDelegate {
    func update() {
        updateSelectedCategories(selectedDate: selectedDate, weekday: weekDay)
    }
    
    func selectedOnlyCompleteTrackerFilter(isShowOnlyCompletedTracker: Bool) {
        self.isShowOnlyCompletedTracker = isShowOnlyCompletedTracker
    }
    
    func selectedOnlyUnCompleteTrackerFilter(isShowOnlyUnCompletedTracker: Bool) {
        self.isShowOnlyUnCompletedTracker = isShowOnlyUnCompletedTracker
    }
    
    func updateSelectedFilter(selectedFilter: String) {
        self.selectedFilter = selectedFilter
    }
    
    func changeDate() {
        delegate?.changeDatePicker()
    }
    
}
