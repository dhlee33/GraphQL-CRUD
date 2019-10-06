//
//  ViewController.swift
//  GraphQLCrud
//
//  Created by 이동현 on 2019/10/05.
//  Copyright © 2019 이동현. All rights reserved.
//

import UIKit
import Apollo
import ReactorKit
import RxSwift
import RxFlow

class ProductListViewController: BaseViewController, StoryboardView {
    var reactor: ProductListViewReactor?
    typealias Reactor = ProductListViewReactor
    
    @IBOutlet weak var buttonCreate: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reactor?.action.onNext(.fetchProductList)
    }


    
    func bind(reactor: ProductListViewReactor) {
        reactor.state.map { $0.productList }
            .bind(to: tableView.rx.items) { tableView, indexPath, product in
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
                let reactor = ProductCellReactor(product: product)
                cell.reactor = reactor
                return cell
        }
        .disposed(by: disposeBag)
        
        buttonCreate.rx.tap.subscribe(onNext: { _ in
            reactor.createProduct()
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { index in
            reactor.showDetail(index.row)
        }).disposed(by: disposeBag)
    }
}
