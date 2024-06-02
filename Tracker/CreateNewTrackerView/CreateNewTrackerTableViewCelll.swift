import Foundation
import UIKit


final class CreateNewTrackerTableViewCell: UITableViewCell {
    // MARK: - Private Properties
    private let titleLabel = UILabel()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        self.backgroundColor = UIColor.ypLightGray.withAlphaComponent(0.3)
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 46)
        ])
    }
    
    // MARK: - Public Methods
    func updateTitleLabelText(text: String) {
        titleLabel.text = text
    }
    
    func updateTitleLabelAttributedText(attribut: NSAttributedString) {
        titleLabel.attributedText = attribut
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

