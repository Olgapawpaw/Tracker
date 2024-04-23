import Foundation
import UIKit


class TabBarController: UITabBarController, UISearchBarDelegate {
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        addBorderForTabBar(color: UIColor.ypLightGray, thickness: 1.00)
    }
    
    private func generateTabBar() {
        viewControllers = [
        generateVCTracker(
            viewController: TrackerViewController(),
            image: UIImage(named: "Tracker"),
            title: "Трекеры"),
        generateVCStatistics(
            viewController: StatisticsViewController(),
            image: UIImage(named: "Statistics"),
            title: "Статистика")
        ]
    }
    
    // Создание VC для вкладки Трекеры
    private func generateVCTracker(viewController: UIViewController,
                                   image: UIImage?,
                                   title: String) -> UIViewController {
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.navigationBar.prefersLargeTitles = true
        nav.viewControllers.first?.navigationItem.title = title
        
        nav.viewControllers.first?.navigationItem.leftBarButtonItem = createAddTrackerButtonItem()
        nav.viewControllers.first?.navigationItem.searchController = createSearchController()
        nav.viewControllers.first?.navigationItem.rightBarButtonItem = createDate()
        return nav
    }
    
    // Создание VC для вкладки Статистика
    private func generateVCStatistics(viewController: UIViewController,
                                   image: UIImage?,
                                   title: String) -> UIViewController {
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.navigationBar.prefersLargeTitles = true
        nav.viewControllers.first?.navigationItem.title = title
        return nav
    }
    
    // Создание бордюра для tabBar для соотвествия макету
    private func addBorderForTabBar(color: UIColor, thickness: CGFloat){
        let subView = UIView()
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.backgroundColor = color
        tabBar.addSubview(subView)
        NSLayoutConstraint.activate([
            subView.leftAnchor.constraint(equalTo: tabBar.leftAnchor, constant: 0),
            subView.rightAnchor.constraint(equalTo: tabBar.rightAnchor, constant: 0),
            subView.heightAnchor.constraint(equalToConstant: thickness),
            subView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0)
        ])
    }
    
    // Создание кнопки добавления трекера
    private func createAddTrackerButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(named: "AddTracker"), for: .normal)
        let buttonItem = UIBarButtonItem(customView: button)
        return buttonItem
    }
    
    //Создание панели поиска
    private func createSearchController() -> UISearchController {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Поиск"
        return search
    }
    
    //Создание поля выбора даты
    private func createDate() -> UIBarButtonItem {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU") //для изменения формата на дд.мм.гггг
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        let date = UIBarButtonItem(customView: datePicker)
        date.customView?.widthAnchor.constraint(equalToConstant: 120).isActive = true //для искуственного изменения формата на дд.мм.гггг без текста
        return date
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        presentedViewController?.dismiss(animated: true, completion: nil)
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        //let weekday = calendar.component(.weekday, from: selectedDate)
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        TrackerViewController().updateTrackersAfterUpdateDate(selectedDate: formattedDate, dayOfTheWeek: "Вторник")
    }
}
