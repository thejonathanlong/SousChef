//
//  Recipe.swift
//  Cooks
//
//  Created by Jonathan Long on 9/8/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import UIKit
import CloudKit

class Recipe: NSObject {
	//MARK: - CloudKit Record Keys
	static let recordNameKey = "name"
	static let recordIngredientsKey = "ingredients"
	static let recordInstructionsKey = "instructions"
	static let recordImageKey = "image"
	static let recordTagsKey = "tags"
	
	//MARK: - properties
	let name: String
	var ingredients: [Ingredient] = []
	let instructions: [String]
	let image: UIImage?
	let tags: [String]
	
	internal let ingredientRecordIDs: [CKRecordID]
	
	//MARK: - initializers
	override init() {
		self.name = ""
		self.tags = []
		self.instructions = []
		self.image = nil
		self.ingredientRecordIDs = []
		super.init()
	}
	
	init(name: String, ingredients: [Ingredient], instructions: [String], image: UIImage?, tags: [String]) {
		self.name = name
		self.instructions = instructions
		self.image = image
		self.tags = tags
		ingredientRecordIDs = []
		super.init()
	}
	
	
	
	init(record: CKRecord) {
		name = record[Recipe.recordNameKey] as! String
		if let references = record[Recipe.recordIngredientsKey] as? [CKReference] {
			var recordIDs : [CKRecordID] = []
			for ingredientReference in references {
				recordIDs.append(ingredientReference.recordID)
			}
			ingredientRecordIDs = recordIDs
		}
		else {
			ingredientRecordIDs = []
		}
		
		instructions = record[Recipe.recordInstructionsKey] as! [String]
		image = Recipe.recipeImage(record)
		
		tags = record[Recipe.recordTagsKey] != nil ? record[Recipe.recordTagsKey] as! [String] : []
		super.init()
	}
	
	//MARK: Helpers
	static func recipeImage(_ record: CKRecord) -> UIImage? {
		guard let asset = record[Recipe.recordImageKey] as? CKAsset else { return nil }
		
		do {
			let data = try Data(contentsOf: asset.fileURL)
			return UIImage(data: data)
		}
		catch {
			print("There was an error creating the data from the file \(asset.fileURL) - \(error)")
		}
		
		return nil
	}
	
	//MARK: Ingredient Interaction
	// This method might take a long time to finish...
	func loadAllIngredients() {
		loadIngredients(ingredientRecordIDs, shouldWaitForIngredientsToLoad: true)
	}
	
	func loadIngredients(_ recordIDs: [CKRecordID], shouldWaitForIngredientsToLoad: Bool) {
		let ingredientsFetchOperation = CKFetchRecordsOperation(recordIDs: recordIDs)
		let allIngredientsLoadedSemaphore = DispatchSemaphore(value: 0)
		
		if shouldWaitForIngredientsToLoad {
			ingredientsFetchOperation.fetchRecordsCompletionBlock = { [unowned self] recordsByRecordIDOrNil, errorOrNil in
				guard let recordsByRecordID = recordsByRecordIDOrNil else { print("There were no records for the ingredient record IDs."); return }
				
				for recordValue in recordsByRecordID.values {
					let ingredient = Ingredient(record: recordValue)
					self.ingredients.append(ingredient)
				}
				
				print("All ingredients loaded!")
				allIngredientsLoadedSemaphore.signal()
			}
			
			print("Waiting for all ingredients to load.")
			ingredientsFetchOperation.start()
			allIngredientsLoadedSemaphore.wait()
		}
		else {
			ingredientsFetchOperation.perRecordCompletionBlock = { [unowned self] recordOrNil, recordIDOrNil, errorOrNil in
				guard let ingredientRecord = recordOrNil else { print("record was nil for record ID \(String(describing: recordIDOrNil))"); return }
				
				let ingredient = Ingredient(record: ingredientRecord)
				self.ingredients.append(ingredient)
			}
			ingredientsFetchOperation.start()
		}
	}
}

// MARK: - Record from Recipe
extension Recipe {
	var record: CKRecord {
		let record = CKRecord(recordType: SousChefDatabase.recipeRecordType)
		record[Recipe.recordNameKey] = name as CKRecordValue
		record[Recipe.recordIngredientsKey] = ingredients as CKRecordValue
		record[Recipe.recordTagsKey] = tags as CKRecordValue
		record[Recipe.recordInstructionsKey] = instructions as CKRecordValue
		if let image = image {
			record[Recipe.recordImageKey] = image as? CKRecordValue
		}
		
		return record
	}
}
