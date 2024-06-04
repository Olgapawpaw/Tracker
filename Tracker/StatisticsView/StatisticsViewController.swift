import Foundation
import UIKit


final class StatisticsViewController: UIViewController {
    // MARK: - Private Properties
    private let noDataLabel = UILabel()
    private let noDataImage = UIImageView()
    private var countCompletedTrackersLabel = UILabel()
    private var completedTrackersLabel = UILabel()
    private let borderImage = UIImageView()
    private let emptyImage = UIImageView()
    private let noDataLabelText = NSLocalizedString("emptyStatistics", comment: "")
    private let format = NSLocalizedString("numberOfTrackers", comment: "")
    private var countCompletedDay = Int()
    private let trackerRecordStore = TrackerRecordStore()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.viewBackgroundColor
        setupView()
    }
    
    // MARK: - Public Methods
    func setupView() {
        self.countCompletedDay = trackerRecordStore.countTrackerRecordAllTrackers()
        if trackerRecordStore.checkExistTrackerRecordAllTrackers() {
            noDataLabel.removeFromSuperview()
            noDataImage.removeFromSuperview()
            setupCountCompletedTrackers()
        } else {
            [countCompletedTrackersLabel, completedTrackersLabel, borderImage, emptyImage].forEach {
                $0.removeFromSuperview()
            }
            setupNoStatictics()
        }
    }
    
    // MARK: - Private Methods
    private func setupNoStatictics() {
        view.addSubview(noDataLabel)
        view.addSubview(noDataImage)
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        noDataImage.translatesAutoresizingMaskIntoConstraints = false
        noDataLabel.text = noDataLabelText
        noDataLabel.font = UIFont.systemFont(ofSize: 12)
        noDataLabel.textColor = UIColor.ypBlack
        noDataLabel.textAlignment = .center
        noDataImage.image = UIImage(named: "NoDataStatistics")
        NSLayoutConstraint.activate([
            noDataImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 375),
            noDataImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataImage.heightAnchor.constraint(equalToConstant: 80),
            noDataImage.widthAnchor.constraint(equalToConstant: 80),
            noDataLabel.topAnchor.constraint(equalTo: noDataImage.bottomAnchor, constant: 8),
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func setupCountCompletedTrackers() {
        [borderImage, emptyImage, countCompletedTrackersLabel, completedTrackersLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        let massage = String.localizedStringWithFormat (format, countCompletedDay)
        countCompletedTrackersLabel.text = "\(countCompletedDay)"
        countCompletedTrackersLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        countCompletedTrackersLabel.textColor = UIColor.ypBlack
        completedTrackersLabel.text = massage
        completedTrackersLabel.font = UIFont.systemFont(ofSize: 12)
        completedTrackersLabel.textColor = UIColor.ypBlack
        borderImage.layer.cornerRadius = 16
        borderImage.layer.masksToBounds = true
        borderImage.frame = CGRect(origin: .zero, size: CGSize(width: 363, height: 92))
        borderImage.applyGradient()
        emptyImage.backgroundColor = UIColor.white
        emptyImage.layer.cornerRadius = 16
        emptyImage.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            countCompletedTrackersLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 422),
            countCompletedTrackersLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28),
            countCompletedTrackersLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28),
            completedTrackersLabel.topAnchor.constraint(equalTo: countCompletedTrackersLabel.bottomAnchor, constant: 7),
            completedTrackersLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28),
            completedTrackersLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28),
            borderImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 410),
            borderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            borderImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            borderImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            borderImage.heightAnchor.constraint(equalToConstant: 90),
            emptyImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 411),
            emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 17),
            emptyImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -17),
            emptyImage.heightAnchor.constraint(equalToConstant: 88)
        ])
    }
}

// MARK: - UIView
extension UIView {
    func applyGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.gradient1.cgColor, UIColor.gradient2.cgColor, UIColor.gradient3.cgColor]
        gradient.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
        self.layer.insertSublayer(gradient, at: 0)
        gradient.frame = self.frame
    }
}
