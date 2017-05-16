//
//  The_Prolific_LibraryTests.swift
//  The Prolific LibraryTests
//
//  Created by Gungor Basa on 5/15/17.
//  Copyright © 2017 Gungor Basa. All rights reserved.
//

import XCTest
@testable import The_Prolific_Library

class The_Prolific_LibraryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        createBooks()
    }
    
    func getAllBooks() {
        DataAdapter.getBooks { (books) in
            print(books ?? "There is no book!")
        }
    }
    
    func createBooks() {
        var book = Book(author: "Gungor Basa", categories: "Novel", title: "Title", publisher: "O'Reily")
        for i in 1...5 {
            book.author += String(i)
            book.categories += String(i)
            book.title += String(i)
            book.publisher += String(i)
            
            DataAdapter.postBook(book: book, completion: { (book) in
                print("Book is created: \(String(describing: book))")
            })
        }
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
