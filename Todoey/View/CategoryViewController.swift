//
//  CategoryViewController.swift
//  Todoey
//
//  Created by David on 2020. 05. 06..
//  Copyright © 2020. App Brewery. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController{
    
    var categories = [Category]()
    
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
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
            
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
        
        return categories.count
        
    }
    
    //MARK:- TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
        
    }
    
    //MARK:- Data manipolation methods
    func saveCategories(){
        
        do {
            try context.save()
        }catch{
            print("Error in saving Category : \(error)")
        }
        tableView.reloadData()
        
    }
    
    func loadCategories(){
        
        let request: NSFetchRequest = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        }catch{
            print("Error in loading Categories : \(error)")
        }
        tableView.reloadData()
        
        
    }

}
