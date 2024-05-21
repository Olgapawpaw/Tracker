import Foundation
import UIKit

final class NewHabitCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    let label = UILabel()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            label.widthAnchor.constraint(equalToConstant: 32),
            label.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
