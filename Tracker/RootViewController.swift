import Foundation
import UIKit


final class RootViewController: UIViewController {
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let isUnFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        let rootController: UIViewController
        if isUnFirstLaunch {
            rootController = TabBarController()
        } else {
            rootController = OnboardingViewController()
        }
        guard let window = UIApplication.shared.windows.first else { return }
        window.rootViewController = rootController
    }
}
