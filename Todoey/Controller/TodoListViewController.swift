//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    
    //MARK:- constants declaration
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category?{
        didSet{
             loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // print(dataFilePath)
        
       
     
        
    }
    
    
    //MARK:-  Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
         
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
                        
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = " No items added yet"
        }
        
    
        return cell
        
    }
    
    
    
    //MARK:- Delegation methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
   // todoItems[indexPath.row].done = !todoItems[indexPath.row].done
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
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write{
                            let newItem = Item()
                            newItem.title = textField.text!
                            currentCategory.items.append(newItem)
                        }
                        
                }catch{
                    print("Error in writing Realm : \(error)")
                
                }
                
                
            }

           
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new element"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Load item
    
        func loadItems(){
            
            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
           
            tableView.reloadData()
        }
    
    //MARK: - Delete item
//   func deleteItem(deleteID:Int){
//
//        context.delete(itemArray[deleteID])
//
//        itemArray.remove(at: deleteID)
//
//    }
    
    
    
}

//MARK:- Search bar functions
//extension TodoListViewController: UISearchBarDelegate{
//
//    //Search BUttuon clicked
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//          request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//
//        loadItems(with: request,predicate: predicate)
//
//
//    }
//
//    // Didchange function
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//
//        }
//    }
//
//
//
//
//}
