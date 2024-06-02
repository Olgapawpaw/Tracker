import Foundation


protocol NewCategoryModelDelegate: AnyObject {
    func updateSelectedCategory(selectedCategory: String)
    func updateTable()
}

final class NewCategoryModel {
    // MARK: - Public Properties
    weak var delegate: NewCategoryModelDelegate?
    var selectedCategory = String()
    var category: [String] {
        getCategory()
    }
    var isEmpty: Bool {
        trackerCategoryStore.isEmptyCategory()
    }
    
    // MARK: - Private Properties
    private let trackerCategoryStore = TrackerCategoryStore()
    
    // MARK: - Public Methods
    func getCategory() -> [String] {
        let category = trackerCategoryStore.getCategoryList()
        return category
    }
    
    func updateSelectedCategory(name: String){
        delegate?.updateSelectedCategory(selectedCategory: name)
        delegate?.updateTable()
    }
}
