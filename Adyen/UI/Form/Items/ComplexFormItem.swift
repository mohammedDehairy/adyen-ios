//
//  ComplexFormItem.swift
//  Adyen
//
//  Created by mohamed mohamed El Dehairy on 10/26/19.
//  Copyright © 2019 Adyen. All rights reserved.
//

import Foundation

protocol ComplexFormItem: FormItem {
    var subItems: [FormItem] { get }
    func flatSubItems() -> [FormItem]
}

extension ComplexFormItem {
    func flatSubItems() -> [FormItem] {
        return subItems.flatMap { ($0 as? ComplexFormItem)?.flatSubItems() ?? [$0] }
    }
}
