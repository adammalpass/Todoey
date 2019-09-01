//
//  ViewController.swift
//  Todoey
//
//  Created by Adam Malpass on 2019/08/31.
//  Copyright © 2019 Adam Malpass. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Feed Luca", "Duang Benny", "Learn Swift"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        print(tableView.cellForRow(at: indexPath)?.accessoryType)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            print("entered if")
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
            print("else")
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}

