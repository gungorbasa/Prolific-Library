//
//  Book.swift
//  The Prolific Library
//
//  Created by Gungor Basa on 5/15/17.
//  Copyright © 2017 Gungor Basa. All rights reserved.
//

import Foundation
import ObjectMapper

struct Book {
    var author: String = ""
    var categories: String = ""
    var id: Int = 0
    var lastCheckedOut: String = ""
    var lastCheckedOutBy: String = ""
    var publisher: String = ""
    var title: String = ""
    var url: String = ""
    
    init(author: String, categories: String, title: String, publisher: String) {
        self.author = author
        self.categories = categories
        self.title = title
        self.publisher = publisher
    }
    
    init(author: String, categories: String, id: Int, lastCheckedOut: String, lastCheckedOutBy: String, publisher: String, title: String, url: String) {
        self.author = author
        self.categories = categories
        self.id = id
        self.lastCheckedOut = lastCheckedOut
        self.lastCheckedOutBy = lastCheckedOutBy
        self.publisher = publisher
        self.title = title
        self.url = url
    }

    var post: Dictionary<String, String> {
        //    {
        //        "author": "Ash Maurya"
        //        "categories": "process"
        //        "title": "Running Lean"
        //        "publisher": "O'REILLY"
        //    }
        
        return ["author" : author,
                "categories" : categories,
                "title" : title,
                "publisher" : publisher,
                "lastCheckedOut": lastCheckedOut,
                "lastCheckedOutBy": lastCheckedOutBy
        ]
    }
    
    
}

extension Book: Mappable {
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.author <- map["author"]
        self.categories <- map["categories"]
        self.id <- map["id"]
        self.lastCheckedOut <- map["lastCheckedOut"]
        self.lastCheckedOutBy <- map["lastCheckedOutBy"]
        self.publisher <- map["publisher"]
        self.title <- map["title"]
        self.url <- map["url"]
    }

}

extension Book: Equatable {
    static func ==(lhs: Book, rhs: Book) -> Bool {
        if lhs.author == rhs.author && lhs.categories == rhs.categories &&
            lhs.id == rhs.id && lhs.lastCheckedOut == rhs.lastCheckedOut &&
            lhs.lastCheckedOutBy == rhs.lastCheckedOutBy && lhs.publisher == rhs.publisher &&
            lhs.title == rhs.title && lhs.url == rhs.url {
            return true
        }
        return false
    }
}
