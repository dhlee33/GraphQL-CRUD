//
//  ProductUseCase.swift
//  GraphQLCrud
//
//  Created by 이동현 on 2019/10/06.
//  Copyright © 2019 이동현. All rights reserved.
//

import RxSwift
import Apollo

protocol ProductUseCase {
    func fetchProductList() -> Observable<[Product]>
    func createProduct(supplierId: String, nameKo: String, price: Int) -> Single<String>
    func fetchProduct(id: String) -> Observable<ProductDetail>
    func deleteProduct(id: String) -> Single<String>
    func updateProduct(id: String, nameKo: String, nameEn: String, price: Int, descriptionKo: String, descriptionEn: String) -> Single<ProductUpdateDetail>
}

final class DefaultProductUseCase: ProductUseCase {
    let apollo: ApolloClient

    init (apollo: ApolloClient) {
        self.apollo = apollo
    }

    func fetchProductList() -> Observable<[Product]> {
        return apollo.rx.fetch(query: ProductListQuery(id_list: nil))
            .map { $0.productList.itemList }
    }
    
    func createProduct(supplierId: String, nameKo: String, price: Int) -> Single<String> {
        let input = CreateProductInput(supplierId: supplierId, nameKo: nameKo, price: price)
        return apollo.rx.perform(mutation: CreateProductMutation(input: input)).map { $0.createProduct.id }
    }
    
    func fetchProduct(id: String) -> Observable<ProductDetail> {
        return apollo.rx.fetch(query: ProductQuery(id: id)).flatMap { Observable.from(optional: $0.product) }
    }
    
    func deleteProduct(id: String) -> Single<String> {
        let input = DeleteProductInput(id: id)
        return apollo.rx.perform(mutation: DeleteProductMutation(input: input)).map {
            $0.deleteProduct.id
        }
    }
    
    func updateProduct(id: String, nameKo: String, nameEn: String, price: Int, descriptionKo: String, descriptionEn: String) -> Single<ProductUpdateDetail> {
        let input = UpdateProductInput(id: id, nameKo: nameKo, nameEn: nameEn, descriptionKo: descriptionKo, descriptionEn: descriptionEn, price: price)
        return apollo.rx.perform(mutation: UpdateProductMutation(input: input))
            .map { $0.updateProduct }
    }
}


