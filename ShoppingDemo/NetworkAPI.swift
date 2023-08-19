//
//  NetworkAPI.swift
//  ShoppingDemo
//
//  Created by Qi Zhu on 8/12/23.
//

import UIKit
import Alamofire


private let BaseUrl = "https://www.hansoft.com.au/"
class NetworkAPI {

    static func homeProductList(completion: @escaping (Result<[Product],Error>) -> Void) {
        
        AF.request(BaseUrl + "iPhone.json").responseData {
         response in
            switch response.result {
            case let .success(data):
                if let list = try? JSONDecoder().decode([Product].self, from: data) {
                    completion(.success(list))
                }
                else {
                    let error = NSError(domain: "NetworkAPIDomain", code: 0,userInfo: [NSLocalizedDescriptionKey:"Decode error"])
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    

}
