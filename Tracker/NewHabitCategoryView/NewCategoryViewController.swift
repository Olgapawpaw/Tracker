import Foundation
import UIKit


final class NewCategoryViewController: UIViewController {
    // MARK: - Private Properties
    private let newCategoryTitle = NSLocalizedString("newCategory.title", comment: "")
    private let addCategory = NSLocalizedString("addCategory", comment: "")
    private let emptyCategory = NSLocalizedString("emptyCategory", comment: "")
    private var viewModel: NewCategoryViewModel
    private var selectedCategory = String()
    private var category = [String]()
    private let noCategoryImage = UIImageView()
    private let noCategoryLabel = UILabel()
    private let addButton = UIButton()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }()
    private lazy var contentSize: CGSize = {
        if category.count > 7 {
            let height = (category.count - 7) * 75
            return CGSize(width: view.frame.width, height: view.frame.height + CGFloat(height))
        } else {
            return CGSize(width: view.frame.width, height: view.frame.height)
        }
    }()
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.frame.size = contentSize
        return contentView
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(NewCategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    // MARK: - Initializers
    init(viewModel: NewCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        viewModel.getData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.viewBackgroundColor
        setupScrollView()
        setupTableView()
        setupButton()
        setupNoCategory()
    }
    
    // MARK: - IB Actions
    @objc private func onClick() {
        let viewController = CreateNewCategoryViewController()
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.viewControllers.first?.navigationItem.title = newCategoryTitle
        self.navigationController?.present(navigationController, animated: true)
    }
    
    // MARK: - Private Methods
    private func bind() {
        viewModel.category = { [weak self] category in
            self?.category = category
        }
        
        viewModel.selectedCategory = { [weak self] selectedCategory in
            self?.selectedCategory = selectedCategory
        }
        
        viewModel.isEmpty = { [weak self] isEmpty in
            self?.showNoCategory(isEmpty: isEmpty)
        }
    }
    
    private func showNoCategory(isEmpty: Bool) {
        if isEmpty {
            setupNoCategory()
        } else {
            hideNoTracker()
        }
    }
    
    private func hideNoTracker() {
        noCategoryImage.removeFromSuperview()
        noCategoryLabel.removeFromSuperview()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func setupButton() {
        contentView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle(addCategory, for: .normal)
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.layer.cornerRadius = 16
        addButton.layer.masksToBounds = true
        addButton.backgroundColor = UIColor.black
        addButton.addTarget(self,
                            action: #selector(onClick),
                            for: .touchUpInside)
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupNoCategory() {
        contentView.addSubview(noCategoryImage)
        contentView.addSubview(noCategoryLabel)
        noCategoryImage.translatesAutoresizingMaskIntoConstraints = false
        noCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        noCategoryImage.image = UIImage(named: "MainViewError")
        noCategoryLabel.text = emptyCategory
        noCategoryLabel.textAlignment = .center
        noCategoryLabel.numberOfLines = 2
        noCategoryLabel.textColor = UIColor.ypBlack
        noCategoryLabel.font = UIFont.systemFont(ofSize: 12)
        NSLayoutConstraint.activate([
            noCategoryImage.heightAnchor.constraint(equalToConstant: 80),
            noCategoryImage.widthAnchor.constraint(equalToConstant: 80),
            noCategoryImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 232),
            noCategoryImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            noCategoryLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            noCategoryLabel.topAnchor.constraint(equalTo: noCategoryImage.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupTableView() {
        contentView.addSubview(tableView)
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NewCategoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let cell = cell as? NewCategoryTableViewCell else {
            return NewCategoryTableViewCell()
        }
        cell.updateTitleLabel(text: category[indexPath.item])
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        if category.count - 1 == indexPath.item {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        if selectedCategory == category[indexPath.item] {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedCategory != category[indexPath.item] {
            viewModel.enterSelectedCategory(name: category[indexPath.item])
            tableView.reloadData()
            self.dismiss(animated: true)
        }
    }
}

// MARK: - CreateNewCategoryViewControllerDelegate
extension NewCategoryViewController: CreateNewCategoryViewControllerDelegate {
    func updateData() {
        bind()
        viewModel.getData()
        tableView.reloadData()
        showNoCategory(isEmpty: false)
    }
}
