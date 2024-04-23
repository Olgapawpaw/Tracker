import Foundation
import UIKit

class TrackerViewController: UIViewController {
    
    //переменная коллекции
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let scrollView = UIScrollView()
    
    var selectDate: String = ""
    var currentCategories: [TrackerCategory] = []
    var categories = [TrackerCategory(name: "Домашний уют",
                                     trackers: [Tracker(id: 1,
                                                        name: "Поливать растения",
                                                        color: UIColor.red,
                                                        emoji: UIImage(named: "emoji_1"),
                                                        sheduler: [WeekDay.tuesday,
                                                                   WeekDay.saturday])
                                     ]),
                      TrackerCategory(name: "Радостные мелочи",
                                      trackers: [Tracker(id: 2,
                                                         name: "Кошка заслонила камеру на созвоне",
                                                         color: UIColor.blue,
                                                         emoji: UIImage(named: "emoji_1"),
                                                         sheduler: [WeekDay.monday,
                                                                    WeekDay.friday]),
                                                 Tracker(id: 3,
                                                         name: "Бабушка прислала открытку",
                                                         color: UIColor.green,
                                                         emoji: UIImage(named: "emoji_1"),
                                                         sheduler: [WeekDay.monday,
                                                                    WeekDay.friday,
                                                                    WeekDay.tuesday])
                                                 ]
                                     ),
                      TrackerCategory(name: "Мелочи",
                                      trackers: [Tracker(id: 4,
                                                         name: "Кошка заслонила камеру на созвоне",
                                                         color: UIColor.yellow,
                                                         emoji: UIImage(named: "emoji_1"),
                                                         sheduler: [WeekDay.monday,
                                                                    WeekDay.friday]),
                                                 Tracker(id: 5,
                                                         name: "Бабушка прислала открытку",
                                                         color: UIColor.green,
                                                         emoji: UIImage(named: "emoji_1"),
                                                         sheduler: [WeekDay.monday,
                                                                    WeekDay.friday,
                                                                    WeekDay.tuesday]),
                                                 Tracker(id: 6,
                                                         name: "Бабушка прислала открытку",
                                                         color: UIColor.green,
                                                         emoji: UIImage(named: "emoji_1"),
                                                         sheduler: [WeekDay.monday,
                                                                    WeekDay.friday,
                                                                    WeekDay.tuesday])
                                                 ]
                                     )
                      ]
    var completedTrackers: [TrackerRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        currentCategories = categories
        
        if currentCategories.isEmpty {
            screenForNoTracker()
        } else {
            setupScrollView()
            createCollection()
        }
    }
    
    //Заглушка при отсутсвии трекеров
    private func screenForNoTracker() {
        let image = UIImageView(image: UIImage(named: "MainViewError"))
        let label = UILabel()
        view.addSubview(image)
        view.addSubview(label)
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.textColor = UIColor.ypBlack
        label.font = UIFont.systemFont(ofSize: 12)
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 80),
            image.widthAnchor.constraint(equalToConstant: 80),
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8),
        ])
    }
    
    //создание коллекции
    private func createCollection() {
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "cell") //регистрируем ячейки для отображения
        collectionView.register(TrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header") // регистрируем хедер
        scrollView.addSubview(collectionView) // добавляем коллекцию на view
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
    
    //задание расположения scrollView
    func setupScrollView() {
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), //safeAreaLayoutGuide чтобы не захватывать всю область экрана
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ])
    }
    
    func updateTrackersAfterUpdateDate(selectedDate: String, dayOfTheWeek: String) {
        currentCategories.removeAll()
        for i in categories {
            for j in i.trackers {
                if j.sheduler.filter({ $0.rawValue == dayOfTheWeek}) .isEmpty {
                    currentCategories.append(TrackerCategory(name: i.name, trackers: [j]))
                }
            }
        }
        selectDate = selectedDate
        collectionView.reloadData()
    }
}

extension TrackerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in: UICollectionView) -> Int { //количество секций
        return currentCategories.count
    }
    
    //количество ячеек в секции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCategories[section].trackers.count
    }
    
    //ячейка для заданной позиции IndexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell // экземпляр ячейки
        //let selectDate = selectDate //получаем выбраную дату

        cell?.delegate = self
        
        cell?.countLabel.text = "\(completedTrackers.filter{ $0.id == currentCategories[indexPath.section].trackers[indexPath.item].id}.count) дней"
        cell?.titleLabel.text = currentCategories[indexPath.section].trackers[indexPath.item].name //название трекера
        cell?.image.backgroundColor = currentCategories[indexPath.section].trackers[indexPath.item].color // цвет карточки
        cell?.emojiImage.image = currentCategories[indexPath.section].trackers[indexPath.item].emoji // эмодзи
        
        //задание кнопки в зависимости от нажатия
        if completedTrackers.filter({ $0.id == currentCategories[indexPath.section].trackers[indexPath.item].id && $0.date == selectDate}) .isEmpty {
            cell?.button.setImage(UIImage(named:"AddDay")?.withRenderingMode(.alwaysTemplate), for: .normal) // .withRenderingMode(.alwaysTemplate) для возможности изменения цвета картинки
            cell?.button.tintColor = currentCategories[indexPath.section].trackers[indexPath.item].color
        } else {
            cell?.button.setImage(UIImage(named:"DoneDay")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell?.button.tintColor = currentCategories[indexPath.section].trackers[indexPath.item].color
        }
        return cell!
    }
    
    //для задания хедера
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! TrackerSupplementaryView
        header.titleLabel.text = currentCategories[indexPath.section].name
        return header
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
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
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                         withHorizontalFittingPriority: .required,
                                                         verticalFittingPriority: .fittingSizeLevel)
    }
}

extension TrackerViewController: TrackerCollectionViewCellDelegate {
    //добавление/удаление id, date из completedTrackers
    func changeCompletedTrackers(_ cell: TrackerCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell)
        else { return }
        if completedTrackers.filter({ $0.id == currentCategories[indexPath.section].trackers[indexPath.item].id && $0.date == selectDate}) .isEmpty {
            completedTrackers.append(TrackerRecord(id: currentCategories[indexPath.section].trackers[indexPath.item].id, date: selectDate))
        } else {
            for (iCurrentIndex, i) in completedTrackers.enumerated () {
                if i.id == currentCategories[indexPath.section].trackers[indexPath.item].id && i.date == selectDate {
                    completedTrackers.remove(at: iCurrentIndex)
                }
            }
        }
        collectionView.reloadData()
    }
}
