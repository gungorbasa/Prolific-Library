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

class NetworkAdapter {
    static let baseUrl = "http://prolific-interview.herokuapp.com/5919f1567cc3aa000af4f717/"
    
    class func Get(urlTail: String, completion: @escaping ([Book]?) -> Void) {
        Alamofire.request(baseUrl+urlTail).responseArray { (response: DataResponse<[Book]>) in
            if response.result.isSuccess {
                completion(response.value)
            }
            
            var i = 1
            
            for item in response.value! {
                print("\(i): \(item)")
                i+=1
            }
            completion(nil)
        }
        
    }
    
    class func Post(urlTail: String, book: Book) {
        let parameters = book.post
        Alamofire.request(baseUrl+urlTail, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
        }
        
        
//        Alamofire.request(baseUrl+urlTail, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
//            print("Error Message: \(String(describing: response.error))")
//            if response.result.isSuccess {
//                print("Network call is succeeded..")
//            } else {
//                print("Network call is failed..")
//            }
//        }
    }
    
    class func Put(urlTail: String) {
        
    }
    
    class func Delete(urlTail: String) {
        
    }
    
    class func CleanDatabase() {
        
    }
}
