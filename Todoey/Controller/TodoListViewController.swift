//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    //MARK: - Persistdata context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK:- itemArray declaration
    var itemArray = [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // print(dataFilePath)
        
        loadItems()
     
        
    }
    
    
    //MARK:-  Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        

        saveItems()
        return cell
        
    }
    
    
    
    //MARK:- Delegation methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
      //  deleteItem(deleteID: indexPath.row)
        
        
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
            
           
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
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
        
                do {
                    try context.save()
                }catch{
                    print("ERROR: \(error)")
                   }
     //   self.tableView.reloadData()
    }
    //MARK: - Load item
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest() ){
    
        do{
          itemArray = try context.fetch(request)
        }catch{
            print("ERROR: \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Delete item
   func deleteItem(deleteID:Int){
    
        context.delete(itemArray[deleteID])

        itemArray.remove(at: deleteID)
            
    }
    
    
    
}

//MARK:- Search bar functions
extension TodoListViewController: UISearchBarDelegate{
    
    //Search BUttuon clicked

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
          request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

          request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        loadItems(with: request)
        
        
    }
    
    // Didchange function
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
           
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
    
    
    
    
}
