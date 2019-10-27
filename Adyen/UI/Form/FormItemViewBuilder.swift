//
//  FormItemViewBuilder.swift
//  Adyen
//
//  Created by mohamed mohamed El Dehairy on 10/26/19.
//  Copyright © 2019 Adyen. All rights reserved.
//

import Foundation

public protocol FormItemViewBuilder {
    func build<T: FormItem>(for item: T, delegate: FormItemViewDelegate?) -> FormItemView<T>
}

open class DefaultFormItemViewBuilder: FormItemViewBuilder {
    public func build<T>(for item: T, delegate: FormItemViewDelegate?) -> FormItemView<T> where T : FormItem {
        let itemViewType = getItemViewType(for: item)
        let itemView = itemViewType.init(item: item)
        itemView.delegate = delegate
        itemView.childItemViews.forEach { $0.delegate = delegate }
        
        return itemView
    }
    
    private func getItemViewType<T: FormItem>(for item: T) -> FormItemView<T>.Type {
        let itemViewType: Any
        
        switch item {
        case is FormHeaderItem:
            itemViewType = FormHeaderItemView.self
        case is FormFooterItem:
            itemViewType = FormFooterItemView.self
        case is FormTextItem:
            itemViewType = FormTextItemView.self
        case is FormSwitchItem:
            itemViewType = FormSwitchItemView.self
        case is FormSplitTextItem:
            itemViewType = FormSplitTextItemView.self
        default:
            fatalError("No view type known for given item.")
        }
        
        // swiftlint:disable:next force_cast
        return itemViewType as! FormItemView<T>.Type
    }
}
