//
//  DataAdapter.swift
//  The Prolific Library
//
//  Created by Gungor Basa on 5/15/17.
//  Copyright © 2017 Gungor Basa. All rights reserved.
//

import Foundation
import PKHUD

class DataAdapter {
    private init() { }
    
    // MARK: Shared Instance
    // static let shared = DataAdapter()
    
    class func getBooks(completion: @escaping ([Book]?) -> Void) {
        
        HUD.flash(HUDContentType.progress)
        // Based on the connection, we can use network or db here
        NetworkAdapter.Get(urlTail: "/books") { (books) in
            HUD.hide()
            completion(books)
        }
    }
    
    class func getBook(urlTail: String, completion: @escaping (Book?) -> Void) {
        HUD.flash(HUDContentType.progress)
        NetworkAdapter.Get(urlTail: urlTail) { (books) in
            HUD.hide()
            if books?.count != 0 {
                completion(books?[0])
            }
            completion(nil)
        }
    }
    
    class func postBook(book: Book, completion: @escaping (Book?) -> Void) {
        HUD.flash(HUDContentType.progress)
        NetworkAdapter.Post(urlTail: "/books", book: book) { (book) in
            HUD.hide()
            completion(book)
        }
    
    }
    
    class func putBook(book: Book, completion: @escaping (Book?) -> Void) {
        HUD.flash(HUDContentType.progress)
        NetworkAdapter.Put(urlTail: book.url, book: book) { (book) in
            HUD.hide()
            completion(book)
        }
        
    }
    
    
    class func deleteBook(url: String, isSuccess: @escaping (Bool) -> Void) {
        HUD.flash(HUDContentType.progress)
        NetworkAdapter.Delete(urlTail: url) { (success) in
            isSuccess(success)
            HUD.hide()
        }
//        NetworkAdapter.Delete(urlTail: url, isSuccess: isSuccess)
//        HUD.hide()
    }
    
    class func deleteAll(isSuccess: @escaping (Bool) -> Void) {
        HUD.flash(HUDContentType.progress)
        NetworkAdapter.Delete(urlTail: "/clean") { (success) in
            isSuccess(success)
            HUD.hide()
        }
//        NetworkAdapter.Delete(urlTail: "/clean", isSuccess: isSuccess)
    }
    
}
