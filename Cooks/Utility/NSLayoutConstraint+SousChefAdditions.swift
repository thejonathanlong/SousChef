//
//  File.swift
//  SousChef
//
//  Created by Jonathan Long on 1/17/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
	static func constraintsPinningEdges(of view1: UIView, toEdgesOf view2: UIView, insetBy inset: CGFloat) -> [NSLayoutConstraint]  {
		let constraints = [
			view1.leadingAnchor.constraint(equalTo: view2.safeAreaLayoutGuide.leadingAnchor, constant: inset),
			view1.trailingAnchor.constraint(equalTo: view2.safeAreaLayoutGuide.trailingAnchor, constant: inset),
			view1.topAnchor.constraint(equalTo: view2.safeAreaLayoutGuide.topAnchor, constant: inset),
			view1.bottomAnchor.constraint(equalTo: view2.safeAreaLayoutGuide.bottomAnchor, constant: inset),
		]
		
		return constraints
	}
	
	static func constraintsPinningEdges(of view1: UIView, toEdgesOf view2: UIView) -> [NSLayoutConstraint] {
		return NSLayoutConstraint.constraintsPinningEdges(of: view1, toEdgesOf: view2, insetBy: 0)
	}
}
