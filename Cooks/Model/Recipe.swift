//
//  Recipe.swift
//  Cooks
//
//  Created by Jonathan Long on 9/8/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import UIKit
import CloudKit

struct Recipe {	
    let name: String
	var ingredients: [Ingredient] {
		get {
			return mutableIngredients
		}
	}
    let instructions: [String]
    let image: UIImage?
    let tags: [String]
	
	internal var mutableIngredients: [Ingredient] = []
	internal let ingredientRecordIDs: [CKRecordID]
	
    init() {
        name = ""
		ingredientRecordIDs = []
        instructions = []
		tags = []
        image = nil
    }
	
	init(name: String, ingredients: [Ingredient], instructions: [String], image: UIImage?, tags: [String]) {
        self.name = name
        self.instructions = instructions
        self.image = image
		self.tags = tags
		ingredientRecordIDs = []
    }
}
