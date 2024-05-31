import Foundation


typealias Binding<T> = (T) -> Void

final class NewCategoryViewModel {
    // MARK: - Public Properties
    var category: Binding<[String]>?
    var isEmpty: Binding<Bool>?
    var selectedCategory: Binding<String>?
    
    // MARK: - Private Properties
    private let model: NewCategoryModel
    
    // MARK: - Initializers
    init(for model: NewCategoryModel) {
        self.model = model
    }
    
    // MARK: - Public Methods
    func getData() {
        category?(model.category)
        selectedCategory?(model.selectedCategory)
        isEmpty?(model.isEmpty)
    }
    
    func enterSelectedCategory(name: String) {
        selectedCategory?(name)
        model.updateSelectedCategory(name: name)
    }
}
