//
//  ProductCell.swift
//  GraphQLCrud
//
//  Created by 이동현 on 2019/10/06.
//  Copyright © 2019 이동현. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

class ProductCell: UITableViewCell, StoryboardView {
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var labelId: UILabel!
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelSupplier: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    typealias Reactor = ProductCellReactor
    
    func bind(reactor: Reactor) {
        labelId.text = reactor.currentState.id
        labelPrice.text = reactor.currentState.price
        labelSupplier.text = reactor.currentState.supplier
        labelProductName.text = reactor.currentState.title
    }
}
