import Foundation
import UIKit


protocol NewTrackerViewControllerDelegate: AnyObject {
    func addCategory(newCategory: TrackerCategory, newTracker: Tracker)
}

final class NewTrackerViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: NewTrackerViewControllerDelegate?
    
    // MARK: - Private Properties
    private let newTrackerTitle = NSLocalizedString("newTracker.title", comment: "Text title on create new habbit")
    private let habbit = NSLocalizedString("habbit", comment: "")
    private let event = NSLocalizedString("event", comment: "")
    private let newEventTitle = NSLocalizedString("newEvent.title", comment: "")
    private let habitButton = UIButton()
    private let eventButton = UIButton()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.viewBackgroundColor
        setupButton()
    }
    
    // MARK: - IB Actions
    @objc private func onClickHabitButton(_ sender: UIButton) {
        let viewController = NewHabitViewController()
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.viewControllers.first?.navigationItem.title = newTrackerTitle
        self.navigationController?.present(navigationController, animated: true)
    }
    
    @objc private func onClickEventButton(_ sender: UIButton) {
        let viewController = NewEventViewController()
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.viewControllers.first?.navigationItem.title = newEventTitle
        self.navigationController?.present(navigationController, animated: true)
    }
    
    // MARK: - Private Methods
    private func setupButton() {
        chaneButton(button: habitButton, titleLabel: habbit)
        chaneButton(button: eventButton, titleLabel: event)
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
extension NewTrackerViewController: NewHabitViewControllerDelegate, NewEventViewControllerDelegate {
    func addCategory(newCategory: TrackerCategory, newTracker: Tracker) {
        delegate?.addCategory(newCategory: newCategory, newTracker: newTracker)
    }
}
