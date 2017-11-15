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
    let image: UIImage
    
    init() {
        name = ""
        ingredients = []
        instructions = []
        image = UIImage()
    }
    
    init(name: String, ingredients: [Ingredient], instructions: [String], image: UIImage) {
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.image = image
    }
}

struct Ingredient {
    
    let measurement: Measurement
    
    let item: String
    
    let original: String
    
    static let usMeasurementLemma = Set(["pound", "gallon", "ounce", "quart", "cup", "pint", "tablespoon", "teaspoon", "dash", "pinch", "can", "lb", "oz", "c", "tbsp", "tsp"])
    
    static let metricMeasurementLemma = Set(["liter", "gram", "milliliter", "kilogram", "g", "l", "ml", "kg"])
    
    var description: String {
        return "\(measurement.amount) \(measurement.type) \(item)"
    }
//    init(taggedIngredient: TaggedIngredient) {
//        self.init(measurementType: <#T##MeasurementType#>, amount: <#T##Float#>, item: <#T##String#>, original: <#T##String#>)
//    }
    
    init(measurementType: MeasurementType, amount: Double, item: String, original: String) {
        
        switch measurementType {
        case .can:
            measurement = CanMeasurement(amount: amount)

        case .cup:
            measurement = CupMeasurement(amount: amount)

        case .teaspoon:
            measurement = TeaspoonMeasurement(amount: amount)

        case .tablespoon:
            measurement = TablespoonMeasurement(amount: amount)

        case .gallon:
            measurement = GallonMeasurement(amount: amount)

        case .ounce:
            measurement = OunceMeasurement(amount: amount)

        case .quart:
            measurement = QuartMeasurement(amount: amount)

		case .other:
            measurement = OtherMeasurement(amount: amount)
			
		case .pound:
			measurement = PoundMeasurement(amount: amount)
			
		}
        
        self.item = item
        self.original = original
    }
    
    
    
}

//struct SampleData {
//    static let recipes = [
//        Recipe(name: "8-Minute Pantry Dal",
//               ingredients: [
//                Ingredient(measurement:TablespoonMeasurement(amount:1.0), item: "virgin coconut oil", original: "heaping tablespoon"),
//                Ingredient(measurement:CupMeasurement(amount:4.0), item: "veggies", original: "peeled and diced"),
//                Ingredient(measurement:CupMeasurement(amount:0.5), item: "red lentils", original: "uncooked"),
//                Ingredient(measurement:CupMeasurement(amount:0.5), item: "water", original: "more if needed"),
//                Ingredient(measurement:OunceMeasurement(amount:14), item: "diced tomatoes", original: ""),
//                Ingredient(measurement:OunceMeasurement(amount:14), item: "light coconut milk", original: ""),
//                Ingredient(measurement:TeaspoonMeasurement(amount:1.5), item: "garlic powder", original: ""),
//                Ingredient(measurement:TeaspoonMeasurement(amount:1.5), item: "onion", original: "minced"),
//                Ingredient(measurement:TablespoonMeasurement(amount:1), item: "curry powder", original: ""),
//                Ingredient(measurement:TeaspoonMeasurement(amount:1), item: "salt", original: ""),
//                Ingredient(measurement:TeaspoonMeasurement(amount:0), item: "freshly ground black pepper", original: ""),
//                ],
//               instructions: ["In a large pot, melt the coconut oil over low-medium heat.",
//                              "Peel (if necessary) and dice the veggies into 1/2-inch pieces. Add them into the pot and stir until combined. Increase heat to medium.",
//                              "Add in the rest of the ingredients (lentils, water, diced tomatoes [with juices], coconut milk, all the spices, salt, and pepper). Stir until combined.",
//                              "Increase heat to high and bring to a low boil. Reduce heat to medium and cook, uncovered, for 18 to 30 minutes, until the veggies and lentils are tender; the cook time will depend on the types of veggies you use, and their size. Stir the dal frequently while cooking, and reduce the heat if necessary to prevent it from sticking to the pot. (If you’re using potatoes, I suggest covering the pot while cooking since they don’t contain as much water to “cook off”. You may need to add more water to thin the mixture.)",
//                              "If desired, serve over rice, and garnish with cilantro and lime (it’s still great without these additions, though!)"],
//               image: UIImage(named: "8minutepantrydal-7675.jpg")!)
//    ]
//}

