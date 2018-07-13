//
//  TestData.swift
//  SousChef
//
//  Created by Jonathan Long on 1/18/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import Foundation
import UIKit

struct TestData {
	static let testInstructions = ["1. Set aside a 9- by 13-inch casserole dish.",
								   "2. For the yeast: In a small bowl, add the warm water. Make sure it’s not too hot; it should feel like warm bath water (approximately 110°F/45°C). Stir in the sugar until mostly dissolved. Now, stir in the yeast until dissolved. Set aside for about 6 to 7 minutes so the yeast can activate (it’ll look foamy when ready).",
								   "3. For the dough: Flour a working surface for later. Add 2 cups of flour into a large mixing bowl.",
								   "4. Melt 1/3 cup butter in a small saucepan over low heat. Remove the pot from the burner and stir in the almond milk, 1/3 cup sugar, and salt. The mixture should be lukewarm—if it’s any hotter let it cool off for a minute. Stir in all of the yeast mixture until just combined.",
								   "5. Pour the wet yeast mixture over the flour and stir with a large wooden spoon. Stop mixing once all of the flour is incorporated and it looks a bit like muffin batter, about 15 seconds.",
								   "6. Add in the remaining 1/2 cup and 3 tablespoons flour. Mix with a spoon for several seconds. Lightly oil your hands and roughly knead the mixture until it comes together into a shaggy, sticky dough. It’ll probably stick to your fingers (even with the oil), but that’s normal. Turn the dough out onto the floured surface.",
								   "7. Knead the dough for about 3 to 4 minutes until it’s no longer sticky to the touch; it should be smooth and elastic. While kneading, sprinkle on a small handful of flour whenever the dough becomes sticky to the touch. Don’t be afraid to add some flour; I probably use between 1/2 and 3/4 cup while kneading. Shape the dough into a ball.",
								   "8. Wash out the mixing bowl and dry it. Oil the bowl (I love to use a spray oil for ease) and place the ball of dough inside. Flip the dough around so it gets lightly coated in the oil. Tightly cover the bowl with plastic wrap and place it in the oven with the light on (or simply in a warm, draft-free area). Let the dough rise for 60 minutes.",
								   "9. Meanwhile, make the cinnamon sugar filling. In a small bowl, mix 1/2 cup sugar and the cinnamon and set aside.",]
	
	static let testIngredients = [Ingredient(measurementType: .cup, amount: 1, item: "sugar", original: "cane suger"),
								  Ingredient(measurementType: .cup, amount: 4, item: "flour", original: "all purpose white flour"),
								  Ingredient(measurementType: .teaspoon, amount: 1, item: "vanilla", original: "vanilla extract"),
								  Ingredient(measurementType: .gallon, amount: 0.5, item: "milk", original: "full fat delicious milk"),
								  Ingredient(measurementType: .cup, amount: 1, item: "sugar", original: "cane suger"),
								  Ingredient(measurementType: .cup, amount: 4, item: "flour", original: "all purpose white flour"),
								  Ingredient(measurementType: .teaspoon, amount: 1, item: "vanilla", original: "vanilla extract")]
	
	static let testRecipes = [
		Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: ""),
			Recipe(name: "Vegan Cinnamon Rolls", ingredients: TestData.testIngredients, instructions: TestData.testInstructions, image: UIImage(named: "vcr"), tags: [], source: "")
	]
}
