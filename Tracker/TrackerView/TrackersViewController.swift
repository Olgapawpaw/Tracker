import Foundation
import UIKit


final class TrackersViewController: UIViewController {
    // MARK: - Public Properties
    var selectedCategories = [TrackerCategory]()
    
    // MARK: - Private Properties
    private let emptyTrekers = NSLocalizedString("emptyTrekers", comment: "Text displayed if no trakers")
    private let noSelectedTrakers = NSLocalizedString("noSelectedTrakers", comment: "Text displayed if no trakers before filtered")
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let scrollView = UIScrollView()
    private let noTrackersImage = UIImageView()
    private let noTrackersLabel = UILabel()
    private var selectedDate = Date()
    private var weekDay = Int()
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private var isNoTracker = Bool()
    private var helpers = Helpers()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.viewBackgroundColor
        setupScrollView()
        createCollection()
        updateSelectedCategories(selectedDate: helpers.getNowDate(), weekday: helpers.getNowWeekday())
    }
    
    // MARK: - Public Methods
    func addCategory(newCategory: TrackerCategory, newTracker: Tracker) {
        let trackerCategoryForCoreData = TrackerCategoryForCoreData(name: newCategory.name, id: newTracker.id)
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
        do {
            let trackerCoreData = try trackerStore.getSelectedTrackers(day: weekday)
            selectedCategories = trackerCategoryStore.getTrackerCategory(trackerCoreData: trackerCoreData)
        } catch let error as NSError {
            print(error.userInfo)
        }
        isNoTracker = trackerStore.checkExistTrackers()
        self.selectedDate = selectedDate
        self.weekDay = weekday
        didUpdate()
    }
    
    // MARK: - Private Methods
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), //safeAreaLayoutGuide чтобы не захватывать всю область экрана
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in: UICollectionView) -> Int { //количество секций
        return selectedCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //количество ячеек в секции
        return selectedCategories[section].trackers.count
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
            cell.updateButton(backgroundColor: UIColor.white.withAlphaComponent(1.0),
                              tintColor: selectedCategories[indexPath.section].trackers[indexPath.item].color.withAlphaComponent(1.0),
                              imageButton: UIImage(named:"AddDay")?.withRenderingMode(.alwaysTemplate) ?? UIImage())
        } else {
            cell.updateButton(backgroundColor: selectedCategories[indexPath.section].trackers[indexPath.item].color.withAlphaComponent(0.3),
                              tintColor: UIColor.white,
                              imageButton: UIImage(named:"DoneDay")?.withRenderingMode(.alwaysTemplate) ?? UIImage())
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {     //для задания хедера
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! TrackerSupplementaryView
        header.updateTitleLabel(text: selectedCategories[indexPath.section].name)
        return header
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
        let nowDate = helpers.getNowDate()
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
        }
    }
}

// MARK: - TrackerCategoryStoreDelegate
extension TrackersViewController: TrackerCategoryStoreDelegate {
    func didUpdate() {
        if isNoTracker {
            setupNoTracker(title: emptyTrekers, imageName: "MainViewError")
        } else {
            if selectedCategories.isEmpty {
                collectionView.reloadData()
                setupNoTracker(title: noSelectedTrakers, imageName: "NoTrackerAfterFiltering")
            } else {
                hideNoTracker()
                collectionView.reloadData()
            }
        }
    }
}
