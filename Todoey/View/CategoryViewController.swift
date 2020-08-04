//
//  CategoryViewController.swift
//  Todoey
//
//  Created by David on 2020. 05. 06..
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController{
    
    let realm = try! Realm()
    var nameForDelete: String = ""
    var categories: Results<Category>?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        let longPressGestrude = UILongPressGestureRecognizer()
        self.view.addGestureRecognizer(longPressGestrude)
        longPressGestrude.addTarget(self, action: #selector(clickLongPress))
        
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 80

       
    }
    
    //MARK:- clickLongpress
    @objc func clickLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer){
        print("table element long pressed !")

       var textField1 = UITextField()
        textField1.text = "TEXTFIELD SZOVEG"

        // Getting the index.row from the pressed element
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {


            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                self.nameForDelete = categories?[indexPath.row].name as! String



           }
        }

        let alert = UIAlertController(title: "Delete", message: nil, preferredStyle: .alert)



        alert.addAction(UIAlertAction(title: "Delete the element", style: .destructive) { _ in

         self.deleteCategory(self.nameForDelete)
            self.tableView.reloadData()
        })


        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                         UIAlertAction in
                         NSLog("Cancel Pressed")
                }


    alert.addAction(cancelAction)

    present(alert, animated: true, completion: nil)





    }


    //MARK:- Add new Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if textField.text == ""{
                       textField.text = "Unnamed item"
            }
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new Category"
        }
        
        present(alert,animated: true,completion: nil)
        
    }
    //MARK:- TableView DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
        
    }
    // Setting row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 60
       }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "NO Categories added"
      
        return cell
        
    }
    
    //MARK:- Data manipolation methods
    func save(category: Category){
        
        do {
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error in saving Category : \(error)")
        }
        tableView.reloadData()
        
    }
    
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
        
    }
    
    //MARK:- TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationViewController = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationViewController.selectedCategory = categories?[indexPath.row]
        }
        
    }
    func deleteCategory (_ categoryName: String) {

          let categoryForDelete = realm.objects(Category.self).filter("name = '\(categoryName)'")
          
        
        
          let itemsForDelete = realm.objects(Item.self).filter("ANY parentCategory.name = '\(categoryName)'")
    
         
          print("Category in delete : \(categoryForDelete)   || items : \(itemsForDelete)")
              do{
                    try realm.write{
                        realm.delete(itemsForDelete)
                        realm.delete(categoryForDelete)
                    
                    }
                }catch{
                    print("error in update with realm: \(error)")
                }

            print("NAMEFORDELETE : \(categoryName)")


      }
    
}


//MARK:- SwipeTableCellDelegate methods

extension CategoryViewController: SwipeTableViewCellDelegate{
        
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
    

