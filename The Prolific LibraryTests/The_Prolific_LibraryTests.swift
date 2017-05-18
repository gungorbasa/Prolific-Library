//
//  The_Prolific_LibraryTests.swift
//  The Prolific LibraryTests
//
//  Created by Gungor Basa on 5/15/17.
//  Copyright © 2017 Gungor Basa. All rights reserved.
//

import XCTest
import Foundation
@testable import The_Prolific_Library

class The_Prolific_LibraryTests: XCTestCase {
    var books: [Book]?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func create_book(ext: Int) {
        var exp: XCTestExpectation? = expectation(description: "\(#function)\(#line)")
        var book = Book(author: "Gungor Basa", categories: "Novel", title: "Title", publisher: "O'Reily")
        book.author = book.author + String(ext)
        book.categories = book.categories + String(ext)
        book.title = book.title + String(ext)
        book.publisher = book.publisher + String(ext)
        
        DataAdapter.postBook(book: book) { (b) in
            XCTAssert(b != nil)
            exp?.fulfill()
            exp = nil
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    
    
    
    func get_all_books() {
//        var bks = [Book]()
        var exp: XCTestExpectation? = expectation(description: "\(#function)\(#line)")
        DataAdapter.getBooks { (books) in
            self.books = books
            XCTAssert(books != nil)
            exp?.fulfill()
            exp = nil
        }
        
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func delete_book() {
        var exp: XCTestExpectation? = expectation(description: "\(#function)\(#line)")

        if self.books != nil, self.books?.count != 0, let b = self.books?[0] {
            
            DataAdapter.deleteBook(url: b.url, isSuccess: { (success) in
                XCTAssert(success == true)
                exp?.fulfill()
                exp = nil
            })
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    
    func delete_all() {
        var exp: XCTestExpectation? = expectation(description: "\(#function)\(#line)")
        
        DataAdapter.deleteAll { (success) in
            XCTAssert(success == true)
            exp?.fulfill()
            exp = nil
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testExample() {
        for i in 1...5 {
            create_book(ext: i)
        }
        get_all_books()
        
        delete_book()
        
        get_all_books()
        
        XCTAssert(self.books?.count == 4)
        
        delete_all()
        
        get_all_books()
        
        XCTAssert(self.books?.count == 0)
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
