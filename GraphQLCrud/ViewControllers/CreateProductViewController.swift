//
//  CreateProductViewController.swift
//  GraphQLCrud
//
//  Created by 이동현 on 2019/10/06.
//  Copyright © 2019 이동현. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

class CreateProductViewController: BaseViewController, StoryboardView {
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPrice: UITextField!
    @IBOutlet weak var textFieldSupplier: UITextField!
    @IBOutlet weak var buttonCreate: UIBarButtonItem!
    typealias Reactor = CreateProductViewReactor
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldSupplier.inputView = pickerView
        textFieldPrice.keyboardType = .numberPad
        reactor?.action.onNext(.fetchSuppliers)
    }
    
    func bind(reactor: Reactor) {
        textFieldName.rx.text
            .orEmpty
            .map { Reactor.Action.updateName($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        textFieldPrice.rx.text
            .orEmpty
            .map { Reactor.Action.updatePrice(Int($0) ?? 0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.suppliers }
            .bind(to: pickerView.rx.itemTitles) { _, supplier  in
                return supplier.name
        }.disposed(by: disposeBag)
        
        pickerView.rx.itemSelected.subscribe(onNext: { [weak self] row, _ in
            self?.textFieldSupplier.text = reactor.currentState.suppliers[row].name
            reactor.action.onNext(.updateSupplier(row))
            }).disposed(by: disposeBag)
        
        buttonCreate.rx.tap.subscribe(onNext: { _ in
            reactor.createProduct()
            }).disposed(by: disposeBag)
    }
}
