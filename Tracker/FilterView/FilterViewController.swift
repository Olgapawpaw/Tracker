import Foundation
import UIKit


protocol FilterViewControllerDelegate: AnyObject {
    func updateSelectedFilter(selectedFilter: String)
    func changeDate()
    func selectedOnlyCompleteTrackerFilter(isShowOnlyCompletedTracker: Bool)
    func selectedOnlyUnCompleteTrackerFilter(isShowOnlyUnCompletedTracker: Bool)
    func update()
}

final class FilterViewController: UIViewController {
    // MARK: - Public Methods
    weak var delegate: FilterViewControllerDelegate?
    
    // MARK: - Private Properties
    private let filters = [NSLocalizedString("filter.allTrackers", comment: ""),
                           NSLocalizedString("filter.todayTrackers", comment: ""),
                           NSLocalizedString("filter.completed", comment: ""),
                           NSLocalizedString("filter.unCompleted", comment: "")]
    private var selectedFilter = String()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(FilterTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    // MARK: - Init Methods
    init(selectedFilter: String) {
        self.selectedFilter = selectedFilter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.viewBackgroundColor
        setupTableView()
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FilterViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let cell = cell as? FilterTableViewCell else {
            return FilterTableViewCell()
        }
        cell.updateTitleLabel(text: filters[indexPath.item])
        if selectedFilter == filters[indexPath.item] {
            cell.accessoryType = .checkmark
        }
        if indexPath.item == filters.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        if filters.count - 1 == indexPath.item {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedFilter != filters[indexPath.item] {
            switch filters[indexPath.item] {
            case NSLocalizedString("filter.allTrackers", comment: ""):
                delegate?.selectedOnlyCompleteTrackerFilter(isShowOnlyCompletedTracker: false)
                delegate?.selectedOnlyUnCompleteTrackerFilter(isShowOnlyUnCompletedTracker: false)
            case NSLocalizedString("filter.todayTrackers", comment: ""):
                delegate?.changeDate()
                delegate?.selectedOnlyCompleteTrackerFilter(isShowOnlyCompletedTracker: false)
                delegate?.selectedOnlyUnCompleteTrackerFilter(isShowOnlyUnCompletedTracker: false)
            case NSLocalizedString("filter.completed", comment: ""):
                delegate?.selectedOnlyCompleteTrackerFilter(isShowOnlyCompletedTracker: true)
                delegate?.selectedOnlyUnCompleteTrackerFilter(isShowOnlyUnCompletedTracker: false)
            case NSLocalizedString("filter.unCompleted", comment: ""):
                delegate?.selectedOnlyUnCompleteTrackerFilter(isShowOnlyUnCompletedTracker: true)
                delegate?.selectedOnlyCompleteTrackerFilter(isShowOnlyCompletedTracker: false)
            default:
                break
            }
            selectedFilter = filters[indexPath.item]
            delegate?.updateSelectedFilter(selectedFilter: selectedFilter)
            tableView.reloadData()
            delegate?.update()
            self.dismiss(animated: true)
        }
    }
}
