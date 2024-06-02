import Foundation
import UIKit


protocol NewHabitShedulerViewControllerDelegate: AnyObject {
    func updateSheduler(sheduler: [WeekDay])
    func updateTable()
}

final class NewHabitShedulerViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: NewHabitShedulerViewControllerDelegate?
    var sheduler = [WeekDay]()
    
    // MARK: - Private Properties
    private let ready = NSLocalizedString("ready", comment: "")
    private let weekDayForView = [NSLocalizedString("monday", comment: ""),
                                  NSLocalizedString("tuesday", comment: ""),
                                  NSLocalizedString("wednesday", comment: ""),
                                  NSLocalizedString("thursday", comment: ""),
                                  NSLocalizedString("friday", comment: ""),
                                  NSLocalizedString("saturday", comment: ""),
                                  NSLocalizedString("sunday", comment: "")]
    private let weekDay = [WeekDay.monday, WeekDay.tuesday, WeekDay.wednesday, WeekDay.thursday, WeekDay.friday, WeekDay.saturday, WeekDay.sunday]
    private let readyButton = UIButton()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(NewHabitShedulerTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupButton()
        setupTable()
    }
    
    // MARK: - IB Actions
    @objc private func onClickReadyButton() {
        delegate?.updateSheduler(sheduler: sheduler)
        delegate?.updateTable()
        self.dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    private func setupTable() {
        view.addSubview(tableView)
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupButton() {
        view.addSubview(readyButton)
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.setTitle(ready, for: .normal)
        readyButton.setTitleColor(UIColor.white, for: .normal)
        readyButton.backgroundColor = UIColor.black
        readyButton.layer.cornerRadius = 16
        readyButton.layer.masksToBounds = true
        readyButton.addTarget(self,
                              action: #selector(onClickReadyButton),
                              for: .touchUpInside)
        NSLayoutConstraint.activate([
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NewHabitShedulerViewController: UITableViewDelegate, UITableViewDataSource{
    
    @objc func switchChanged(_ sender : UISwitch!){
        if sheduler.contains(weekDay[sender.tag]) {
            sheduler.remove(at: sheduler.firstIndex(of: weekDay[sender.tag]) ?? 0)
        } else {
            sheduler.append(weekDay[sender.tag])
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDayForView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let cell = cell as? NewHabitShedulerTableViewCell else {
            return NewHabitShedulerTableViewCell()
        }
        cell.buttonLabel.text = weekDayForView[indexPath.item]
        cell.switchView.tag = indexPath.row
        cell.switchView.addTarget(self,
                                  action: #selector(self.switchChanged(_:)),
                                  for: .valueChanged)
        if sheduler.contains(weekDay[indexPath.item]) {
            cell.switchView.isOn = true
        }
        if indexPath.item == weekDayForView.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
