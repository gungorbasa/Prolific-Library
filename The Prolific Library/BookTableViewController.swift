//
//  BookTableViewController.swift
//  The Prolific Library
//
//  Created by Gungor Basa on 5/15/17.
//  Copyright © 2017 Gungor Basa. All rights reserved.
//

import UIKit

class BookTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    var books = [Book]() {
        didSet {
            if oldValue != books {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
        if tableView.isEditing {
            tableView.setEditing(false, animated: false)
        }
        
        
        
        DataAdapter.getBooks { (result) in
            if result != nil {
                self.books = result!
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookDetailSegue" {
            guard let params = sender as? [String: Any],
                  let indexPath = params["indexPath"] as? IndexPath,
                  let editable = params["editable"] as? Bool else {
                CustomAlertView.show(title: "Error", text: "Something went wrong.", type: .Error, duration: 1.5)
                return
            }
            if let vc = segue.destination as? DetailViewController {
                if editable {
                    vc.navigationItem.title = "Edit Book"
                } else {
                    vc.navigationItem.title = "Details"
                }
                vc.editable = editable
                vc.book = books[indexPath.row]
            }
        }
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(BookTableViewController.editButtonPressed(_:)))
            
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(BookTableViewController.editButtonPressed(_:)))
        }
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
}

// MARK: UITablveViewDelegate and UITableViewDataSource Methods
extension BookTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookTableViewCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = books[indexPath.row].title
        cell.detailTextLabel?.text = books[indexPath.row].author
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler:{action, indexpath in
            let dict = ["editable": true,
                "indexPath": indexPath] as [String : Any]
            self.performSegue(withIdentifier: "bookDetailSegue", sender: dict)
        });
        editAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let deleteRowAction = UITableViewRowAction(style: .destructive, title: "Delete", handler:{action, indexpath in
            DataAdapter.deleteBook(url: self.books[indexPath.row].url, isSuccess: { (isSuccess) in
                if isSuccess {
                    CustomAlertView.show(title: "Success", text: "Book is deleted.", type: .Success, duration: 1.5)
                    self.books.remove(at: indexPath.row)
                } else {
                    CustomAlertView.show(title: "Error", text: "Delete operation is failed.", type: .Error, duration: 1.5)
                }
            })
        });
        
        return [deleteRowAction, editAction];
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = ["editable": false,
                    "indexPath": indexPath] as [String : Any]
        self.performSegue(withIdentifier: "bookDetailSegue", sender: dict)
    }
}
