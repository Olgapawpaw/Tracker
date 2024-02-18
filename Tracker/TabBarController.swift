import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        addBorder(color: UIColor.ypLightGray, thickness: 1.00)
    }
    
    private func generateTabBar() {
        viewControllers = [
        generateVC(
            viewController: TrackerViewController(),
            image: UIImage(named: "Tracker"),
            title: "Трекеры"),
        generateVC(
            viewController: StatisticsViewController(),
            image: UIImage(named: "Statistics"),
            title: "Статистика")
        ]
        
        self.setViewControllers(viewControllers, animated: true)
    }
    
    private func generateVC(viewController: UIViewController, image: UIImage?, title: String) -> UIViewController {
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.navigationController?.navigationBar.prefersLargeTitles = true
        nav.viewControllers.first?.navigationItem.title = title
        //let button = createAddTrackerButton()
        //nav.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        return nav
    }
    
    private func addBorder(color: UIColor, thickness: CGFloat){
        let subView = UIView()
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.backgroundColor = color
        tabBar.addSubview(subView)
        subView.leftAnchor.constraint(equalTo: tabBar.leftAnchor, constant: 0).isActive = true
        subView.rightAnchor.constraint(equalTo: tabBar.rightAnchor, constant: 0).isActive = true
        subView.heightAnchor.constraint(equalToConstant: thickness).isActive = true
        subView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0).isActive = true
    }
    
    private func createAddTrackerButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "AddTracker"), for: .normal)
        return button
    }
}
