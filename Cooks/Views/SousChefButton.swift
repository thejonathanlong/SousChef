//
//  SousChefButton.swift
//  SousChef
//
//  Created by Jonathan Long on 2/7/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit

// Circular button with the ability to change the background color for the highlighted state
class SousChefButton: UIButton {
	
	var backgroundColors = [NSNumber : UIColor]()
	
	override open var isHighlighted: Bool {
		didSet {
			let highlightedNumber = NSNumber(value: UIControlState.highlighted.rawValue)
			let normalNumber = NSNumber(value: UIControlState.normal.rawValue)
			if isHighlighted && backgroundColors.keys.contains(highlightedNumber) {
				backgroundColor = backgroundColors[highlightedNumber]
			}
			else if !isHighlighted && backgroundColors.keys.contains(normalNumber) {
				backgroundColor = backgroundColors[normalNumber]
			}
		}
	}
	
	override open var isSelected: Bool {
		didSet {
			let selectedNumber = NSNumber(value: UIControlState.selected.rawValue)
			let normalNumber = NSNumber(value: UIControlState.normal.rawValue)
			if isSelected && backgroundColors.keys.contains(selectedNumber) {
				backgroundColor = backgroundColors[selectedNumber]
			}
			else if !isSelected && backgroundColors.keys.contains(normalNumber) {
				backgroundColor = backgroundColors[normalNumber]
			}
		}
	}
	
	func commonInit() {
		setBackgroundColor(SousChefStyling.lightColor, for: .normal)
		setBackgroundColor(UIColor.powderBlue, for: .highlighted)
		layer.borderColor = UIColor.powderBlue.cgColor
		layer.borderWidth = 2.0
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	func setBackgroundColor(_ color: UIColor, for state: UIControlState) {
		backgroundColors[NSNumber(value: state.rawValue)] = color
		if state == .normal {
			backgroundColor = color
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = bounds.size.width / 2.0
	}
}
