//
//  RecipeDetailViewController.swift
//  Cooks
//
//  Created by Jonathan Long on 12/7/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
	static let instructionTableViewWidthMultipler: CGFloat = 0.275
	
	var recipe = Recipe() {
		didSet {
			// Update based on the new recipe that was given
			recipeDidChange()
		}
	}
	
	private let scrollView = UIScrollView()
	private let backgroundImageView = UIImageView()
	private let slidingView = UIView()
	private let slidingViewVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
	private let contentView = UIView()
	private let recipeTitleLabel = UILabel()
	private let database = SousChefDatabase.shared
	
	private let ingredientViewController = IngredientTableViewController(style: .plain)
	private let instructionViewController = InstructionsTableViewController(style: .plain)
	
	override func loadView() {
		super.loadView()
		
		if let theView = self.view, let ingredientTableView = ingredientViewController.view, let instructionTableView = instructionViewController.view {
			backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
			scrollView.translatesAutoresizingMaskIntoConstraints = false
			slidingView.translatesAutoresizingMaskIntoConstraints = false
			ingredientTableView.translatesAutoresizingMaskIntoConstraints = false
			instructionTableView.translatesAutoresizingMaskIntoConstraints = false
			slidingViewVisualEffectView.translatesAutoresizingMaskIntoConstraints = false
			contentView.translatesAutoresizingMaskIntoConstraints = false
			recipeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
			
			theView.addSubview(backgroundImageView)
			theView.addSubview(scrollView)
			
			scrollView.addSubview(slidingView)
			scrollView.addSubview(recipeTitleLabel)
			
			slidingView.addSubview(slidingViewVisualEffectView)
			slidingView.addSubview(contentView)
			
			addChildViewController(ingredientViewController)
			contentView.addSubview(ingredientTableView)
			ingredientViewController.didMove(toParentViewController: self)
			
			addChildViewController(instructionViewController)
			contentView.addSubview(instructionTableView)
			instructionViewController.didMove(toParentViewController: self)
			
			slidingView.backgroundColor = UIColor.clear
			ingredientTableView.backgroundColor = UIColor.clear
			instructionTableView.backgroundColor = UIColor.clear
			contentView.backgroundColor = UIColor.linen
			scrollView.backgroundColor = UIColor.clear // clear so you can see the image behind it
			scrollView.bounces = false
			scrollView.showsHorizontalScrollIndicator = false
			scrollView.contentInset = UIEdgeInsets(top: 0.0, left: (theView.frame.width * (1 - RecipeDetailViewController.instructionTableViewWidthMultipler)) - 18.0, bottom: 0.0, right: 0.0)
			
			backgroundImageView.contentMode = .scaleAspectFill
			backgroundImageView.clipsToBounds = true
			
			recipeTitleLabel.font = SousChefStyling.preferredFont(for: .title1)
			recipeTitleLabel.textColor = UIColor.whiteSmoke
			
			let constraints = [backgroundImageView.leadingAnchor.constraint(equalTo: theView.leadingAnchor),
							   backgroundImageView.centerYAnchor.constraint(equalTo: theView.centerYAnchor),
							   backgroundImageView.widthAnchor.constraint(equalTo: theView.widthAnchor),
							   backgroundImageView.topAnchor.constraint(equalTo: theView.topAnchor),
							   backgroundImageView.bottomAnchor.constraint(equalTo: theView.bottomAnchor),
							   scrollView.centerXAnchor.constraint(equalTo: theView.centerXAnchor),
							   scrollView.widthAnchor.constraint(equalTo: theView.widthAnchor),
							   scrollView.topAnchor.constraint(equalTo: theView.topAnchor),
							   scrollView.bottomAnchor.constraint(equalTo: theView.bottomAnchor),
							   slidingView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
							   slidingView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
							   slidingView.topAnchor.constraint(equalTo: scrollView.topAnchor),
							   slidingView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
							   slidingView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
							   slidingView.widthAnchor.constraint(equalTo: theView.widthAnchor),
							   contentView.centerXAnchor.constraint(equalTo: slidingView.centerXAnchor),
							   contentView.centerYAnchor.constraint(equalTo: slidingView.centerYAnchor),
							   contentView.widthAnchor.constraint(equalTo: theView.widthAnchor),
							   contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.85),
							   ingredientTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SousChefStyling.standardMargin),
							   ingredientTableView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: RecipeDetailViewController.instructionTableViewWidthMultipler),
							   ingredientTableView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.67),
							   ingredientTableView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
							   instructionTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SousChefStyling.standardMargin),
							   instructionTableView.leadingAnchor.constraint(equalTo: ingredientTableView.trailingAnchor, constant: SousChefStyling.standardMargin),
							   instructionTableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SousChefStyling.standardMargin),
							   instructionTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SousChefStyling.standardMargin),
							   recipeTitleLabel.leadingAnchor.constraint(equalTo: theView.leadingAnchor, constant: 25.0),
							   recipeTitleLabel.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -SousChefStyling.standardMargin),
							   slidingViewVisualEffectView.centerXAnchor.constraint(equalTo: slidingView.centerXAnchor),
							   slidingViewVisualEffectView.centerYAnchor.constraint(equalTo: slidingView.centerYAnchor),
							   slidingViewVisualEffectView.widthAnchor.constraint(equalTo: slidingView.widthAnchor),
							   slidingViewVisualEffectView.heightAnchor.constraint(equalTo: slidingView.heightAnchor),
			]
			
			NSLayoutConstraint.activate(constraints)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		instructionViewController.instructions = recipe.instructions
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let baseNavigationController = navigationController as? FloatingButtonNavigationController {
			baseNavigationController.addLeadingFloatingButton(title: nil, image: UIImage(named: "Trash"), target: self, action: #selector(deleteRecipe(sender:)), viewController: self)
			baseNavigationController.addTrailingFloatingButton(title: nil, image: UIImage(named: "Share"), target: self, action: #selector(shareRecipe(sender:)), viewController: self)
		}
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		scrollView.contentInset = UIEdgeInsets(top: 0, left: (size.width * (1 - RecipeDetailViewController.instructionTableViewWidthMultipler)) - 18.0, bottom: 0, right: 0)
	}
	
	// The recipe has changed so update the content appropriately
	func recipeDidChange() {
		if recipe.ingredients.isEmpty {
			database.ingredients(for: recipe) { (ingredients) in
				DispatchQueue.main.async {
					self.recipe.ingredients = ingredients
					self.ingredientViewController.ingredients = ingredients
					self.ingredientViewController.tableView.reloadData()
				}
			}
		}
		else {
			self.ingredientViewController.ingredients = recipe.ingredients
			self.ingredientViewController.tableView.reloadData()
		}
		
		recipeTitleLabel.text = recipe.name
		backgroundImageView.image = recipe.image
		backgroundImageView.setNeedsDisplay()
	}
}

