//
//  ProductStep.swift
//  GraphQLCrud
//
//  Created by 이동현 on 2019/10/06.
//  Copyright © 2019 이동현. All rights reserved.
//

import RxFlow

enum ProductStep: Step {
    case showProductList
    case createProduct
    case returnToList
    case productDetail(Product)
}

