//
//  SupplierUseCase.swift
//  GraphQLCrud
//
//  Created by 이동현 on 2019/10/06.
//  Copyright © 2019 이동현. All rights reserved.
//

import RxSwift
import Apollo

protocol SupplierUseCase {
    func fetchSupplierList() -> Observable<[Supplier]>
}

final class DefaultSupplierUseCase: SupplierUseCase {
    let apollo: ApolloClient

    init (apollo: ApolloClient) {
        self.apollo = apollo
    }

    func fetchSupplierList() -> Observable<[Supplier]> {
        return apollo.rx.fetch(query: SupplierListQuery(id_list: nil))
            .map { $0.supplierList.itemList }
    }
}
