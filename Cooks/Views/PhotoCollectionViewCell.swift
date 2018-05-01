//
//  PhotoCollectionViewCell.swift
//  SousChef
//
//  Created by Jonathan Long on 4/28/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
	var imageView = UIImageView()
	var selectedImageView = UIImageView()
	
	var representedAssetIdentifier: String!
	
	var thumbnailImage: UIImage! {
		didSet {
			imageView.image = thumbnailImage
			imageView.contentMode = .scaleAspectFit
			imageView.frame = contentView.frame
		}
	}
	
	override var isSelected: Bool {
		didSet {
			imageView.layer.borderWidth = isSelected ? 2.0 : 0.0
			imageView.layer.borderColor = UIColor.yellow.cgColor
		}
	}
	
	//MARK: - init
	override func layoutSubviews() {
		if imageView.superview == nil {
			contentView.addSubview(imageView)
		}
		
		if selectedImageView.superview == nil {
			imageView.addSubview(selectedImageView)
		}
		super.layoutSubviews()
	}
	
	//MAKR: - View life cycle
	override func prepareForReuse() {
		super.prepareForReuse()
		thumbnailImage = nil
		selectedImageView.image = nil
		isSelected = false
	}
}
