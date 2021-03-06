//
//  SousChefStyling.swift
//  SousChef
//
//  Created by Jonathan Long on 1/16/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import Foundation
import UIKit

struct SousChefStyling {
}

//MARK - Font
extension SousChefStyling {
	static let defaultFontName = "Didot"
	static let defaultBoldFontName = "Didot-Bold"
	
//	static let defaultFontName = "PingFangTC-Regular"
//	static let defaultBoldFontName = "PingFangTC-Semibold"
	
	static func preferredFont(for textStyle: UIFontTextStyle) -> UIFont {
		switch textStyle {
		case .body:
			guard let font = UIFont(name: SousChefStyling.defaultFontName, size: 16) else {
				print("Default font (\(SousChefStyling.defaultFontName)) was not loaded for some reason.. using systems default")
				return UIFont.preferredFont(forTextStyle: textStyle)
			}
			return font
		
		case .title1:
			guard let font = UIFont(name: SousChefStyling.defaultBoldFontName, size: 32) else {
				print("Default font (\(SousChefStyling.defaultFontName)) was not loaded for some reason.. using systems default")
				return UIFont.preferredFont(forTextStyle: textStyle)
			}
			return font
			
		case .headline:
			guard let font = UIFont(name: SousChefStyling.defaultFontName, size: 24) else {
				print("Default font (\(SousChefStyling.defaultFontName)) was not loaded for some reason.. using systems default")
				return UIFont.preferredFont(forTextStyle: textStyle)
			}
			return font
		
		case .subheadline:
			guard let font = UIFont(name: SousChefStyling.defaultBoldFontName, size: 20) else {
				print("Default font (\(SousChefStyling.defaultFontName)) was not loaded for some reason.. using systems default")
				return UIFont.preferredFont(forTextStyle: textStyle)
			}
			return font
		
		default:
			return UIFont.preferredFont(forTextStyle: textStyle)
		}
	}
}

//MARK - Color
extension SousChefStyling {
	static let lightColor = UIColor.whiteSmoke
	static let darkColor = UIColor.almostBlack
	static let highlightColor = UIColor.powderBlue
}

//MARK - Margins
extension SousChefStyling {
	static let veryLargeMargin: CGFloat = 65.0
	static let largeMargin: CGFloat = 25.0
	static let standardMargin: CGFloat = 10.0
	static let smallestMargin: CGFloat = SousChefStyling.standardMargin/2.0
}

//MARK: - Assets
extension SousChefStyling {
	static let calendarImage = UIImage(named: "calendar-3")
}

//MARK: - Layout
extension SousChefStyling {
	static let navigationFloatingButtonWidth: CGFloat = 50.0
	static let navigationFloatingButtonHeight: CGFloat = 50.0
}
