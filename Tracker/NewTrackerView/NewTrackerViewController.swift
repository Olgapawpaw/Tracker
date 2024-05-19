import Foundation
import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func updateCategory(newCategory: TrackerCategory)
}

final class NewTrackerViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: NewTrackerViewControllerDelegate?
    
    // MARK: - Private Properties
    private let habitButton = UIButton()
    private let eventButton = UIButton()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupButton()
    }
    
    // MARK: - IB Actions
    @objc private func onClickHabitButton(_ sender: UIButton) {
        let viewController = NewHabitViewController()
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.viewControllers.first?.navigationItem.title = "Новая привычка"
        self.navigationController?.present(navigationController, animated: true)
    }
    
    @objc private func onClickEventButton(_ sender: UIButton) {
        
    }
    
    // MARK: - Private Methods
    private func setupButton() {
        chaneButton(button: habitButton, titleLabel: "Привычка")
        chaneButton(button: eventButton, titleLabel: "Нерегулярное событие")
        habitButton.addTarget(self,
                              action: #selector(onClickHabitButton),
                              for: .touchUpInside)
        eventButton.addTarget(self,
                              action: #selector(onClickEventButton),
                              for: .touchUpInside)
        NSLayoutConstraint.activate([
            habitButton.widthAnchor.constraint(equalToConstant: 335),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -357),
            eventButton.widthAnchor.constraint(equalToConstant: 335),
            eventButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16)
        ])
    }
    
    private func chaneButton(button: UIButton, titleLabel: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.ypBlack
        button.setTitle(titleLabel, for: .normal)
    }
}

// MARK: - NewHabitViewControllerDelegate
extension NewTrackerViewController: NewHabitViewControllerDelegate {
    func updateCategory(newCategory: TrackerCategory) {
        delegate?.updateCategory(newCategory: newCategory)
    }
}