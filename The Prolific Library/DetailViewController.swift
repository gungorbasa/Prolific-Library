//
//  DetailViewController.swift
//  The Prolific Library
//
//  Created by Gungor Basa on 5/16/17.
//  Copyright © 2017 Gungor Basa. All rights reserved.
//

import UIKit
import Eureka

class DetailViewController: FormViewController {
    var editable = true
    var book: Book?
    override func viewDidLoad() {
        super.viewDidLoad()
        if editable {
            editScreen()
        } else {
            detailScreen()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editScreen() {
        form +++
            TextFloatLabelRow("book_title") {
                $0.title = "Book Title"
                $0.value = book?.title
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMinLength(minLength: 1))
                $0.validationOptions = .validatesAlways
            }
            <<< TextFloatLabelRow("author") {
                $0.title = "Author"
                $0.value = book?.author
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMinLength(minLength: 1))
                $0.validationOptions = .validatesAlways
            }
            <<< TextFloatLabelRow("publisher") {
                $0.title = "Publisher"
                $0.value = book?.publisher
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMinLength(minLength: 1))
                $0.validationOptions = .validatesAlways
            }
            <<< TextFloatLabelRow("categories") {
                $0.title = "Categories"
                $0.value = book?.categories
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMinLength(minLength: 1))
                $0.validationOptions = .validatesAlways
                
            }
            <<< ButtonRow("submit_btn") {
                $0.title = "Submit"
                }.onCellSelection { cell, row in
                    guard let errCount = row.section?.form?.validate().count else {
                        return
                    }
                    
                    if errCount == 0 {
                        self.updateBook()
                    } else {
                        CustomAlertView.show(title: "Error", text: "Please, make sure all fields have value.", type: .Error, duration: 1.5)
                    }
        }
        
    }
    
    func detailScreen() {
        form +++
            LabelRow("book_title") { row in
                row.title = book?.title
                row.cell.textLabel?.numberOfLines = 0
            }
            <<< LabelRow("author") { row in
                row.title = book?.author
                row.cell.textLabel?.numberOfLines = 0
            }
            <<< LabelRow("publisher") { row in
                row.title = book?.publisher
                if let textLabel = row.cell.textLabel {
                    textLabel.numberOfLines = 0
                    textLabel.font = UIFont(name: textLabel.font.fontName, size: 12)
                }
            }.cellUpdate({ (cell, row) in
                cell.textLabel?.textColor = .gray
            })
            <<< LabelRow("last_checked_out") { row in
                if let textLabel = row.cell.textLabel {
                    textLabel.numberOfLines = 0
                    textLabel.font = UIFont(name: textLabel.font.fontName, size: 12)
                }
                row.title = "Last Checked Out:"
                guard let lastCheckedOut = book?.lastCheckedOut,
                    lastCheckedOut != "",
                    let byWho = book?.lastCheckedOutBy else {
                    return
                }
                
                var date = Date()
                date.toDate(dateStr: lastCheckedOut)
                // "yyyy-MM-dd'T'HH:mm:ss"
                row.title = "Last Checked Out: \n\(byWho) @ \(Date.toString(date: date, dateFormat: "EEE, dd MMM yyyy hh:mm"))"
                
                }.cellUpdate({ (cell, row) in
                    cell.textLabel?.textColor = .gray
                })
            <<< ButtonRow("checkout_btn") {
                $0.title = "Checkout"
                }.onCellSelection { cell, row in
                    CustomAlertView.showWithTextField(title: "User Info", text: "Please enter user information.", textFieldPlaceholders: ["Name"], yesButton: "Ok", noButton: "Cancel", completion: { (isSuccess, textDict) in
                        if isSuccess {
                            let now = Date()
                            self.book?.lastCheckedOut = Date.toString(date: now, dateFormat: "yyyy-MM-dd'T'HH:mm:ss")
                            self.book?.lastCheckedOutBy = (textDict?["Name"])!
                            DataAdapter.putBook(book: self.book!, completion: { (newBook) in
                                if newBook != nil {
                                    CustomAlertView.show(title: "Successfull", text: "Your book is successfully checked out.", type: .Success, duration: 1.5)
                                    self.navigationController?.popViewController(animated: true)
                                } else {
                                    CustomAlertView.show(title: "Error", text: "Checkout Error", type: .Error, duration: 1.5)
                                }
                            })
                        }
                    })
            }
        
    }
    
    
    func updateBook() {
        let newBook = createBookFromForm()
        if newBook != nil {
            // send update request
//            EZLoadingActivity.show("Loading...", disableUI: true)
            DataAdapter.putBook(book: newBook!, completion: { (book) in
                if book != nil {
                    self.navigationController?.popViewController(animated: true)
                    CustomAlertView.show(title: "Successfull", text: "Your book is updated.", type: .Success, duration: 1.5)
                } else {
                    CustomAlertView.show(title: "Error", text: "Problem occured during update.", type: .Error, duration: 1.5)
                }
            })
        }
    }
    
    func createBookFromForm() -> Book? {
        let values = form.values()
        guard let title = values["book_title"] as? String else {
            return nil
        }
        guard let author = values["author"] as? String else {
            return nil
        }
        guard let publisher = values["publisher"] as? String else {
            return nil
        }
        guard let categories = values["categories"] as? String else {
            return nil
        }
        var newBook = Book(author: author, categories: categories, title: title, publisher: publisher)
        newBook.url = (book?.url)!
        return newBook
    }
    @IBAction func shareButtonClicked(_ sender: UIBarButtonItem) {
        let textToShare = "This book is awesome. Go to library and check it out!"
        
        if let myWebsite = URL(string: "https://www.gungorbasa.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    

}
