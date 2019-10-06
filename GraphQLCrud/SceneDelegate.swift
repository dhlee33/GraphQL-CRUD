//
//  SceneDelegate.swift
//  GraphQLCrud
//
//  Created by 이동현 on 2019/10/05.
//  Copyright © 2019 이동현. All rights reserved.
//

import UIKit
import RxSwift
import RxFlow
import Swinject
import SwinjectAutoregistration
import Apollo

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator = FlowCoordinator()
    var disposeBag = DisposeBag()
    lazy var apolloClient: ApolloClient = {
        let transport = HTTPNetworkTransport(
          url: URL(string: "http://test.recruit.croquis.com:28500/")!,
          delegate: self
        )
        return ApolloClient(networkTransport: transport)
    }()
    
    lazy var container: Container = {
        let container = Container()
        container.register(ApolloClient.self) { _ in
            return self.apolloClient
        }
        container.autoregister(ProductUseCase.self, initializer: DefaultProductUseCase.init)
        container.autoregister(SupplierUseCase.self, initializer: DefaultSupplierUseCase.init)
        container.autoregister(ProductListViewReactor.self, initializer: ProductListViewReactor.init)
        container.autoregister(CreateProductViewReactor.self, initializer: CreateProductViewReactor.init)
        container.register(ProductDetailViewReactor.self) { (r, product: Product) in
            return ProductDetailViewReactor(productUseCase: r~>, product: product)
        }
        return container
    } ()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let window = self.window else { return }

        self.coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            print ("will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: disposeBag)

        self.coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print ("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: disposeBag)

        let productFlow = ProductFlow(container: container)

        Flows.whenReady(flow1: productFlow) { root in
            window.rootViewController = root
            window.makeKeyAndVisible()
        }

        self.coordinator.coordinate(flow: productFlow, with: OneStepper(withSingleStep: ProductStep.showProductList))
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


extension SceneDelegate: HTTPNetworkTransportPreflightDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
        true
    }
    
    
    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          willSend request: inout URLRequest) {
        var headers = request.allHTTPHeaderFields ?? [String: String]()
        headers["Croquis-UUID"] = "00000000-0000-0000-0000-012000000000"
        request.allHTTPHeaderFields = headers
    }
}

