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
	private let contentView = UIView()
	
	private var contentViewLeadingConstraint: NSLayoutConstraint?
	private var contentViewWidthConstraint: NSLayoutConstraint?
	
	override func loadView() {
		super.loadView()
		if let theView = self.view {
			backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
			contentScrollView.translatesAutoresizingMaskIntoConstraints = false
			contentView.translatesAutoresizingMaskIntoConstraints = false
			
			theView.addSubview(backgroundImageView)
			theView.addSubview(contentScrollView)
			contentScrollView.addSubview(contentView)
			
			contentView.backgroundColor = UIColor.purple
			contentScrollView.backgroundColor = UIColor.clear // clear so you can see the image behind it
			contentScrollView.bounces = false
			
			contentScrollView.contentSize = CGSize(width: theView.frame.size.width * 1.5, height: theView.frame.size.height)
			
			backgroundImageView.contentMode = .scaleAspectFill
			backgroundImageView.image = UIImage(named: "vcr")
			backgroundImageView.clipsToBounds = true
			
			contentViewLeadingConstraint = contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor, constant: contentScrollView.contentSize.width / 3)
			contentViewWidthConstraint = contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor)
			
			let constraints = [theView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
							   theView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor),
							   theView.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 2),
							   theView.heightAnchor.constraint(equalTo: backgroundImageView.heightAnchor),
							   theView.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),
							   theView.centerYAnchor.constraint(equalTo: contentScrollView.centerYAnchor),
							   theView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
							   theView.heightAnchor.constraint(equalTo: contentScrollView.heightAnchor),
							   contentViewLeadingConstraint!,
							   contentViewWidthConstraint!,
							   contentView.heightAnchor.constraint(equalTo: contentScrollView.heightAnchor)
			]
			
			NSLayoutConstraint.activate(constraints)
		}
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		contentScrollView.contentSize = CGSize(width: size.width * 1.5, height: size.height);
		
		// Deactivate the old constraints and update basedon thew new size.
		contentViewWidthConstraint?.isActive = false
		contentViewLeadingConstraint?.isActive = false
		contentViewLeadingConstraint = contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor, constant: contentScrollView.contentSize.width / 3)
		contentViewWidthConstraint = contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor)
		contentViewWidthConstraint?.isActive = true
		contentViewLeadingConstraint?.isActive = true
	}
	
	// The recipe has changed so update the content appropriately
	func recipeDidChange() {
		backgroundImageView.image = recipe.image
		backgroundImageView.setNeedsDisplay()
	}

}
