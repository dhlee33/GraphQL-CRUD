//
//  RxApollo.swift
//  GraphQLCrud
//
//  Created by 이동현 on 2019/10/05.
//  Copyright © 2019 이동현. All rights reserved.
//

import RxSwift
import Apollo

class RxApollo {
    let client: ApolloClient

    init(client: ApolloClient) {
        self.client = client
    }

    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .returnCacheDataAndFetch,
        queue: DispatchQueue = DispatchQueue.main) -> Observable<Query.Data> {
        return Observable.create { observer in
            let cancellable = self.client.fetch(query: query, cachePolicy: cachePolicy, queue: queue) { result in
                switch result {
                case let .success(data):
                    if let data = data.data {
                        observer.onNext(data)
                    }
                case let .failure(error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                cancellable.cancel()
            }
        }
    }

    func watch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .returnCacheDataAndFetch,
        queue: DispatchQueue = DispatchQueue.main) -> Observable<Query.Data> {
        return Observable.create { observer in
            let watcher = self.client.watch(query: query, cachePolicy: cachePolicy, queue: queue) { result in
                switch result {
                case let .success(data):
                    if let data = data.data {
                        observer.onNext(data)
                    }
                case let .failure(error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                watcher.cancel()
            }
        }
    }

    func perform<Mutation: GraphQLMutation>(
        mutation: Mutation,
        queue: DispatchQueue = DispatchQueue.main) -> Single<Mutation.Data> {
        return Single.create { single in
            let cancellable = self.client.perform(mutation: mutation, queue: queue) { result in
                switch result {
                case let .success(data):
                    if let data = data.data {
                        single(.success(data))
                    }
                case let .failure(error):
                    single(.error(error))
                }
            }

            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
}

extension ApolloClient {
    var rx: RxApollo { return RxApollo(client: self) }
}

