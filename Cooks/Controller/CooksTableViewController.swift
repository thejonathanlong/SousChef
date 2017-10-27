//
//  CooksTableViewController.swift
//  Cooks
//
//  Created by Jonathan Long on 9/8/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import UIKit

class CooksTableViewController: UITableViewController {
    
    static let recipeDetailSegueIdentifier = "RecipeDetailSegue"
    
    let recipes : [Recipe] = []
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.recipeTableViewCellReuseIdentifier, for: indexPath) as! RecipeTableViewCell
        
        cell.textLabel?.text = recipes[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: CooksTableViewController.recipeDetailSegueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case CooksTableViewController.recipeDetailSegueIdentifier:
                if let tabBarController = segue.destination as? RecipeDetailsViewController{
                    tabBarController.recipe = recipes[selectedIndexPath.row]
                }
            default:
                break
            }
        }
    }

}
