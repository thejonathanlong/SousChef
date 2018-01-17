////
////  InstructionTableViewCell.swift
////  Cooks
////
////  Created by Jonathan Long on 1/10/18.
////  Copyright © 2018 jlo. All rights reserved.
////
//
//import UIKit
//
//class InstructionTableViewCell: UITableViewCell {
//
//	let mainTextLabel = UILabel()
//	let subTextLabel = UILabel()
//	
//	var didActivateConstraints = false
//	
//	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//		super.init(style: style, reuseIdentifier: reuseIdentifier)
//		
//		mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
//		subTextLabel.translatesAutoresizingMaskIntoConstraints = false
//		
////		mainTextLabel.font = UIFont.preferredFont(forTextStyle: .body)
////		subTextLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
//		
//		addSubview(mainTextLabel)
//		addSubview(subTextLabel)
//		
//		let constraints = [
//			mainTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//			subTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//			mainTextLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
//			subTextLabel.topAnchor.constraint(equalTo: mainTextLabel.bottomAnchor, constant: 2)
//		]
//		NSLayoutConstraint.activate(constraints)
//	}
//	
//	required init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//		commonInit()
//	}
//	
//	func commonInit() {
//		
//		mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
//		subTextLabel.translatesAutoresizingMaskIntoConstraints = false
//		
//		addSubview(mainTextLabel)
//		addSubview(subTextLabel)
//		
//		let constraints = [
//			mainTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
//			subTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//			mainTextLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
//			subTextLabel.topAnchor.constraint(equalTo: mainTextLabel.bottomAnchor, constant: 2)
//		]
//		NSLayoutConstraint.activate(constraints)
//	}
//	
//	override func prepareForReuse() {
//		mainTextLabel.text = ""
//		subTextLabel.text = ""
//	}
//
//}

