//
//  ProductDetailViewController.swift
//  GraphQLCrud
//
//  Created by 이동현 on 2019/10/06.
//  Copyright © 2019 이동현. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

class ProductDetailViewController: BaseViewController, StoryboardView {
    typealias Reactor = ProductDetailViewReactor
    @IBOutlet weak var buttonSave: UIBarButtonItem!
    @IBOutlet weak var buttonDelete: UIBarButtonItem!
    @IBOutlet weak var textFieldNameKo: UITextField!
    @IBOutlet weak var textFieldNameEn: UITextField!
    @IBOutlet weak var textFieldDescKo: UITextField!
    @IBOutlet weak var textFieldDescEn: UITextField!
    @IBOutlet weak var labelSupplier: UILabel!
    @IBOutlet weak var textFieldPrice: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.fetchProduct)
    }
    
    func bind(reactor: ProductDetailViewReactor) {
        reactor.state.map { $0.nameKo }
        .distinctUntilChanged()
            .bind(to: textFieldNameKo.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.nameEn }
            .distinctUntilChanged()
            .bind(to: textFieldNameEn.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.descriptionKo }
            .distinctUntilChanged()
            .bind(to: textFieldDescKo.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.descriptionEn }
            .distinctUntilChanged()
            .bind(to: textFieldDescEn.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.supplier }
            .distinctUntilChanged()
            .bind(to: labelSupplier.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { String($0.price ?? 0) }
            .distinctUntilChanged()
            .bind(to: textFieldPrice.rx.text)
        .disposed(by: disposeBag)
        
        textFieldNameKo.rx.text.map { Reactor.Action.updateNameKo($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        textFieldNameEn.rx.text.map { Reactor.Action.updateNameEn($0) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        textFieldDescKo.rx.text.map { Reactor.Action.updateDescriptionKo($0) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        textFieldDescEn.rx.text.map { Reactor.Action.updateDescriptionEn($0) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        textFieldPrice.rx.text.map { Reactor.Action.updatePrice($0) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        buttonDelete.rx.tap.subscribe(onNext: { _ in
            reactor.deleteProduct()
        }).disposed(by: disposeBag)
        
        buttonSave.rx.tap.map { _ in Reactor.Action.updateProduct }
            .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
}
