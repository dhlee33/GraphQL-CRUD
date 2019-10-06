//
//  ProductDetailViewReactor.swift
//  GraphQLCrud
//
//  Created by 이동현 on 2019/10/06.
//  Copyright © 2019 이동현. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxFlow
import RxCocoa

class ProductDetailViewReactor: Reactor, Stepper {
    var steps = PublishRelay<Step>()
    var initialState: State
    var disposeBag = DisposeBag()
    let productUseCase: ProductUseCase
    
    init(productUseCase: ProductUseCase, product: Product) {
        self.productUseCase = productUseCase
        self.initialState = State(id: product.id, nameKo: product.nameKo, nameEn: product.nameEn, supplier: product.supplier?.name, price: product.price)
    }
    enum Action {
        case fetchProduct
        case updateProduct
        case updateNameKo(String?)
        case updateNameEn(String?)
        case updateDescriptionKo(String?)
        case updateDescriptionEn(String?)
        case updatePrice(String?)
    }
    
    enum Mutation {
        case updateProduct(ProductDetail)
        case saveUpdateProductResult(ProductUpdateDetail)
        case updateNameKo(String?)
        case updateNameEn(String?)
        case updateDescriptionKo(String?)
        case updateDescriptionEn(String?)
        case updatePrice(String?)
    }
    
    struct State {
        var id: String
        var nameKo: String?
        var nameEn: String?
        var descriptionKo: String?
        var descriptionEn: String?
        var supplier: String?
        var price: Int?
        var suppliers: [Supplier] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchProduct:
            return productUseCase.fetchProduct(id: currentState.id).map { .updateProduct($0) }
        case .updateProduct:
            return productUseCase.updateProduct(id: currentState.id, nameKo: currentState.nameKo ?? "", nameEn: currentState.nameEn ?? "", price: currentState.price ?? 0, descriptionKo: currentState.descriptionKo ?? "", descriptionEn: currentState.descriptionEn ?? "").map { .saveUpdateProductResult($0) }.asObservable()
        case let .updateNameKo(val):
            return .just(.updateNameKo(val))
        case let .updateNameEn(val):
            return .just(.updateNameEn(val))
        case let .updateDescriptionKo(val):
            return .just(.updateDescriptionKo(val))
        case let .updateDescriptionEn(val):
            return .just(.updateDescriptionEn(val))
        case let .updatePrice(val):
            return .just(.updatePrice(val))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .updateProduct(detail):
            newState.nameKo = detail.nameKo
            newState.nameEn = detail.nameEn
            newState.descriptionEn = detail.descriptionEn
            newState.descriptionKo = detail.descriptionKo
            newState.supplier = detail.supplier?.name
            newState.price = detail.price
        case let .saveUpdateProductResult(detail):
            newState.nameKo = detail.nameKo
            newState.nameEn = detail.nameEn
            newState.descriptionEn = detail.descriptionEn
            newState.descriptionKo = detail.descriptionKo
            newState.supplier = detail.supplier?.name
            newState.price = detail.price
        case let .updateNameKo(val):
            newState.nameKo = val
        case let .updateNameEn(val):
            newState.nameEn = val
        case let .updateDescriptionKo(val):
            newState.descriptionKo = val
        case let .updateDescriptionEn(val):
            newState.descriptionEn = val
        case let .updatePrice(val):
            newState.price = Int(val ?? "0")
        }
        return newState
    }
    
    func deleteProduct() {
        productUseCase.deleteProduct(id: currentState.id)
            .map { _ in ProductStep.returnToList }
            .asObservable().bind(to: steps)
        .disposed(by: disposeBag)
    }
}

