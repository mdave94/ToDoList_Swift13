//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    
    //MARK:- itemArray declaration
    var itemArray = [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
     
        
    }
    
    
    //MARK:-  Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.titlte
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        

        saveItems()
        return cell
        
    }
    
    
    
    
    
    
    //MARK:- Delegation methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add button action
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            
            if textField.text == ""{
                textField.text = "Unnamed item"
            }
        
            let newItem = Item()
            newItem.titlte = textField.text!
            
            self.itemArray.append(newItem)
            
        
            self.saveItems()
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new element"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Save items
    
    func saveItems(){
        let encoder = PropertyListEncoder()
                   
                   do {
                       let data = try encoder.encode(self.itemArray)
                       try data.write(to:dataFilePath! )
                   }catch{
                      print("ERROR IN SAVING: \(error)")
                   }
    }
    //MARK: - Load item
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder ()
            
            do {
                itemArray = try decoder.decode([Item].self,from: data)
            }catch{
                print("ERROR IN LOADING ITEMS: \(error)")
            }
            
            
        }
    }
    
    
    
    
    
    
}

