//
//  Recipe.swift
//  Cooks
//
//  Created by Jonathan Long on 9/8/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import UIKit

struct Recipe {	
    let name: String
    let ingredients: [Ingredient]
    let instructions: [String]
    let image: UIImage?
    let tags: [String]
	
    init() {
        name = ""
        ingredients = []
        instructions = []
		tags = []
        image = nil
    }
	
	init(name: String, ingredients: [Ingredient], instructions: [String], image: UIImage?, tags: [String]) {
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.image = image
		self.tags = tags
    }
}
