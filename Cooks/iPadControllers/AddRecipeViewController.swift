//
//  AddRecipeViewController.swift
//  SousChef
//
//  Created by Jonathan Long on 1/18/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController {
	let ingredientExpandingTextView = ExpandingTextView()
	let ingredientExpandingTextViewTapGestureRecognizer = UITapGestureRecognizer()
	let directionTextViewTapGestureRecognizer = UITapGestureRecognizer()
	let directionExpandingTextView = ExpandingTextView()
	
	override func loadView() {
		super.loadView()
		view.backgroundColor = UIColor.white
		
		directionTextViewTapGestureRecognizer.addTarget(self, action: #selector(expandDirectionDetails(gesture:)))
		directionExpandingTextView.addGestureRecognizer(directionTextViewTapGestureRecognizer)
		
		ingredientExpandingTextViewTapGestureRecognizer.addTarget(self, action: #selector(expandIngredientDetails(gesture:)))
		ingredientExpandingTextView.addGestureRecognizer(ingredientExpandingTextViewTapGestureRecognizer)
		
		ingredientExpandingTextView.backgroundColor = UIColor.green
		self.view.backgroundColor = UIColor.red
		directionExpandingTextView.backgroundColor = UIColor.blue
		
		ingredientExpandingTextView.translatesAutoresizingMaskIntoConstraints = false
		ingredientExpandingTextView.headerTitle = "Ingredients"
		ingredientExpandingTextView.isExpanded = false
		view.addSubview(ingredientExpandingTextView)
		
		directionExpandingTextView.translatesAutoresizingMaskIntoConstraints = false
		directionExpandingTextView.headerTitle = "Directions"
		directionExpandingTextView.isExpanded = true
		view.addSubview(directionExpandingTextView)
		
		let constraints = [
			ingredientExpandingTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			ingredientExpandingTextView.topAnchor.constraint(equalTo: view.topAnchor),
			ingredientExpandingTextView.widthAnchor.constraint(equalTo: view.widthAnchor),
			directionExpandingTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			directionExpandingTextView.topAnchor.constraint(equalTo: ingredientExpandingTextView.bottomAnchor),
			directionExpandingTextView.widthAnchor.constraint(equalTo: view.widthAnchor),
			ingredientExpandingTextView.heightAnchor.constraint(lessThanOrEqualTo: self.view.heightAnchor, multiplier: 1.0),
			directionExpandingTextView.heightAnchor.constraint(lessThanOrEqualTo: self.view.heightAnchor, multiplier: 1.0),
		]
		
		NSLayoutConstraint.activate(constraints)
	}
	
	@objc func expandIngredientDetails(gesture: UITapGestureRecognizer) {
		ingredientExpandingTextView.isExpanded = !ingredientExpandingTextView.isExpanded
	}
	
	@objc func expandDirectionDetails(gesture: UITapGestureRecognizer) {
		directionExpandingTextView.isExpanded = !directionExpandingTextView.isExpanded
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
}
