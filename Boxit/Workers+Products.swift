//
//  Workers+GetProducts.swift
//  Boxit
//
//  Created by Gabriel Coman on 11/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift

//
// MARK: Get all product & favourite products metadata for a user
extension ProductsWorker {
    
    //
    // get all products, in a random order
    static func get(productsForUserId id:String, withMinPrice min: Int?, andMaxPrice max: Int?) -> Observable<Product> {
        
        let request = NetworkRequest(withOperation: NetworkOperation.getProductsForUser(id: id, min: min, max: max))
        let task = NetworkTask()
        return task.execute(withInput: request)
            .flatMap { productData -> Single<BackendData<Product>> in
                
                let request = ParseRequest(withData: productData)
                let task = ParseNetworkDataTask<Product>()
                return task.execute(withInput: request)
            }
            .asObservable()
            .flatMap { data -> Observable<Product> in
                return Observable.from(data.data)
            }
        
    }
    
    //
    // only get the favourite products
    static func get(favouriteProductsForUserId id: String) -> Observable<Product> {
        
        let request = NetworkRequest(withOperation: NetworkOperation.getFavouriteProductsForUser(id: id))
        let task = NetworkTask()
        return task.execute(withInput: request)
            .flatMap { productData -> Single<BackendData<Product>> in
                
                let request = ParseRequest(withData: productData)
                let task = ParseNetworkDataTask<Product>()
                return task.execute(withInput: request)
            }
            .asObservable()
            .flatMap { data -> Observable<Product> in
                return Observable.from(data.data)
            }
        }
}

//
// MARK: Save & Delete Favourite Products
extension ProductsWorker {
    
    static func save(favouriteProduct productId: String, forUserId id: String) -> Single<Void> {
        let request = NetworkRequest(withOperation: NetworkOperation.saveProduct(id: id, asin: productId))
        let task = NetworkTask()
        return task.execute(withInput: request).map { result in return () }
    }
    
    static func delete(favouriteProduct productId: String, forUserId id: String) -> Single<Void> {
        let request = NetworkRequest(withOperation: NetworkOperation.deleteProduct(id: id, asin: productId))
        let task = NetworkTask()
        return task.execute(withInput: request).map { result in return () }
    }
}
