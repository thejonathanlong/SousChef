//
//  BaseTableViewController.swift
//  SousChef
//
//  Created by Jonathan Long on 1/16/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
	//MARK: static
	static let baseTableViewCellReuseIdentifier = "baseTableViewCellReuseIdentifier"
	
	lazy var headerText: String = {
		//Subclasses should override
		return ""
	}()
	
	lazy var tableHeaderLabel: UILabel = {
		let headerLabel = UILabel()
		headerLabel.textAlignment = .right
		headerLabel.text = headerText
		headerLabel.font = SousChefStyling.preferredFont(for: .headline)
		let sizeConstraint = CGSize(width: tableView.frame.size.width - (SousChefStyling.smallestAllowableMargin * 2), height: .greatestFiniteMagnitude)
		let attributes = [NSAttributedStringKey.font : SousChefStyling.preferredFont(for: .headline)]
		let boundingSize = NSString(string: headerText).boundingRect(with: sizeConstraint, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil).size
		headerLabel.frame = CGRect(x: SousChefStyling.smallestAllowableMargin, y: 0.0, width: boundingSize.width - SousChefStyling.smallestAllowableMargin, height: boundingSize.height)
		
		return headerLabel
	}()
	
	//MARK: - Init
	override init(style: UITableViewStyle) {
		super.init(style: style)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit() {
		tableView.register(IngredientTableViewCell.self, forCellReuseIdentifier: IngredientTableViewController.baseTableViewCellReuseIdentifier)
	}
	
	//MARK: UITableViewDelegate
	override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return false
	}
	
	//MARK: - UIViewController
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.separatorColor = UIColor.clear
		tableView.showsVerticalScrollIndicator = false
		tableView.tableHeaderView = tableHeaderLabel
	}
}
