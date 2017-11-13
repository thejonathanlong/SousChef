//
//  Measurement.swift
//  Cooks
//
//  Created by Jonathan Long on 9/9/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import UIKit

protocol Measurement {
	
	var type : MeasurementType { get }
	
	var amount : Double { get set }
	
	//    init(amount: Float)
}

extension Measurement {
	
	var type : MeasurementType {
		return .other
	}
}

func ==<T: Measurement>(lhs: T, rhs: T) -> Bool {
	return lhs.type == rhs.type && lhs.amount == rhs.amount
}

struct CupMeasurement : Measurement {
	
	internal var amount : Double
	
	var type : MeasurementType {
		return .cup
	}
	
	static func +<T: Measurement>(left : CupMeasurement, right : T) -> CupMeasurement {
		assert(right.type != .pound)
		assert(right.type != .other)
		
		var amountToAdd = right.amount
		switch right.type {
		case .gallon:
			amountToAdd *= (MeasurementValues.cupsPerQuart * MeasurementValues.quartsPerGallon)
		case .ounce:
			amountToAdd *= (1/MeasurementValues.ouncesPerCup)
		case .quart:
			amountToAdd *= MeasurementValues.cupsPerQuart
		case .tablespoon:
			amountToAdd *= MeasurementValues.ouncesPerTablespoon * (1/MeasurementValues.ouncesPerCup)
		case .teaspoon:
			amountToAdd *= MeasurementValues.ouncesPerTeaspoon * (1/MeasurementValues.ouncesPerCup)
		default:
			print(right.type.rawValue)
			break
		}
		
		return CupMeasurement(amount: left.amount + amountToAdd)
	}
}

struct GallonMeasurement : Measurement {
	
	internal var amount : Double
	
	var type : MeasurementType {
		return .gallon
	}
	
	static func +<T: Measurement>(left : GallonMeasurement, right : T) -> GallonMeasurement {
		assert(right.type != .pound)
		assert(right.type != .other)
		
		var amountToAdd = right.amount
		switch right.type {
		case .cup:
			amountToAdd *= (1/MeasurementValues.cupsPerQuart * 1/MeasurementValues.quartsPerGallon)
		case .ounce:
			amountToAdd *= (1/MeasurementValues.ouncesPerCup) * (1/MeasurementValues.cupsPerQuart * 1/MeasurementValues.quartsPerGallon)
		case .quart:
			amountToAdd *= MeasurementValues.quartsPerGallon
		case .tablespoon:
			amountToAdd *= MeasurementValues.ouncesPerTablespoon * (1/MeasurementValues.ouncesPerCup) * (1/MeasurementValues.cupsPerQuart * 1/MeasurementValues.quartsPerGallon)
		case .teaspoon:
			amountToAdd *= MeasurementValues.ouncesPerTeaspoon * (1/MeasurementValues.ouncesPerCup) * (1/MeasurementValues.cupsPerQuart * 1/MeasurementValues.quartsPerGallon)
		default:
			print(right.type.rawValue)
			break
		}
		
		return GallonMeasurement(amount: left.amount + amountToAdd)
	}
}

struct QuartMeasurement : Measurement {
	
	internal var amount : Double
	
	var type : MeasurementType {
		return .quart
	}
	
	static func +<T: Measurement>(left : QuartMeasurement, right : T) -> QuartMeasurement {
		//Right now we will assume they have to be the same types
		assert(left.type == right.type)
		return QuartMeasurement(amount: left.amount + right.amount)
	}
}

struct TablespoonMeasurement : Measurement {
	internal var amount : Double
	
	var type : MeasurementType {
		return .tablespoon
	}
	
	static func +<T: Measurement>(left : TablespoonMeasurement, right : T) -> TablespoonMeasurement {
		//Right now we will assume they have to be the same types
		assert(left.type == right.type)
		return TablespoonMeasurement(amount: left.amount + right.amount)
	}
}

struct TeaspoonMeasurement : Measurement {
	internal var amount : Double
	
	var type : MeasurementType {
		return .teaspoon
	}
	
	static func +<T: Measurement>(left : TeaspoonMeasurement, right : T) -> TeaspoonMeasurement {
		//Right now we will assume they have to be the same types
		assert(left.type == right.type)
		return TeaspoonMeasurement(amount: left.amount + right.amount)
	}
}

struct CanMeasurement : Measurement {
	internal var amount : Double
	
	var type : MeasurementType {
		return .can
	}
	
	static func +<T: Measurement>(left : CanMeasurement, right : T) -> CanMeasurement {
		//Right now we will assume they have to be the same types
		assert(left.type == right.type)
		return CanMeasurement(amount: left.amount + right.amount)
	}
}

struct OunceMeasurement : Measurement {
	internal var amount : Double
	
	var type : MeasurementType {
		return .ounce
	}
	
	static func +<T: Measurement>(left : OunceMeasurement, right : T) -> OunceMeasurement {
		//Right now we will assume they have to be the same types
		assert(left.type == right.type)
		return OunceMeasurement(amount: left.amount + right.amount)
	}
}

struct PoundMeasurement: Measurement {
	internal var amount: Double
	
	var type: MeasurementType {
		return .pound
	}
	
	static func +<T: Measurement>(left : PoundMeasurement, right : T) -> PoundMeasurement {
		//Right now we will assume they have to be the same types
		assert(left.type == right.type)
		return PoundMeasurement(amount: left.amount + right.amount)
	}
}

struct OtherMeasurement: Measurement {
	internal var amount: Double
	
	var type: MeasurementType {
		return .other
	}
	
	static func +<T: Measurement>(left : OtherMeasurement, right : T) -> OtherMeasurement {
		//Right now we will assume they have to be the same types
		assert(left.type == right.type)
		return OtherMeasurement(amount: left.amount + right.amount)
	}
}

struct MeasurementValues {
	static let ouncesPerCup = 8.0
	static let ouncesPerTablespoon = 0.5
	static let ouncesPerTeaspoon = 0.16667
	static let cupsPerQuart = 4.0
	static let quartsPerGallon = 4.0
}

enum MeasurementType : String {
	case cup = "cup"
	case teaspoon = "teaspoon"
	case tablespoon = "tablespoon"
	case quart = "quart"
	case gallon = "gallon"
	case can = "can"
	case ounce = "ounce"
	case other = "other"
	case pound = "pound"
	
	init(abbreviation: String) {
		switch abbreviation.lowercased() {
		case "c":
			self = .cup
		case "tbps":
			self = .tablespoon
		case "tsp":
			self = .teaspoon
		case "oz":
			self = .ounce
		case "lb":
			self = .pound
		default:
			self = MeasurementType(rawValue: abbreviation)!
		}
	}
	
	//    func max(left : MeasurementType, right : MeasurementType) -> MeasurementType {
	//        switch left {
	//        case .cup:
	//            right == .teaspoon || right == .tablespoon ||
	//        case .teaspoon:
	//        case .tablespoon:
	//        case .quart:
	//        case .gallon:
	//        case .can:
	//        case .ounce:
	//
	//        default:
	//            return right
	//        }
	//    }
	//
	//    func min(left : MeasurementType, right : MeasurementType) -> MeasurementType {
	//
	//    }
	
}
