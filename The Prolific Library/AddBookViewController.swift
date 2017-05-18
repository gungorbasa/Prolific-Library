//
//  AddBookViewController.swift
//  The Prolific Library
//
//  Created by Gungor Basa on 5/16/17.
//  Copyright © 2017 Gungor Basa. All rights reserved.
//

import UIKit
import Eureka


class AddBookViewController: FormViewController {
    var book: Book?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        createForm()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createForm() {
        form +++
            TextFloatLabelRow("book_title") {
                $0.title = "Book Title"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMinLength(minLength: 1))
                $0.validationOptions = .validatesAlways
            }
            <<< TextFloatLabelRow("author") {
                $0.title = "Author"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMinLength(minLength: 1))
                $0.validationOptions = .validatesAlways
            }
            <<< TextFloatLabelRow("publisher") {
                $0.title = "Publisher"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMinLength(minLength: 1))
                $0.validationOptions = .validatesAlways
            }
            <<< TextFloatLabelRow("categories") {
                $0.title = "Categories"
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
                        self.createBook()
                    } else {
                        CustomAlertView.show(title: "Error", text: "Please, fill all required fields.", type: .Error, duration: 1.5)
                    }
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
        return Book(author: author, categories: categories, title: title, publisher: publisher)
    }
    
    func createBook() {
        let book = createBookFromForm()
        if book != nil {
            DataAdapter.postBook(book: book!) { (book) in
                if book != nil {
                    // Show Alert
                    self.navigationController?.popViewController(animated: true)
                    CustomAlertView.show(title: "Successfull", text: "New book is added.", type: .Success, duration: 1.5)
                }
            }
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        var isEmpty = true
        for (_, val) in form.values() {
            if val != nil {
                isEmpty = false
            }
        }
        
        if isEmpty {
            // If empty, just go back
            self.navigationController?.popViewController(animated: true)
        } else {
            // If not empty, just ask
            CustomAlertView.show(title: "Warning", text: "You will loose information. Do you want to continue?", type: .Warning, completion: { (popView) in
                if popView {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