//MARK: Button Actions
extension RecipeDetailViewController {
	
	@objc func deleteRecipe(sender: UIButton) {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alertController.modalPresentationStyle = .popover
		alertController.popoverPresentationController?.sourceView = sender
		alertController.popoverPresentationController?.sourceRect = sender.frame
		
		let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
			SousChefDatabase.shared.delete(recipe: self.recipe) { (recordIDOrNil, errorOrNil) in
				if let error = errorOrNil { print("There was an error trying to delete the recipe: \(self.recipe) - \(error)"); return }
				guard let recordID = recordIDOrNil else { print("No record Id when delete recipe \(self.recipe)"...); return; }

				print("Deleted recipe \(self.recipe) with ID \(recordID)")
			}
			DispatchQueue.main.async {
				self.navigationController?.popViewController(animated: true)
			}
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
			DispatchQueue.main.async {
				self.navigationController?.popViewController(animated: true)
				
			}
		}
		
		alertController.addAction(deleteAction)
		alertController.addAction(cancelAction)
		
		present(alertController, animated: true, completion: nil)
	}
	
	@objc func shareRecipe(sender: UIButton) {
//		let cloudSharingController = UICloudSharingController { (sharingController, <#(CKShare?, CKContainer?, Error?) -> Void#>) in
//			<#code#>
//		}
	}
}

