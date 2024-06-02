import Foundation
import UIKit


final class OnboardingViewController: UIPageViewController {
    // MARK: - Private Properties
    private let title1 = NSLocalizedString("onboarding.title1", comment: "Text displayed on onboarding")
    private let title2 = NSLocalizedString("onboarding.title2", comment: "Text displayed on onboarding")
    private lazy var pages: [UIViewController] = {
        let pages1 = PageViewController(text: title1,
                                        image: UIImage(named: "Page1") ?? UIImage(),
                                        currentPage: 0)
        let pages2 = PageViewController(text: title2,
                                        image: UIImage(named: "Page2") ?? UIImage(),
                                        currentPage: 1)
        return [pages1, pages2]
    }()
    
    // MARK: - Initializers
    override init(transitionStyle: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]?) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        dataSource = self
        super.viewDidLoad()
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return nil
        }
        return pages[nextIndex]
    }
}

