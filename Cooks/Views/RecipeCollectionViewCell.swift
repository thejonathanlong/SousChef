//
//  RecipeCollectionViewCell.swift
//  SousChef
//
//  Created by Jonathan Long on 1/17/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
	let titleLabel = UILabel()
	
	
	func commonInit() {
		clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		
		
		imageView.contentMode = .scaleAspectFill
		titleLabel.font = SousChefStyling.preferredFont(for: .subheadline)
		titleLabel.textColor = SousChefStyling.lightColor
		
		let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
		visualEffectView.translatesAutoresizingMaskIntoConstraints = false
		
		contentView.addSubview(imageView)
		contentView.addSubview(visualEffectView)
		contentView.addSubview(titleLabel)
		
		var constraints: [NSLayoutConstraint] = []
		
		let imageViewPinningConstraints = NSLayoutConstraint.constraintsPinningEdges(of: imageView, toEdgesOf: contentView)
		constraints.append(contentsOf: imageViewPinningConstraints)
		constraints.append(imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 200))
		constraints.append(imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 300))
		
		
		let titleLabelConstraints = [titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SousChefStyling.standardMargin),
									 titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SousChefStyling.standardMargin),
									 visualEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
									 visualEffectView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
									 visualEffectView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
									 visualEffectView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor)]
		constraints.append(contentsOf: titleLabelConstraints)
		
		NSLayoutConstraint.activate(constraints)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	override func prepareForReuse() {
		imageView.image = nil
		titleLabel.text = ""
	}
}
