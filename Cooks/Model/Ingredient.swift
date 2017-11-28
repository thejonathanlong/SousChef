//
//  Ingredient.swift
//  Cooks
//
//  Created by Jonathan Long on 11/14/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import Foundation

struct Ingredient {
	let measurement: Measurement
	let item: String
	let original: String
	static let usMeasurementLemma = Set(["pound", "gallon", "ounce", "quart", "cup", "pint", "tablespoon", "teaspoon", "dash", "pinch", "can", "lb", "oz", "c", "tbsp", "tsp"])
	static let metricMeasurementLemma = Set(["liter", "gram", "milliliter", "kilogram", "g", "l", "ml", "kg"])
	
	var description: String {
		return "\(measurement.amount) \(measurement.type) \(item)"
	}
	
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
