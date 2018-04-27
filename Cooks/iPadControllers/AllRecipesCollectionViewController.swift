//
//  AllRecipesCollectionViewController.swift
//  SousChef
//
//  Created by Jonathan Long on 1/17/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit

class AllRecipesCollectionViewController: UICollectionViewController {
	static let recipeCollectionViewCellReuseIdentifier = "recipeCollectionViewCellReuseIdentifier"
	
	var recipes: [Recipe] = [] {
		didSet {
			// Update based on the new recipe that was given
			recipesDidChange()
		}
	}
	
	private let database = SousChefDatabase.shared
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
//		database.recipes { (recipes) in
//			DispatchQueue.main.async {
//				self.recipes = recipes
//			}
//		}
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		collectionView?.backgroundColor = UIColor.white
        collectionView!.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: AllRecipesCollectionViewController.recipeCollectionViewCellReuseIdentifier)
		collectionView!.contentInset = UIEdgeInsets(top: 25.0, left: 50.0, bottom: 25.0, right: 50.0)
		
		let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
		flowLayout.estimatedItemSize = CGSize(width: 1.0, height: 1.0)
		flowLayout.minimumInteritemSpacing = 25
		flowLayout.minimumLineSpacing = 25
		flowLayout.scrollDirection = .horizontal
		
		self.view.backgroundColor = SousChefStyling.lightColor
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if let baseNavigationController = navigationController as? FloatingButtonNavigationController {
			baseNavigationController.addFloatingButton(image: UIImage(named: "Add"), target: self, action: #selector(addRecipe), viewController: self)
		}
		database.recipes { (recipes) in
			DispatchQueue.main.async {
				self.recipes = recipes
			}
		}
	}
	
	func recipesDidChange() {
		//Update because the recipes changed...
		DispatchQueue.main.async {
			self.collectionView?.reloadData()
		}
		
	}
	
	@objc func addRecipe() {
		let vc = AddRecipeViewController(nibName: nil, bundle: nil)
		
//		vc.titleLabel.text = "Tell me the ingredient list"
		navigationController?.pushViewController(vc, animated: true)
	}
}

// MARK: UICollectionViewDataSource
extension AllRecipesCollectionViewController {
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return recipes.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllRecipesCollectionViewController.recipeCollectionViewCellReuseIdentifier, for: indexPath) as! RecipeCollectionViewCell
		let recipe = recipes[indexPath.row]
		
		cell.imageView.image = recipe.image
		cell.titleLabel.text = recipe.name
		
		return cell
	}
}

// MARK: UICollectionViewDelegate
extension AllRecipesCollectionViewController {
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let recipe = recipes[indexPath.row]
		let recipeDetailViewController = RecipeDetailViewController(nibName: nil, bundle: nil)
		recipeDetailViewController.recipe = recipe
		
		navigationController?.pushViewController(recipeDetailViewController, animated: true)
	}
	
}
