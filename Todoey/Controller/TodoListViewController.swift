//
//  ViewController.swift
//  Todoey
//
//  Created by Adam Malpass on 2019/08/31.
//  Copyright © 2019 Adam Malpass. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var items: Results<Item>?
    
    var selectedCategory : Category?
    {
        didSet
        {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //loadItems()
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = items?[indexPath.row].title ?? "No items added yet"
        
        if items?[indexPath.row].done ?? false
        {
            cell.accessoryType = .checkmark
        }
        else
        {
            cell.accessoryType = .none
        }
        
        return cell
    }

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row]
        {
            do
            {
                try realm.write {
                    item.done = !item.done
                }
            }
            catch
            {
                print("Error changing done status, \(error)")
            }
        }
        
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
    @IBAction func addNewTodoButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory
            {
                do
                {
                    try self.realm.write {
                        let newToDo = Item()
                        newToDo.title = textField.text!
                        newToDo.dateCreated = Date()
                        currentCategory.items.append(newToDo)
                        self.realm.add(newToDo)
                    }
                }
                catch
                {
                    print("Error saving newToDo item \(error)")
                }
            }
            
           self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems()
    {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func deleteCell(at indexPath : IndexPath)
    {
        do
        {
            try self.realm.write {
                self.realm.delete(self.items![indexPath.row])
            }
            
            //Not need to reloadData if use destructive swiping method
            //tableView.reloadData()
        }
        catch
        {
            print("Error deleting item \(error)")
        }
        
    }

    
    
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        print(searchBar.text!)

        searchItems(in: searchBar)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0
        {
            loadItems()

            DispatchQueue.main.async
            {
                searchBar.resignFirstResponder()
            }

        }
        else
        {
            searchItems(in: searchBar)
        }
    }

    func searchItems(in searchBar: UISearchBar)
    {
        items = realm.objects(Item.self)
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    
    }

}

