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
		let sizeConstraint = CGSize(width: tableView.frame.size.width - (SousChefStyling.standardMargin * 2), height: .greatestFiniteMagnitude)
		let attributes = [NSAttributedStringKey.font : SousChefStyling.preferredFont(for: .headline)]
		let boundingSize = NSString(string: headerText).boundingRect(with: sizeConstraint, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil).size
		headerLabel.frame = CGRect(x: 0.0, y: 0.0, width: boundingSize.width, height: boundingSize.height)
		
		return headerLabel
	}()
	
	lazy var tableHeaderView: UIView = {
		let headerView = UIView()
		
		let headerDivider = UIView()
		headerDivider.backgroundColor = UIColor.almostBlack
		headerDivider.alpha = 0.75
		
		headerView.addSubview(tableHeaderLabel)
		headerView.addSubview(headerDivider)
		
		headerView.frame = CGRect(x: SousChefStyling.standardMargin, y: 0.0, width: tableView.frame.width, height: tableHeaderLabel.frame.height)
		headerDivider.frame = CGRect(x: 0.0, y: tableHeaderLabel.frame.height + 3, width: headerView.frame.width, height: 1.5)
		
		return headerView
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
		tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: IngredientTableViewController.baseTableViewCellReuseIdentifier)
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
		tableView.tableHeaderView = tableHeaderView
	}
}
