import Foundation
import UIKit


protocol TrackerCollectionViewCellDelegate: AnyObject {
    func changeCompletedTrackers(_ cell: TrackerCollectionViewCell)
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    weak var delegate: TrackerCollectionViewCellDelegate?
    let image = UIImageView()
    let titleLabel = UILabel()
    let countLabel = UILabel()
    let button = UIButton()
    let emoji = UILabel()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(image)
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(button)
        contentView.addSubview(emoji)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        emoji.translatesAutoresizingMaskIntoConstraints = false
        
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.numberOfLines = 2
        countLabel.textColor = UIColor.ypBlack
        countLabel.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self,
                         action: #selector(onClick),
                         for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        emoji.font = UIFont.systemFont(ofSize: 14)
        emoji.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        emoji.textAlignment = .center
        emoji.layer.cornerRadius = 12
        emoji.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leftAnchor.constraint(equalTo: leftAnchor),
            image.rightAnchor.constraint(equalTo: rightAnchor),
            image.bottomAnchor.constraint(equalTo: topAnchor, constant: 90),
            titleLabel.topAnchor.constraint(equalTo: image.topAnchor, constant: 44),
            titleLabel.rightAnchor.constraint(equalTo: image.rightAnchor, constant: -12),
            titleLabel.leftAnchor.constraint(equalTo: image.leftAnchor, constant: 12),
            titleLabel.widthAnchor.constraint(equalToConstant: 143),
            titleLabel.heightAnchor.constraint(equalToConstant: 34),
            countLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16),
            countLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            countLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 54),
            button.rightAnchor.constraint(equalTo: image.rightAnchor, constant: -12),
            button.centerYAnchor.constraint(equalTo: countLabel.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 34),
            button.heightAnchor.constraint(equalToConstant: 34),
            emoji.widthAnchor.constraint(equalToConstant: 24),
            emoji.heightAnchor.constraint(equalToConstant: 24),
            emoji.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            emoji.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
        ])
    }
    
    // MARK: - IB Actions
    @objc func onClick() { //при нажатии на кнопку "+"
        delegate?.changeCompletedTrackers(self)
    }
    
    //обязательный инициализатор
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
