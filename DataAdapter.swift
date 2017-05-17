//
//  DataAdapter.swift
//  The Prolific Library
//
//  Created by Gungor Basa on 5/15/17.
//  Copyright © 2017 Gungor Basa. All rights reserved.
//

import Foundation

class DataAdapter {
    private init() { }
    
    // MARK: Shared Instance
    // static let shared = DataAdapter()
    
    class func getBooks(completion: @escaping ([Book]?) -> Void) {
        // Based on the connection, we can use network or db here
        NetworkAdapter.Get(urlTail: "/books") { (books) in
            completion(books)
        }
    }
    
    class func getBook(urlTail: String, completion: @escaping (Book?) -> Void) {
        NetworkAdapter.Get(urlTail: urlTail) { (books) in
            if books?.count != 0 {
                completion(books?[0])
            }
            completion(nil)
        }
    }
    
    class func postBook(book: Book, completion: @escaping (Book?) -> Void) {
        NetworkAdapter.Post(urlTail: "/books", book: book) { (book) in
            completion(book)
        }
    
    }
    
    class func putBook(book: Book, completion: @escaping (Book?) -> Void) {
        NetworkAdapter.Put(urlTail: book.url, book: book) { (book) in
            completion(book)
        }
        
    }
    
    
    class func deleteBook(url: String, isSuccess: @escaping (Bool) -> Void) {
        NetworkAdapter.Delete(urlTail: url, isSuccess: isSuccess)
    }
    
    class func deleteAll(isSuccess: @escaping (Bool) -> Void) {
        NetworkAdapter.Delete(urlTail: "/clean", isSuccess: isSuccess)
    }
    
}
