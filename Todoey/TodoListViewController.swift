//
//  ViewController.swift
//  Todoey
//
//  Created by Adam Malpass on 2019/08/31.
//  Copyright © 2019 Adam Malpass. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    //var itemArray = ["Feed Luca", "Duang Benny", "Learn Swift"]
    //var itemArray = [ToDo]()
    var itemArray = [Item]()
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let todo1 = ToDo()
//        todo1.title = "Feed Luca"
//        itemArray.append(todo1)
//
//        let todo2 = ToDo()
//        todo2.title = "Duang Benny"
//        itemArray.append(todo2)
//
//        let todo3 = ToDo()
//        todo3.title = "Learn Swift"
//        itemArray.append(todo3)
        
          //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
        
        loadItems()
        
        //if let items = defaults.array(forKey: "TodoListArray") as? [String]
        //{
        //    itemArray = items
        //}
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if itemArray[indexPath.row].done
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
        //print(itemArray[indexPath.row])
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        //print(tableView.cellForRow(at: indexPath)?.accessoryType)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        //tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
    
    @IBAction func addNewTodoButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //print("Added Item")
            
            //let newToDo = ToDo()
            
            let newToDo = Item(context: self.context)
            
            newToDo.title = textField.text!
            newToDo.done = false
            self.itemArray.append(newToDo)
            
            self.saveItems()
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
           // self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems()
    {
//        let encoder = PropertyListEncoder()
//
//        do
//        {
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: self.dataFilePath!)
//        }
//        catch
//        {
//            print("Error encoding item array, \(error)")
//        }
        
        do
        {
            try context.save()
        }
        catch
        {
            print("Error saving context \(error)")
        }
        
        
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest())
    {
//        if let data = try? Data(contentsOf: dataFilePath!)
//        {
//            let decoder = PropertyListDecoder()
//            do
//            {
//                itemArray = try decoder.decode([ToDo].self, from: data)
//            }
//            catch
//            {
//                print("Error decoding item array, \(error)")
//            }
//        }
        
        do
        {
            itemArray = try context.fetch(request)
            tableView.reloadData()
        }
        catch
        {
            print("Error fetching data from context \(error)")
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
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    
}

