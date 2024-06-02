import Foundation
import UIKit


final class PageViewController: UIViewController {
    // MARK: - Private Properties
    private var buttonText = NSLocalizedString("onboarding.close", comment: "Text button for close onboarding")
    private var text = String()
    private var image = UIImage()
    private var currentPage = Int()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let button = UIButton()
    private let pageControl = UIPageControl()
    
    // MARK: - Initializers
    init(text: String, image: UIImage, currentPage: Int) {
        self.text = text
        self.currentPage = currentPage
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - IB Actions
    @objc private func onClick() {
        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        guard let window = UIApplication.shared.windows.first else { return }
        window.rootViewController = TabBarController()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        [imageView, titleLabel, button, pageControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        imageView.image = image
        titleLabel.text = text
        titleLabel.textColor = UIColor.ypBlack
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        button.addTarget(self,
                         action: #selector(onClick),
                         for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.black
        button.setTitle(buttonText, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3)
        pageControl.numberOfPages = 2
        pageControl.currentPage = currentPage
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 388),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 77),
            
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
