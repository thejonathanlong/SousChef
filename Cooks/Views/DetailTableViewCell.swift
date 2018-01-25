//
//  IngredientTableViewCell.swift
//  Cooks
//
//  Created by Jonathan Long on 12/9/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
	let mainTextLabel = UILabel()
	let subTextLabel = UILabel()
	
	static let mainTextLabelFont = SousChefStyling.preferredFont(for: .body)
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
		subTextLabel.translatesAutoresizingMaskIntoConstraints = false
		
		mainTextLabel.numberOfLines = 0		
		mainTextLabel.font = DetailTableViewCell.mainTextLabelFont
		mainTextLabel.textColor = SousChefStyling.darkColor
		addSubview(mainTextLabel)
		addSubview(subTextLabel)
		
		let constraints = [
			mainTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
			subTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
			mainTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
			subTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
			mainTextLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
			subTextLabel.topAnchor.constraint(equalTo: mainTextLabel.bottomAnchor, constant: 2)
		]
		NSLayoutConstraint.activate(constraints)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit() {
		
		mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
		subTextLabel.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(mainTextLabel)
		addSubview(subTextLabel)
		
		let constraints = [
			mainTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
			subTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
			mainTextLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
			subTextLabel.topAnchor.constraint(equalTo: mainTextLabel.bottomAnchor, constant: 2)
		]
		NSLayoutConstraint.activate(constraints)
	}
	
	override func prepareForReuse() {
		mainTextLabel.text = ""
		subTextLabel.text = ""
	}
}
