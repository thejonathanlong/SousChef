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
        return .none
    }
}

//struct NoneMeasurement : Measurement {
//    var amount: Float
//
//
//    internal var amount : Double {
//        return 0
//    }
//
//    var type: MeasurementType {
//        return .none
//    }
//}

struct UnknownMeasurement : Measurement {
    internal var amount : Double
    
    var type : MeasurementType {
        return .none
    }
}

struct CupMeasurement : Measurement {
    
    internal var amount : Double
    
    var type : MeasurementType {
        return .cup
    }
    
    static func +<T: Measurement>(left : CupMeasurement, right : T) -> CupMeasurement {
        //Right now we will assume they have to be the same types
        assert(left.type == right.type)
        return CupMeasurement(amount: left.amount + right.amount)
    }
}

struct GallonMeasurement : Measurement {
    
    internal var amount : Double
    
    var type : MeasurementType {
        return .gallon
    }
    
    static func +<T: Measurement>(left : GallonMeasurement, right : T) -> GallonMeasurement {
        //Right now we will assume they have to be the same types
        assert(left.type == right.type)
        return GallonMeasurement(amount: left.amount + right.amount)
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

struct MeasurementValues {
    static let ouncesPerCup = 8
    static let ouncesPerTablespoon = 0.5
    static let ouncesPerTeaspoon = 0.16667
    static let cupsPerQuart = 4
    static let quartsPerGallon = 4
    
}
enum MeasurementType : String {
    case cup = "cup"
    case teaspoon = "teaspoon"
    case tablespoon = "tablespoon"
    case quart = "quart"
    case gallon = "gallon"
    case can = "can"
    case ounce = "ounce"
    case none = ""
    
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
