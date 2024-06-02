import Foundation
import UIKit


protocol CreateNewCategoryViewControllerDelegate: AnyObject {
    func updateData()
}

final class CreateNewCategoryViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: CreateNewCategoryViewControllerDelegate?
    
    // MARK: - Private Properties
    private let newCategoryName = NSLocalizedString("newCategory.name", comment: "")
    private let ready = NSLocalizedString("ready", comment: "")
    private let categoryNameTextField = UITextField()
    private let readyButton = UIButton()
    private let newCategory = String()
    private let trackerCategoryStore = TrackerCategoryStore()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.viewBackgroundColor
        setupCategoryNameTextField()
        setupButton()
    }
    
    // MARK: - IB Actions
    @objc private func changeCategoryNameTextField() {
        activateCreateButton()
    }
    
    @objc private func onClick() {
        guard let categoryName: String = categoryNameTextField.text
        else { return }
        try? trackerCategoryStore.addNewTrackerCategory(categoryName)
        delegate?.updateData()
        self.dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    private func setupCategoryNameTextField() {
        view.addSubview(categoryNameTextField)
        categoryNameTextField.translatesAutoresizingMaskIntoConstraints = false
        categoryNameTextField.backgroundColor = UIColor.ypLightGray.withAlphaComponent(0.3)
        categoryNameTextField.layer.cornerRadius = 16
        categoryNameTextField.layer.masksToBounds = true
        categoryNameTextField.placeholder = newCategoryName
        categoryNameTextField.font = UIFont.systemFont(ofSize: 17)
        categoryNameTextField.clearButtonMode = .always
        categoryNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        categoryNameTextField.leftViewMode = .always
        categoryNameTextField.addTarget(self,
                                        action: #selector(changeCategoryNameTextField),
                                        for: .allEditingEvents)
        NSLayoutConstraint.activate([
            categoryNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 24),
            categoryNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            categoryNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setupButton() {
        changeButton(tittle: ready,
                     colorTitle: UIColor.white,
                     colorBackround: UIColor.ypGray,
                     button: readyButton)
        readyButton.addTarget(self,
                              action: #selector(onClick),
                              for: .touchUpInside)
        readyButton.isEnabled = false
        NSLayoutConstraint.activate([
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            readyButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func changeButton(tittle: String, colorTitle: UIColor, colorBackround: UIColor, button: UIButton) {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(tittle, for: .normal)
        button.setTitleColor(colorTitle, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = colorBackround
    }
    
    private func activateCreateButton() {
        if categoryNameTextField.text?.isEmpty == true {
            changeButton(tittle: ready,
                         colorTitle: UIColor.white,
                         colorBackround: UIColor.ypGray,
                         button: readyButton)
            readyButton.isEnabled = false
        } else {
            changeButton(tittle: ready,
                         colorTitle: UIColor.white,
                         colorBackround: UIColor.black,
                         button: readyButton)
            readyButton.isEnabled = true
        }
    }
}
