//
//  RecipeDetailsViewController.swift
//  Cooks
//
//  Created by Jonathan Long on 9/9/17.
//  Copyright © 2017 jlo. All rights reserved.
//

// MARK: Imports
import UIKit

// MARK: RecipeDeatilsViewController
class RecipeDetailsViewController: UITabBarController {
    
    var recipe = Recipe()
    
    override func loadView() {
        super.loadView()
        
        delegate = self
        selectedIndex = 0
        selectedViewController = viewControllers?.first
        
        if let viewController = selectedViewController {
            delegate?.tabBarController!(self, didSelect: viewController)
        }
    }
}

// MARK: UITabBarControllerDelegate
extension RecipeDetailsViewController : UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let ingredientDetailViewController = viewController as? IngredientsDetailViewController {
            ingredientDetailViewController.recipe = recipe
        }
        else if let instructionsViewController = viewController as? InstructionsDetailViewController {
            instructionsViewController.recipe = recipe
        }
    }
}
