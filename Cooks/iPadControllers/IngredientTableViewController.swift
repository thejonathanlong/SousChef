//
//  IngredientTableViewController.swift
//  Cooks
//
//  Created by Jonathan Long on 1/5/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit

class IngredientTableViewController: BaseTableViewController {
	//MARK: Public Properties
	var ingredients: [Ingredient] = [] {
		didSet (newIngredients) {
			if ingredients != newIngredients {
				ingredientsdidChange()
			}
		}
	}
	
	var recipeName = "Vegan Cinnamon Rolls"
	
	override lazy var headerText: String = {
		return "Ingredients"
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableHeaderLabel.textAlignment = .left
	}
}

// MARK: - Table view data source
extension IngredientTableViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ingredients.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableViewController.baseTableViewCellReuseIdentifier, for: indexPath) as! DetailTableViewCell
		
		let ingredient = ingredients[indexPath.row]
		cell.mainTextLabel.text = ingredient.originalDescription
		//		cell.subTextLabel.text = ingredient.itemDescription
		cell.backgroundColor = UIColor.clear
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let ingredient = ingredients[indexPath.row].originalDescription
		let sizeConstraint = CGSize(width: tableView.frame.size.width - 20, height: .greatestFiniteMagnitude)
		let labelFont = SousChefStyling.preferredFont(for: .body)
		let attributes = [NSAttributedStringKey.font : labelFont]
		let boundingSize = NSString(string: ingredient).boundingRect(with: sizeConstraint, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil).size
		
		return ceil(boundingSize.height) + (5 * 2.0)
	}
	
	func ingredientsdidChange() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
}
