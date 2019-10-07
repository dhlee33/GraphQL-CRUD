# GraqhQL-CRUD

CRUD example using GraphQL

## Features
- Using Apollo 
- Using ReactorKit
- Clean Architecture and DI with Swinject
- Navigation with RxFlow

## Architecture
- Uni-directional hierarchy
- ViewController -> Reactor -> UseCases 

### View and Reactor
- MVVM with ReactorKit

### Apollo
- GraphQL with Apollo auto-generated api and RxSwift wrapped client
```swift
func fetch<Query: GraphQLQuery>(
query: Query,
cachePolicy: CachePolicy = .returnCacheDataAndFetch,
queue: DispatchQueue = DispatchQueue.main) -> Observable<Query.Data>
...
```
- Usage
```swift
apollo.rx.fetch(query: ProductListQuery(id_list: nil))
...
```

### Container
- Handle dependency injection using Swinject
```swift
...
container.autoregister(ProductUseCase.self, initializer: DefaultProductUseCase.init)
container.autoregister(ProductListViewReactor.self, initializer: ProductListViewReactor.init)
...
```
- Usage
```swift
container.resolve(ProductListViewReactor.self)
```

### UseCases
- UseCases handle usecases of entity(model) using service layer
```swift
final class DefaultProductUseCase: ProductUseCase {
    ...
    func fetchProductList() -> Observable<[Product]> {
        return apollo.rx.fetch(query: ProductListQuery(id_list: nil))
            .map { $0.productList.itemList }
    }
}
```









