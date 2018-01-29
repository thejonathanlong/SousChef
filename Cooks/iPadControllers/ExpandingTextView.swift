//
//  ExpandingTextViewController.swift
//  SousChef
//
//  Created by Jonathan Long on 1/27/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit

class HeaderView: UIView {
	let headerLabel = UILabel()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	convenience init() {
		self.init(frame: .zero)
	}
	
	func commonInit() {
		headerLabel.translatesAutoresizingMaskIntoConstraints = false
		headerLabel.font = SousChefStyling.preferredFont(for: .headline)
		headerLabel.textColor = SousChefStyling.darkColor
		addSubview(headerLabel)
		let constraints = NSLayoutConstraint.constraintsPinningEdges(of: headerLabel, toEdgesOf: self)
		NSLayoutConstraint.activate(constraints)
	}
	
	override var intrinsicContentSize: CGSize {
		return headerLabel.intrinsicContentSize
	}
}

// It is the clients responsibility to shrink this view. The internal Views should shrink appropriately.
class ExpandingTextView: UIView {
	// MARK: - Private interface
	private let headerView = HeaderView()
	private let textView = UITextView()
	private var contentStackViewHeightConstraint = NSLayoutConstraint()
	private let contentStackView = UIStackView()
	
	// MARK: - Public interface
	var headerTitle = "" {
		didSet {
			headerView.headerLabel.text = headerTitle
		}
	}
	
	var isExpanded = true {
		didSet {
			isExpanded ? expand() : contract()
		}
	}
	
	var text = "" {
		didSet {
			textView.text = text
		}
	}
	
	override var intrinsicContentSize: CGSize {
		return contentStackView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	convenience init() {
		self.init(frame: .zero)
	}
	
	func commonInit() {
		
		headerView.translatesAutoresizingMaskIntoConstraints = false
		headerView.headerLabel.setContentHuggingPriority(.required, for: .vertical)
		textView.backgroundColor = UIColor.clear
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.text = "The Texas Longhorns football program is the intercollegiate team representing the University of Texas at Austin (variously Texas or UT) in the sport of American football. The Longhorns compete in the NCAA Division I Football Bowl Subdivision (formerly Division I-A) as a member of the Big 12 Conference. The team is coached by Tom Herman and home games are played at Darrell K Royal–Texas Memorial Stadium in Austin, Texas."
		
		contentStackView.translatesAutoresizingMaskIntoConstraints = false
		contentStackView.axis = .vertical
		contentStackView.alignment = .leading
		contentStackView.distribution = .fillProportionally
		
		contentStackView.addArrangedSubview(headerView)
		contentStackView.addArrangedSubview(textView)
		addSubview(contentStackView)
		
		
		contentStackViewHeightConstraint = contentStackView.heightAnchor.constraint(equalTo: self.heightAnchor)
		let constraints = [
			contentStackView.widthAnchor.constraint(equalTo: self.widthAnchor),
			contentStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			contentStackView.topAnchor.constraint(equalTo: self.topAnchor),
			contentStackViewHeightConstraint,
			textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 25),
			textView.widthAnchor.constraint(equalTo: self.widthAnchor),
			]
		
		NSLayoutConstraint.activate(constraints)
	}
	
	func contract() {
		textView.isHidden = true
//		contentStackViewHeightConstraint.isActive = false
//		contentStackViewHeightConstraint = contentStackView.heightAnchor.constraint(equalToConstant: headerView.intrinsicContentSize.height)
//		contentStackViewHeightConstraint.isActive = true
	}
	
	func expand() {
		textView.isHidden = false
//		contentStackViewHeightConstraint.isActive = false
//		contentStackViewHeightConstraint = contentStackView.heightAnchor.constraint(equalTo: self.heightAnchor)
//		contentStackViewHeightConstraint.isActive = true
	}
}

