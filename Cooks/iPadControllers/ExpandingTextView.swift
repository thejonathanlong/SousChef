////
////  ExpandingTextViewController.swift
////  SousChef
////
////  Created by Jonathan Long on 1/27/18.
////  Copyright © 2018 jlo. All rights reserved.
////
//
//import UIKit
//
//class HeaderView1: UIView {
//	
//	let headerLabel = UILabel()
//	
//	required init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//		commonInit()
//	}
//	
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//		commonInit()
//	}
//	
//	convenience init() {
//		self.init(frame: .zero)
//	}
//	
//	func commonInit() {
//		headerLabel.translatesAutoresizingMaskIntoConstraints = false
//		headerLabel.font = SousChefStyling.preferredFont(for: .headline)
//		headerLabel.textColor = SousChefStyling.darkColor
//		addSubview(headerLabel)
//		let constraints = NSLayoutConstraint.constraintsPinningEdges(of: headerLabel, toEdgesOf: self)
//		NSLayoutConstraint.activate(constraints)
//	}
//}
//
//class ExpandingTextView: UIView, UITextViewDelegate {
//	
//	// MARK: - Private interface
//	private let headerView = HeaderView()
//	private let textView = UITextView()
//	private var textViewHeightConstraint = NSLayoutConstraint()
//	private let contentStackView = UIStackView()
//	
//	// MARK: - Public interface
//	var headerTitle = "" {
//		didSet {
//			headerView.headerLabel.text = headerTitle
//		}
//	}
//	
//	var isExpanded = false {
//		didSet (newValue) {
//			newValue ? expand(animated: true) : contract(animated: true)
//		}
//	}
//	
//	var text = "" {
//		didSet {
//			textView.text = text
//			textViewDidChange(textView)
//		}
//	}
//	
//	// MARK: - Initializers
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//		commonInit()
//	}
//	
//	required init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//		commonInit()
//	}
//	
//	convenience init() {
//		self.init(frame: .zero)
//	}
//	
//	func commonInit() {
//		// This needs to be set for the animation to work... ??
//		clipsToBounds = true
//		
//		headerView.translatesAutoresizingMaskIntoConstraints = false
//		textView.translatesAutoresizingMaskIntoConstraints = false
//		contentStackView.translatesAutoresizingMaskIntoConstraints = false
//		
//		textView.backgroundColor = UIColor.clear
//		textView.delegate = self
//		
//		contentStackView.alignment = .leading
//		contentStackView.axis = .vertical
//		contentStackView.distribution = .fill
//		
//		contentStackView.addArrangedSubview(headerView)
//		contentStackView.addArrangedSubview(textView)
//		addSubview(contentStackView)
//		
//		
//		textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 25)
//		let constraints = [
//			contentStackView.widthAnchor.constraint(equalTo: self.widthAnchor),
//			contentStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//			contentStackView.topAnchor.constraint(equalTo: self.topAnchor),
//			contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//			textView.widthAnchor.constraint(equalTo: self.widthAnchor),
//			textView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
//			textViewHeightConstraint
//			]
//		
//		NSLayoutConstraint.activate(constraints)
//	}
//	
//	// MARK: - Layout
//	override func layoutSubviews() {
//		super.layoutSubviews()
//		textViewDidChange(textView)
//	}
//}
//
////MARK: - Actions
//extension ExpandingTextView {
//	
//	func contract(animated: Bool) {
//		let animationDuration = animated ? 0.3 : 0.0
//		UIView.animate(withDuration: animationDuration) {
//			self.textView.isHidden = true
//		}
//	}
//	
//	func expand(animated: Bool) {
//		let animationDuration = animated ? 0.3 : 0.0
//		UIView.animate(withDuration: animationDuration) {
//			self.textView.isHidden = false
//		}
//	}
//}
//
////MARK: - UITextViewDelegate
//extension ExpandingTextView {
//	
//	func textViewDidChange(_ textView: UITextView) {
//		let width = self.frame.width
//		let newSize = textView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
//		textViewHeightConstraint.isActive = false
//		textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: newSize.height)
//		textViewHeightConstraint.isActive = true
//	}
//}
//
