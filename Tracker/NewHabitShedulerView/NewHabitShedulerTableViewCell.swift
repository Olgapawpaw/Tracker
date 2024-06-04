import Foundation
import UIKit

protocol NewHabitShedulerTableViewCellDelegate: AnyObject {
    func switchChanged(_ sender : UISwitch!)
}

final class NewHabitShedulerTableViewCell: UITableViewCell {
    weak var delegete: NewHabitShedulerTableViewCellDelegate?
    
    // MARK: - Private Properties
    private let buttonLabel = UILabel()
    private let switchView = UISwitch(frame: .zero)
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        self.backgroundColor = UIColor.ypLightGray.withAlphaComponent(0.3)
        contentView.addSubview(buttonLabel)
        buttonLabel.font = UIFont.systemFont(ofSize: 17)
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        switchView.setOn(false, animated: true)
        switchView.onTintColor = UIColor.ypBlue
        switchView.addTarget(self,
                             action: #selector(switchChanged(_:)),
                             for: .valueChanged)
        self.accessoryView = switchView
        self.selectionStyle = .none
        NSLayoutConstraint.activate([
            buttonLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            buttonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -41),
            buttonLabel.heightAnchor.constraint(equalToConstant: 26),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IB Actions
    @objc func switchChanged(_ sender : UISwitch!){
        delegete?.switchChanged(sender)
    }
    
    // MARK: - Public Methods
    func updateButtonLabel(text: String) {
        buttonLabel.text = text
    }
    
    func switchViewTag(tag: Int) {
        switchView.tag = tag
    }
    
    func switchViewIsOn() {
        switchView.isOn = true
    }
}
