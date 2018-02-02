//
//  AddWorkFlow.swift
//  SousChef
//
//  Created by Jonathan Long on 1/18/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit

class RecipeReviewViewController: UIViewController, UITextViewDelegate {
	
	let titleTextView = UITextView()
	let ingredientExpandingTextView = ExpandingTextView()
	let directionExpandingTextView = ExpandingTextView()
	let ingredientExpandingTextViewTapGestureRecognizer = UITapGestureRecognizer()
	let directionTextViewTapGestureRecognizer = UITapGestureRecognizer()
	
	
	override func loadView() {
		super.loadView()
		view.backgroundColor = UIColor.white
		
		titleTextView.translatesAutoresizingMaskIntoConstraints = false
		ingredientExpandingTextView.translatesAutoresizingMaskIntoConstraints = false
		directionExpandingTextView.translatesAutoresizingMaskIntoConstraints = false
		
		titleTextView.text = "Recipe Name"
		titleTextView.font = SousChefStyling.preferredFont(for: .headline)
		titleTextView.textColor = SousChefStyling.darkColor
		titleTextView.alpha = 0.85
		
		titleTextView.delegate = self
		
		view.addSubview(titleTextView)
		view.addSubview(directionExpandingTextView)
		view.addSubview(ingredientExpandingTextView)
		
		directionTextViewTapGestureRecognizer.addTarget(self, action: #selector(expandDirectionDetails(gesture:)))
		directionExpandingTextView.addGestureRecognizer(directionTextViewTapGestureRecognizer)
		
		ingredientExpandingTextViewTapGestureRecognizer.addTarget(self, action: #selector(expandIngredientDetails(gesture:)))
		ingredientExpandingTextView.addGestureRecognizer(ingredientExpandingTextViewTapGestureRecognizer)
		
		let constraints = [
			titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			titleTextView.heightAnchor.constraint(equalToConstant: 40),
			ingredientExpandingTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			ingredientExpandingTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			ingredientExpandingTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
			directionExpandingTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			directionExpandingTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			directionExpandingTextView.topAnchor.constraint(equalTo: ingredientExpandingTextView.bottomAnchor),
		]
		
		NSLayoutConstraint.activate(constraints)
		
		ingredientExpandingTextView.headerTitle = "Ingredients"
		ingredientExpandingTextView.text = "I’d love to isolate the first time I heard these words, but I can’t. It predates my memory. I do, however, remember the first time I thought about these words, which didn’t happen until 2003. I was intrigued by the math: The main character (who’s technically the creation of non-Eagle Browne, since he wrote this particular verse) is fleeing from seven women."
		directionExpandingTextView.headerTitle = "Directions"
		directionExpandingTextView.text = "I’d love to isolate the first time I heard these words, but I can’t. It predates my memory. I do, however, remember the first time I thought about these words, which didn’t happen until 2003. I was intrigued by the math: The main character (who’s technically the creation of non-Eagle Browne, since he wrote this particular verse) is fleeing from seven women."
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

//MARK: - UITextViewDelegate
extension RecipeReviewViewController {
	
	func textViewDidChange(_ textView: UITextView) {
		textView.alpha = 1.0
	}
	
}
