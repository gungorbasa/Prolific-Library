//
//  NetworkAdapter.swift
//  The Prolific Library
//
//  Created by Gungor Basa on 5/15/17.
//  Copyright © 2017 Gungor Basa. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import AlamofireNetworkActivityIndicator

class NetworkAdapter {
    static let baseUrl = "http://prolific-interview.herokuapp.com/5919f1567cc3aa000af4f717"
    
    class func Get(urlTail: String, completion: @escaping ([Book]?) -> Void) {
        Alamofire.request(baseUrl+urlTail).responseArray { (response: DataResponse<[Book]>) in
            if response.result.isSuccess {
                completion(response.value)
            } else {
                completion(nil)
            }
            
        }
    }
    
    class func Post(urlTail: String, book: Book, completion: @escaping (Book?) -> Void) {
        let parameters = book.post
        Alamofire.request(baseUrl+urlTail, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                if response.result.isSuccess {
                    completion(book)
                } else {
                    completion(nil)
                }
        }
    }
    
    class func Put(urlTail: String, book: Book, completion: @escaping (Book?) -> Void) {
        let parameters = book.post
        Alamofire.request(baseUrl+urlTail, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                if response.result.isSuccess, response.response?.statusCode == 200 {
                    completion(book)
                } else {
                    completion(nil)
                }
                
        }
    }
    
    class func Delete(urlTail: String, isSuccess: @escaping (Bool) -> Void) {
        Alamofire.request(baseUrl+urlTail, method: .delete, parameters: nil, encoding: JSONEncoding.default).response(queue: nil) { (response) in
            guard response.error == nil,
                  let status = response.response?.statusCode else {
                isSuccess(false)
                return
            }
            if status == 200 || status == 204 {
                isSuccess(true)
            } else {
                isSuccess(false)
            }
            
        }
    }
}
