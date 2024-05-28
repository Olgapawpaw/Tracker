import Foundation
import UIKit


final class TabBarController: UITabBarController, UISearchBarDelegate, UITabBarControllerDelegate {
    
    // MARK: - Public Properties
    let search = UISearchController(searchResultsController: nil)
    
    // MARK: - Private Properties
    private var searchIsEmpty: Bool {
        guard let text = search.searchBar.text else { return false }
        return text.isEmpty
    }
    private let datePicker = UIDatePicker()
    private let trackerViewController = TrackersViewController()
    private let statisticsViewController = StatisticsViewController()
    private let createNewTrackerViewController = NewTrackerViewController()
    private var weekday = Int()
    private var selectedDate = Date()
    private var helpers = Helpers()
    
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        addBorderForTabBar(color: UIColor.ypLightGray, thickness: 1.00)
        weekday = helpers.getNowWeekday()
        selectedDate = helpers.getNowDate()
    }
    
    // MARK: - IB Actions
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        let date = sender.date
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: date)
        selectedDate = calendar.date(from: dateComponents) ?? selectedDate
        weekday = calendar.component(.weekday, from: selectedDate)
        presentedViewController?.dismiss(animated: false, completion: nil)
        trackerViewController.updateSelectedCategories(selectedDate: selectedDate, weekday: weekday)
        search.isActive = false
    }
    
    @objc private func onClickAddTrackersButton(_ sender: UIButton) {
        let viewController = NewTrackerViewController()
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.viewControllers.first?.navigationItem.title = "Создание трекера"
        trackerViewController.navigationController?.present(navigationController, animated: true)
    }
    
    // MARK: - Private Methods
    private func generateTabBar() {
        viewControllers = [
            generateVCTracker(
                viewController: trackerViewController,
                image: UIImage(named: "Tracker"),
                title: "Трекеры"),
            generateVCStatistics(
                viewController: StatisticsViewController(),
                image: UIImage(named: "Statistics"),
                title: "Статистика")
        ]
    }
    
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
        nav.viewControllers.first?.navigationItem.rightBarButtonItem = createDatePicker()
        return nav
    }
    
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
    
    private func createAddTrackerButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(named: "AddTracker"), for: .normal)
        button.addTarget(self,
                         action: #selector(onClickAddTrackersButton(_:)),
                         for: .touchUpInside)
        let buttonItem = UIBarButtonItem(customView: button)
        return buttonItem
    }
    
    private func createSearchController() -> UISearchController {
        search.searchBar.placeholder = "Поиск"
        search.searchResultsUpdater = self
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        //search
        return search
    }
    
    private func createDatePicker() -> UIBarButtonItem {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self,
                             action: #selector(datePickerValueChanged(_:)),
                             for: .valueChanged)
        let date = UIBarButtonItem(customView: datePicker)
        date.customView?.widthAnchor.constraint(equalToConstant: 120).isActive = true
        return date
    }
}

// MARK: - NewTrackerViewControllerDelegate
extension TabBarController: NewTrackerViewControllerDelegate {
    func addCategory(newCategory: TrackerCategory, newTracker: Tracker) {
        trackerViewController.addCategory(newCategory: newCategory, newTracker: newTracker)
    }
}

// MARK: - UISearchResultsUpdating
extension TabBarController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchIsEmpty == false {
            trackerViewController.updateSearchSelectedCategories(text: searchController.searchBar.text!.lowercased())
        } else {
            trackerViewController.updateSelectedCategories(selectedDate: selectedDate, weekday: weekday)
        }
    }
}
