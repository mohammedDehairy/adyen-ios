//
// Copyright (c) 2019 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Foundation

/// Manages the form items and their views.
internal final class FormViewItemManager {
    
    /// The delegate of the item views created by the manager.
    internal private(set) weak var itemViewDelegate: FormItemViewDelegate?
    
    internal let itemViewBuilder: FormItemViewBuilder
    
    /// Initializes the item manager.
    ///
    /// - Parameter itemViewDelegate: The delegate of the item views created by the manager.
    internal init(itemViewDelegate: FormItemViewDelegate, itemViewBuilder: FormItemViewBuilder) {
        self.itemViewDelegate = itemViewDelegate
        self.itemViewBuilder = itemViewBuilder
    }
    
    // MARK: - Items
    
    /// The items managed by the item manager.
    internal private(set) var items = [FormItem]()
    
    /// Appends an item to the list of managed items.
    ///
    /// - Parameters:
    ///   - item: The item to append.
    ///   - itemViewType: Optionally, the item view type to use for this item.
    ///                   When none is specified, the default will be used.
    internal func append<T: FormItem>(_ item: T) {
        items.append(item)
        
        let itemView = newItemView(for: item)
        itemViews.append(itemView)
        allItemViews.append(itemView)
        allItemViews.append(contentsOf: itemView.childItemViews)
    }
    
    private func index(of item: FormItem) -> Int {
        let index = items.firstIndex {
            $0 === item
        }
        
        if let index = index {
            return index
        } else {
            fatalError("Provided item is not managed by receiver.")
        }
    }
    
    // MARK: - Item Views
    
    /// The item views managed by the item manager.
    /// Due to a compiler bug, we can't set this to be of type [AnyFormItem].
    internal private(set) var itemViews = [UIView]()
    
    /// The item views managed by the item manager, including nested item views.
    private var allItemViews = [AnyFormItemView]()
    
    /// Returns the item view for the given item.
    ///
    /// - Parameter item: The item to retrieve the item view for.
    /// - Returns: The item view for the given item.
    internal func itemView<T: FormItem>(for item: T) -> FormItemView<T> {
        return itemViews[index(of: item)] as! FormItemView<T> // swiftlint:disable:this force_cast
    }
    
    /// Returns all the item views of the requested type.
    /// This will also search for nested item views.
    ///
    /// - Parameter type: The type of item views to return.
    /// - Returns: All item views of the requested type.
    internal func itemViews<T: FormItem, U: FormItemView<T>>(ofType type: U.Type) -> [U] {
        return allItemViews.compactMap { $0 as? U }
    }
    
    private func newItemView<T: FormItem>(for item: T) -> FormItemView<T> {
        return itemViewBuilder.build(for: item, delegate: itemViewDelegate)
    }
    
}
