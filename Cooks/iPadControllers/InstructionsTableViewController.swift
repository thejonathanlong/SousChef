//
//  InstructionsTableViewController.swift
//  Cooks
//
//  Created by Jonathan Long on 1/10/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit

class InstructionsTableViewController: BaseTableViewController {
	static let instructionCellVerticalPadding = CGFloat(7.5)
	
	var instructions: [String] = []
	
	override lazy var headerText: String = {
		return "Directions"
	}()
}

// MARK: - Table view data source
extension InstructionsTableViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return instructions.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: InstructionsTableViewController.baseTableViewCellReuseIdentifier, for: indexPath) as! DetailTableViewCell
		
		cell.mainTextLabel.text = String(format:"%d %@", indexPath.row + 1, instructions[indexPath.row]) 
		//		cell.mainTextLabel.preferredMaxLayoutWidth = 200
		cell.backgroundColor = UIColor.clear
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let instruction = instructions[indexPath.row]
		let sizeConstraint = CGSize(width: tableView.frame.size.width - 20, height: .greatestFiniteMagnitude)
		let labelFont = SousChefStyling.preferredFont(for: .body)
		let attributes = [NSAttributedStringKey.font : labelFont]
		let boundingSize = NSString(string: instruction).boundingRect(with: sizeConstraint, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil).size
		
		return ceil(boundingSize.height) + (InstructionsTableViewController.instructionCellVerticalPadding * 2.0)
	}
	
}
