//
//  ProductListViewReactor.swift
//  GraphQLCrud
//
//  Created by 이동현 on 2019/10/06.
//  Copyright © 2019 이동현. All rights reserved.
//

import ReactorKit
import RxSwift
import RxFlow
import RxCocoa

final class ProductListViewReactor: Reactor, Stepper {
    var steps = PublishRelay<Step>()
    var initialState: State
    let productUseCase: ProductUseCase
    init(productUseCase: ProductUseCase) {
        self.productUseCase = productUseCase
        self.initialState = State(productList: [])
    }
    
    struct State {
        var productList: [Product]
    }
    
    enum Action {
        case fetchProductList
    }
    
    enum Mutation {
        case setProductList([Product])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchProductList:
            return productUseCase.fetchProductList()
                .map { .setProductList($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setProductList(productList):
            newState.productList = productList
        }
        return newState
    }
    
    func createProduct() {
        steps.accept(ProductStep.createProduct)
    }
    
    func showDetail(_ index: Int) {
        steps.accept(ProductStep.productDetail(currentState.productList[index]))
    }
}

