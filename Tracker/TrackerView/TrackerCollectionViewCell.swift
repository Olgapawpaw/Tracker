import Foundation
import UIKit

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func changeCompletedTrackers(_ cell: TrackerCollectionViewCell)
}

//класс ячеек в коллекции
class TrackerCollectionViewCell: UICollectionViewCell {
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    let image = UIImageView()
    let titleLabel = UILabel()
    let countLabel = UILabel()
    let button = UIButton()
    let backgroundEmojiImage = UIImageView()
    let emojiImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(image)
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(button)
        contentView.addSubview(backgroundEmojiImage)
        contentView.addSubview(emojiImage)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        backgroundEmojiImage.translatesAutoresizingMaskIntoConstraints = false
        emojiImage.translatesAutoresizingMaskIntoConstraints = false
        
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
        backgroundEmojiImage.layer.cornerRadius = 12
        backgroundEmojiImage.layer.masksToBounds = true
        backgroundEmojiImage.backgroundColor = UIColor.ypLightGray.withAlphaComponent(0.3) //.withAlphaComponent(0.3) чтобы цвет был прозрачным

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
            backgroundEmojiImage.widthAnchor.constraint(equalToConstant: 24),
            backgroundEmojiImage.heightAnchor.constraint(equalToConstant: 24),
            backgroundEmojiImage.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            backgroundEmojiImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            emojiImage.centerXAnchor.constraint(equalTo: backgroundEmojiImage.centerXAnchor),
            emojiImage.centerYAnchor.constraint(equalTo: backgroundEmojiImage.centerYAnchor),
            emojiImage.widthAnchor.constraint(equalToConstant: 16),
            emojiImage.heightAnchor.constraint(equalToConstant: 16),
         ])
    }
    
    @objc func onClick() { //при нажатии на кнопку "+"
        delegate?.changeCompletedTrackers(self)
    }
    
    //обязательный инициализатор
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
