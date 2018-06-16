//
//  AddWorkFlowControllers.swift
//  SousChef
//
//  Created by Jonathan Long on 4/7/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import Foundation
import UIKit

class TextTypeSelectionViewController: UIViewController {
	
	var image: UIImage? {
		didSet {
			self.imageView.image = image
		}
	}
	
	private let imageView = UIImageView(image: UIImage(named: "TestPhoto5"))
	
	override func loadView() {
		super.loadView()
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .topLeft
		view.addSubview(imageView)
		
		let constraints = [
			imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		]
		NSLayoutConstraint.activate(constraints)
		if let img = imageView.image {
			let rects = img.aggregatedWordRects(in: imageView.frame)
			
			for rect in rects {
				let layer = CALayer()
				print("rect: \(rect)")
				layer.frame = rect
				layer.borderColor = UIColor.purple.cgColor
				layer.borderWidth = 2.0
				imageView.layer.addSublayer(layer)
			}
		}
		
	}
	
	
}
