//
//  CreateProductViewReactor.swift
//  GraphQLCrud
//
//  Created by 이동현 on 2019/10/06.
//  Copyright © 2019 이동현. All rights reserved.
//

import RxSwift
import ReactorKit
import RxFlow
import RxCocoa

final class CreateProductViewReactor: Reactor, Stepper {
    var steps = PublishRelay<Step>()
    var disposeBag = DisposeBag()
    var initialState: CreateProductViewReactor.State
    let productUseCase: ProductUseCase
    let supplierUseCase: SupplierUseCase
    init(productUseCase: ProductUseCase, supplierUseCase: SupplierUseCase) {
        self.productUseCase = productUseCase
        self.supplierUseCase = supplierUseCase
        self.initialState = State(suppliers: [])
    }
    
    enum Action {
        case updateName(String)
        case updatePrice(Int)
        case updateSupplier(Int)
        case fetchSuppliers
    }
    
    enum Mutation {
        case setSuppliers([Supplier])
        case updateName(String)
        case updatePrice(Int)
        case updateSupplier(String)
    }
    
    struct State {
        var name: String?
        var price: Int?
        var suppliers: [Supplier]
        var supplier: String?
        var createSuccess = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchSuppliers:
            return supplierUseCase.fetchSupplierList()
                .map { .setSuppliers($0) }
        case let .updateName(name):
            return .just(.updateName(name))
        case let .updatePrice(price):
            return .just(.updatePrice(price))
        case let .updateSupplier(index):
            return .just(.updateSupplier(currentState.suppliers[index].id))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSuppliers(suppliers):
            newState.suppliers = suppliers
        case let .updateName(name):
            newState.name = name
        case let .updatePrice(price):
            newState.price = price
        case let .updateSupplier(id):
            newState.supplier = id
        }
        return newState
    }
    
    func createProduct() {
        guard let id = currentState.supplier, !id.isEmpty, let name = currentState.name, !name.isEmpty, let price = currentState.price else {
            return
        }
        productUseCase.createProduct(supplierId: id, nameKo: name, price: price)
            .map { _ in ProductStep.returnToList }
            .asObservable().bind(to: steps)
        .disposed(by: disposeBag)
    }
}

