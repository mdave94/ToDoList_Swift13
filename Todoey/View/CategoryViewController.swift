//
//  CategoryViewController.swift
//  Todoey
//
//  Created by David on 2020. 05. 06..
//  Copyright © 2020. App Brewery. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController{
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

       
    }


    //MARK:- Add new Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
        alert.addAction(action)
        
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        
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

}
