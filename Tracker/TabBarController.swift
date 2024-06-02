import Foundation
import UIKit


final class TabBarController: UITabBarController, UISearchBarDelegate, UITabBarControllerDelegate {
    // MARK: - Public Properties
    let search = UISearchController(searchResultsController: nil)
    
    // MARK: - Private Properties
    private let createTreackerTitle = NSLocalizedString("createTreacker.title", comment: "")
    private let trekers = NSLocalizedString("trekers", comment: "")
    private let statistics = NSLocalizedString("statistics", comment: "")
    private let cancelEntry = NSLocalizedString("cancelEntry", comment: "")
    private let searchText = NSLocalizedString("search", comment: "")
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
        navigationController.viewControllers.first?.navigationItem.title = createTreackerTitle
        trackerViewController.navigationController?.present(navigationController, animated: true)
    }
    
    // MARK: - Private Methods
    private func generateTabBar() {
        viewControllers = [
            generateVCTracker(
                viewController: trackerViewController,
                image: UIImage(named: "Tracker"),
                title: trekers),
            generateVCStatistics(
                viewController: StatisticsViewController(),
                image: UIImage(named: "Statistics"),
                title: statistics)
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
        if traitCollection.userInterfaceStyle == .dark {
            button.setImage(UIImage(named: "AddTrackerNight"), for: .normal)
        } else {
            button.setImage(UIImage(named: "AddTrackerDay"), for: .normal)
        }
        button.imageView?.tintColor = UIColor.black
        button.addTarget(self,
                         action: #selector(onClickAddTrackersButton(_:)),
                         for: .touchUpInside)
        let buttonItem = UIBarButtonItem(customView: button)
        return buttonItem
    }
    
    private func createSearchController() -> UISearchController {
        search.searchBar.placeholder = searchText
        search.searchResultsUpdater = self
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.setValue(cancelEntry, forKey: "cancelButtonText")
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
        if !searchIsEmpty {
            trackerViewController.updateSearchSelectedCategories(text: searchController.searchBar.text!.lowercased())
        } else {
            trackerViewController.updateSelectedCategories(selectedDate: selectedDate, weekday: weekday)
        }
    }
}
