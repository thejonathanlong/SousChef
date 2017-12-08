//
//  RecipeDetailViewController.swift
//  Cooks
//
//  Created by Jonathan Long on 12/7/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
	
	var recipe = Recipe() {
		didSet {
			// Update based on the new recipe that was given
			recipeDidChange()
		}
	}
	
	private let contentScrollView = UIScrollView()
	private let backgroundImageView = UIImageView()
	
	override func loadView() {
		super.loadView()
		if let theView = self.view {
			backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
			contentScrollView.translatesAutoresizingMaskIntoConstraints = false
			
			theView.addSubview(backgroundImageView)
			theView.addSubview(contentScrollView)
			
			contentScrollView.backgroundColor = UIColor.clear // clear so you can see the image behind it
			// Set the content size to be 2 times the screen in width
			// put the recipe details like so:
				// ingredients half way on screen
				// instructions off screen to start
			// YOu can look at this VC two ways
				//1. image -> ingredients
				//2. ingredients -> instructions
				// might should be paged
			
			backgroundImageView.contentMode = .scaleAspectFill
			backgroundImageView.image = UIImage(named: "vcr")
			backgroundImageView.clipsToBounds = true
			
			let constraints = [theView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
							   theView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor),
							   theView.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 2),
							   theView.heightAnchor.constraint(equalTo: backgroundImageView.heightAnchor),
							   theView.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),
							   theView.centerYAnchor.constraint(equalTo: contentScrollView.centerYAnchor),
							   theView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
							   theView.heightAnchor.constraint(equalTo: contentScrollView.heightAnchor)
			]
			
			NSLayoutConstraint.activate(constraints)
		}
	}
	
	// The recipe has changed so update the content appropriately
	func recipeDidChange() {
		backgroundImageView.image = recipe.image
		backgroundImageView.setNeedsDisplay()
	}

}
