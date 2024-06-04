import Foundation
import UIKit


final class CreateNewTrackerSupplementaryView: UICollectionReusableView {
    // MARK: - Private Properties
    private let titleLabel = UILabel()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.ypBlack
        titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func updateTitleLabel(text: String){
        titleLabel.text = text
    }
}
