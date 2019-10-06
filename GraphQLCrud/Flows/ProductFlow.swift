//
//  ProductFlow.swift
//  GraphQLCrud
//
//  Created by 이동현 on 2019/10/06.
//  Copyright © 2019 이동현. All rights reserved.
//

import RxFlow
import Swinject
import Apollo

class ProductFlow: Flow {
    let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let vc = UINavigationController()
        return vc
    }()

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ProductStep else { return .none }
        switch step {
        case .showProductList:
            return showProductList()
        case .createProduct:
            return createProduct()
        case .returnToList:
            rootViewController.popViewController(animated: true)
            return .none
        case let .productDetail(detail):
            return productDetail(detail)
        }
    }
    
    private func showProductList() -> FlowContributors {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
        guard let reactor = container.resolve(ProductListViewReactor.self) else {
            return .none
        }
        vc.reactor = reactor
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }

    private func createProduct() -> FlowContributors {
        let createVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateProductViewController") as! CreateProductViewController
        guard let reactor = container.resolve(CreateProductViewReactor.self) else {
            return .none
        }
        createVC.reactor = reactor
        rootViewController.pushViewController(createVC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: createVC, withNextStepper: reactor))
    }
    
    private func productDetail(_ product: Product) -> FlowContributors {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        guard let reactor = container.resolve(ProductDetailViewReactor.self, argument: product) else {
            return .none
        }
        vc.reactor = reactor
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
}
