//
//  ProductCellReactor.swift
//  GraphQLCrud
//
//  Created by 이동현 on 2019/10/06.
//  Copyright © 2019 이동현. All rights reserved.
//

import ReactorKit

final class ProductCellReactor: Reactor {
    typealias Action = NoAction
    struct State {
        var id: String
        var title: String
        var price: String
        var supplier: String?
    }
    
    let initialState: State
    
    init(product: Product) {
        var title = "이름 없음"
        if let nameKo = product.nameKo, !nameKo.isEmpty {
            title = nameKo
        }
        if let nameEn = product.nameEn, !nameEn.isEmpty {
            title +=  " (\(nameEn))"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "KRW"
        let price = formatter.string(from: NSNumber(value: product.price ?? 0)) ?? "0"
        self.initialState = State(id: product.id, title: title, price: price, supplier: product.supplier?.name)
    }
}
