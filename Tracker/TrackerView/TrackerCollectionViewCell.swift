import Foundation
import UIKit


protocol TrackerCollectionViewCellDelegate: AnyObject {
    func changeCompletedTrackers(_ cell: TrackerCollectionViewCell)
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    // MARK: - Public Properties
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    // MARK: - Private Properties
    let topContainer = UIView()
    private let imagePin = UIImageView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private let button = UIButton()
    private let emoji = UILabel()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        [topContainer, countLabel, button].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        [titleLabel, emoji].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topContainer.addSubview($0)
        }
        imagePin.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        imagePin.image = UIImage(named: "Pin")
        topContainer.layer.cornerRadius = 16
        topContainer.layer.masksToBounds = true
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
            topContainer.topAnchor.constraint(equalTo: topAnchor),
            topContainer.leftAnchor.constraint(equalTo: leftAnchor),
            topContainer.rightAnchor.constraint(equalTo: rightAnchor),
            topContainer.bottomAnchor.constraint(equalTo: topAnchor, constant: 90),
            titleLabel.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 44),
            titleLabel.rightAnchor.constraint(equalTo: topContainer.rightAnchor, constant: -12),
            titleLabel.leftAnchor.constraint(equalTo: topContainer.leftAnchor, constant: 12),
            titleLabel.widthAnchor.constraint(equalToConstant: 143),
            titleLabel.heightAnchor.constraint(equalToConstant: 34),
            countLabel.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 16),
            countLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            countLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 54),
            button.rightAnchor.constraint(equalTo: topContainer.rightAnchor, constant: -12),
            button.centerYAnchor.constraint(equalTo: countLabel.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 34),
            button.heightAnchor.constraint(equalToConstant: 34),
            emoji.widthAnchor.constraint(equalToConstant: 24),
            emoji.heightAnchor.constraint(equalToConstant: 24),
            emoji.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            emoji.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func updateCountLabel(text: String) {
        countLabel.text = text
    }
    
    func updateTitleLabel(text: String) {
        titleLabel.text = text
    }
    
    func updateEmoji(text: String) {
        emoji.text = text
    }
    
    func updateColorImage(color: UIColor) {
        topContainer.backgroundColor = color
    }
    
    func showImagePin() {
        topContainer.addSubview(imagePin)
        NSLayoutConstraint.activate([
            imagePin.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 18),
            imagePin.rightAnchor.constraint(equalTo: topContainer.rightAnchor, constant: -12),
            imagePin.widthAnchor.constraint(equalToConstant: 8),
            imagePin.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    func hideImagePin() {
        imagePin.removeFromSuperview()
    }
    
    func updateButton(backgroundColor: UIColor, tintColor: UIColor, imageButton: UIImage) {
        button.setImage(imageButton, for: .normal)
        button.backgroundColor = backgroundColor
        button.tintColor = tintColor
    }
    
    // MARK: - IB Actions
    @objc func onClick() { //при нажатии на кнопку "+"
        AnalyticsService.report(event: "click", params: ["screen" : "Main", "item" : "track"])
        delegate?.changeCompletedTrackers(self)
    }
}
