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
	
	var recipes: [Recipe] = TestData.testRecipes {
		didSet {
			// Update based on the new recipe that was given
			recipesDidChange()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: AllRecipesCollectionViewController.recipeCollectionViewCellReuseIdentifier)
		collectionView!.contentInset = UIEdgeInsets(top: 25.0, left: 50.0, bottom: 25.0, right: 50.0)
		
		let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
		flowLayout.estimatedItemSize = CGSize(width: 1.0, height: 1.0)
		flowLayout.minimumInteritemSpacing = 25
		flowLayout.minimumLineSpacing = 25
		flowLayout.scrollDirection = .horizontal
		
		self.view.backgroundColor = SousChefStyling.lightColor
		
		let addRecipeButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecipe))
		addRecipeButtonItem.tintColor = SousChefStyling.darkColor
		self.navigationItem.setRightBarButton(addRecipeButtonItem, animated: true)
    }
	
	func recipesDidChange() {
		//Update because the recipes changed...
	}
	
	@objc func addRecipe() {
		
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
	
}
