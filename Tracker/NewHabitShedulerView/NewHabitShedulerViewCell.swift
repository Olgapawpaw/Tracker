import Foundation
import UIKit


class NewHabitShedulerViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    let buttonLabel = UILabel()
    let switchView = UISwitch(frame: .zero)
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        self.backgroundColor = UIColor.ypLightGray
        contentView.addSubview(buttonLabel)
        buttonLabel.font = UIFont.systemFont(ofSize: 17)
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        switchView.setOn(false, animated: true)
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
}