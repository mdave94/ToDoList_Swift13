//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TodoListViewController: UITableViewController {
    
    
    //MARK:- constants declaration
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var mainIndexPath: Int = 0
    
    
    var selectedCategory: Category?{
        didSet{
             loadItems()
        }
    }
    
    override func viewDidLoad() {
        let longPressGestrude = UILongPressGestureRecognizer()
        self.view.addGestureRecognizer(longPressGestrude)
        longPressGestrude.addTarget(self, action: #selector(clickLongPress))
        
        
        super.viewDidLoad()
       
        
       
     
        
    }
    //MARK:- Long press gestrude methods
    @objc func clickLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer){
        print("table element long pressed !")
         
       var textField1 = UITextField()
        textField1.text = "TEXTFIELD SZOVEG"
        
        // Getting the index.row from the pressed element
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {

            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                self.mainIndexPath = indexPath.row
                print("MAININDEXPATH :  \(self.mainIndexPath)")
                   
           }
        }
         
        let alert = UIAlertController(title: "Modify element", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Edit", style: .default) { _ in
       
            
          if let currentCategory = self.selectedCategory {
                        do{
                            try self.realm.write{
                                currentCategory.items[self.mainIndexPath].title = textField1.text!
                                    
                                }
                                
                        }catch{
                            print("Error in writing Realm : \(error)")
                        }
                    }
                    
            
            
                     
            self.tableView.reloadData()
        })
        
       
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            
            self.deleteItem(deleteID: self.mainIndexPath)
            self.tableView.reloadData()
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                         UIAlertAction in
                         NSLog("Cancel Pressed")
                }
    
 
    alert.addAction(cancelAction)
               
    present(alert, animated: true, completion: nil)

        
        
     
        
    }
    //MARK:-  Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            //cell.accessoryType = item.done ? .checkmark : .none
            
            cell.backgroundColor = item.done ? .green : .white
        }else{
            cell.textLabel?.text = " No items added yet"
        }
        
    
        return cell
        
    }
    
    
    
    //MARK:- Delegation methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row]{
            do{
                
                
                
                try realm.write{
                    item.done = !item.done
                }
            }catch{
                print("error in update with realm: \(error)")
            }
        }
        
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
                            newItem.dateCreated = Date()
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
        
        //Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                  UIAlertAction in
                  NSLog("Cancel Pressed")
              }
        alert.addAction(cancelAction)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Load item
    
        func loadItems(){
            
            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
           
            tableView.reloadData()
        }
    
    //MARK: - Delete item
   func deleteItem(deleteID:Int){
print("DeleteItem")
        if let item = todoItems?[deleteID]{
               do{
                   try realm.write{
                    realm.delete(item)
                   }
               }catch{
                   print("error in update with realm: \(error)")
               }
           }

    }
     
    
    
    
}

//MARK:- Search bar functions
extension TodoListViewController: UISearchBarDelegate{

    //Search BUttuon clicked

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
 
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

extension TodoListViewController: SwipeTableViewCellDelegate{
        
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        print("LEFUT A SWIPE")
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title :"Delete"){ action, indexpath in
            // Handle action
            
            print("deleted item")
        }
        
        deleteAction.image = UIImage(named:"delete-icon")
        
       return [deleteAction]
    }
    
    
}
