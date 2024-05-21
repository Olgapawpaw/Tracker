import Foundation
import UIKit


final class TrackersViewController: UIViewController {
    
    // MARK: - Public Properties
    var categories = [TrackerCategory]()
    var selectedCategories = [TrackerCategory]()
    
    // MARK: - Private Properties
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let scrollView = UIScrollView()
    private let noTrackersImage = UIImageView()
    private let noTrackersLabel = UILabel()
    private var selectedDate = Date()
    private var weekDay = Int()
    private var completedTrackers = [TrackerRecord]()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupScrollView()
        createCollection()
        updateSelectedCategories(selectedDate: getNowDate(), weekday: getNowWeekday())
        customReloadData()
    }
    
    // MARK: - Public Methods
    func getNowDate() -> Date {
        let date = NSDate()
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: date as Date)
        let dateWithoutTime = calendar.date(from: dateComponents)!
        return dateWithoutTime
    }
    
    func getNowWeekday() -> Int {
        let time = NSDate()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: time as Date)
        return weekday
    }
    
    func addCategory(newCategory: TrackerCategory) {
        var isAddCategory = Bool()
        if categories.isEmpty == false {
            for (count, i) in categories.enumerated() {
                if i.name.contains(newCategory.name) {
                    categories[count].trackers.append(contentsOf: newCategory.trackers)
                    isAddCategory = true
                    break
                }
            }
            if isAddCategory == false {
                categories.append(newCategory)
            }
        } else {
            categories.append(newCategory)
        }
        updateSelectedCategories(selectedDate: selectedDate, weekday: weekDay)
        customReloadData()
    }
    
    func customReloadData() {
        if categories.isEmpty == true {
            setupNoTracker(title: "Что будем отслеживать?", imageName: "MainViewError")
        } else {
            if selectedCategories.isEmpty {
                collectionView.reloadData()
                setupNoTracker(title: "Ничего не найдено", imageName: "NoTrackerAfterFiltering")
            } else {
                hideNoTracker()
                collectionView.reloadData()
            }
        }
    }
    
    func updateSelectedCategories(selectedDate: Date, weekday: Int) {
        var selectedTrackers = [Tracker]()
        selectedCategories.removeAll()
        for i in categories {
            for j in i.trackers {
                if j.sheduler.filter({ $0.rawValue == weekday}).isEmpty == false  {
                    selectedTrackers.append(j)
                }
            }
            if selectedTrackers.isEmpty == false {
                selectedCategories.append(TrackerCategory(name: i.name, trackers: selectedTrackers))
                selectedTrackers.removeAll()
            }
        }
        self.selectedDate = selectedDate
        self.weekDay = weekday
        customReloadData()
    }
    
    // MARK: - Private Methods
    private func showNoTracker() {
        setupNoTracker(title: "Что будем отслеживать?", imageName: "MainViewError")
    }
    
    private func showNoTrackerAfterFiltering() {
        setupNoTracker(title: "Ничего не найдено", imageName: "NoTrackerAfterFiltering")
    }
    
    private func setupNoTracker(title: String, imageName: String) {
        view.addSubview(noTrackersImage)
        view.addSubview(noTrackersLabel)
        noTrackersImage.translatesAutoresizingMaskIntoConstraints = false
        noTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
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
        
        guard let cell = cell as? TrackerCollectionViewCell else {
            return TrackerCollectionViewCell()
        }
        
        cell.delegate = self
        switch completedTrackers.filter({ $0.id == selectedCategories[indexPath.section].trackers[indexPath.item].id}).count{
        case 1:
            cell.countLabel.text = "\(completedTrackers.filter{ $0.id == selectedCategories[indexPath.section].trackers[indexPath.item].id}.count) день"
        case 2, 3, 4:
            cell.countLabel.text = "\(completedTrackers.filter{ $0.id == selectedCategories[indexPath.section].trackers[indexPath.item].id}.count) дня"
        default:
            cell.countLabel.text = "\(completedTrackers.filter{ $0.id == selectedCategories[indexPath.section].trackers[indexPath.item].id}.count) дней"
        }
        cell.titleLabel.text = selectedCategories[indexPath.section].trackers[indexPath.item].name //название трекера
        cell.image.backgroundColor = selectedCategories[indexPath.section].trackers[indexPath.item].color // цвет карточки
        cell.emojiImage.image = selectedCategories[indexPath.section].trackers[indexPath.item].emoji // эмодзи
        //задание кнопки в зависимости от нажатия
        if completedTrackers.filter({ $0.id == selectedCategories[indexPath.section].trackers[indexPath.item].id && $0.date == selectedDate}) .isEmpty {
            cell.button.setImage(UIImage(named:"AddDay")?.withRenderingMode(.alwaysTemplate), for: .normal) // .withRenderingMode(.alwaysTemplate) для возможности изменения цвета картинки
            cell.button.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            cell.button.tintColor = selectedCategories[indexPath.section].trackers[indexPath.item].color.withAlphaComponent(1.0)
        } else {
            cell.button.setImage(UIImage(named:"DoneDay")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.button.backgroundColor = selectedCategories[indexPath.section].trackers[indexPath.item].color.withAlphaComponent(0.3)
            cell.button.tintColor = UIColor.white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {     //для задания хедера
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! TrackerSupplementaryView
        header.titleLabel.text = selectedCategories[indexPath.section].name
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
        let nowDate = getNowDate()
        if selectedDate <= nowDate {
            guard let indexPath = collectionView.indexPath(for: cell)
            else { return }
            if completedTrackers.filter({ $0.id == selectedCategories[indexPath.section].trackers[indexPath.item].id && $0.date == selectedDate}) .isEmpty {
                completedTrackers.append(TrackerRecord(id: selectedCategories[indexPath.section].trackers[indexPath.item].id, date: selectedDate))
            } else {
                for (iCurrentIndex, i) in completedTrackers.enumerated () {
                    if i.id == selectedCategories[indexPath.section].trackers[indexPath.item].id && i.date == selectedDate {
                        completedTrackers.remove(at: iCurrentIndex)
                    }
                }
            }
            customReloadData()
        }
    }
}
