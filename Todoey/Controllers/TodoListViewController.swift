//
//  ViewController.swift
//  Todoey
//
//  Created by Mohammed Abouarab on 4/23/19.
//  Copyright © 2019 Mohammed Abouarab. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60.0
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.name
        if let colorHEX =  selectedCategory?.color {
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller dose not exist")}
            if let navBarColor = UIColor(hexString: colorHEX) {
                navBar.barTintColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
                searchBar.barTintColor = navBarColor
            }
            
        }
        
    }
    
    //MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            if let colour = UIColor(hexString: (selectedCategory?.color)!)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat((todoItems?.count)!)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No Items Add"
        }
        
        return cell
    }
    
    //MARK: tableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }
            catch {
                print("Error saving done status: \(error)")
            }
        }
        tableView.reloadData()
    }
    
    //MARK: Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user click the add item button on UIAlert
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    print("Error with saving item: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        if let deletedItem = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(deletedItem)
                }
            }
            catch {
                print("Error Deleting Item: \(error)")
            }
        }
    }
}

//MARK: Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

