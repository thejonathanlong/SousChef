//
//  RecipeComponentSelectionViewController.swift
//  SousChef
//
//  Created by Jonathan Long on 5/1/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit
import Photos

class RecipeComponentSelectionPageViewController: UIPageViewController {
	
	// MARK: - public properties
	var textSelectionAssets: [PHAsset] = [] {
		didSet {
			textIdentificationViewControllers = textSelectionAssets.map { (asset) -> TextIdentificationViewController in
				let textIdentificationViewController = TextIdentificationViewController(nibName: nil, bundle: nil)
				textIdentificationViewController.asset = asset
				return textIdentificationViewController
			}
			
			if let firstTextIdentificationViewController = textIdentificationViewControllers.first {
				self.setViewControllers([firstTextIdentificationViewController], direction: .forward, animated: true, completion: nil)
				nextViewController = firstTextIdentificationViewController
			}
			else {
				print("We didn't get any view controllers for the assets: \(textSelectionAssets)")
			}
			
		}
	}
	
	//MARK: - private properties
	private var textIdentificationViewControllers: [TextIdentificationViewController] = []
	
	private var currentViewControllerIndex = 0
	
	private var nextViewController: TextIdentificationViewController?
	
	//MARK: - overridden methods
	override func loadView() {
		super.loadView()
		
		delegate = self
		dataSource = self
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		nextViewController?.drawAggregatedRects()
	}
}

//MARK: - UIPageViewControllerDataSource
extension RecipeComponentSelectionPageViewController: UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		if let currentTextIdentificationViewController = viewController as? TextIdentificationViewController, let currentIndex = textIdentificationViewControllers.index(of: currentTextIdentificationViewController), currentIndex > 0 {
			return textIdentificationViewControllers[currentIndex - 1]
		}
		
		return nil
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?  {
		if let currentTextIdentificationViewController = viewController as? TextIdentificationViewController, let currentIndex = textIdentificationViewControllers.index(of: currentTextIdentificationViewController), currentIndex < textIdentificationViewControllers.count - 1 {
			return textIdentificationViewControllers[currentIndex + 1]
		}
		
		return nil
	}
	
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return textIdentificationViewControllers.count
	}
	
	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		return 0
	}
}

//MARK: - UIPageViewControllerDelegate
extension RecipeComponentSelectionPageViewController: UIPageViewControllerDelegate {
	
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		nextViewController?.drawAggregatedRects()
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
		nextViewController = pendingViewControllers.first as? TextIdentificationViewController
	}
}

//MARK: - TextIdentificationViewController
class TextIdentificationViewController: UIViewController {
	//MARK: - Public Properties
	var asset: PHAsset? {
		didSet {
			if let asset = asset {
				let options = PHImageRequestOptions()
				options.deliveryMode = .highQualityFormat
				options.isNetworkAccessAllowed = true
				PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: {[unowned self] image, _ in
					guard let image = image else { return }
					self.image = image
				})
			}
		}
	}
	
	//MARK: - Private Properties
	private var interestingAreaViews: [UIView] = []
	
	private let imageView = UIImageView()
	
	private var image: UIImage = UIImage() {
		didSet {
			self.imageView.image = image
		}
	}
	
	private var targetSize: CGSize {
		let scale = UIScreen.main.scale
		return CGSize(width: UIScreen.main.bounds.width * scale, height: UIScreen.main.bounds.height * scale)
	}
	
	private var aggregatedRects: [CGRect] = []
	
	private var didDrawAggregatedRects = false

	//MARK: - Overridden Methods
	override func loadView() {
		super.loadView()
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.isUserInteractionEnabled = false
		view.addSubview(imageView)
		
		let constraints = [
			imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0),
			imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0),
			]
		
		NSLayoutConstraint.activate(constraints)
		
		let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapHandler(sender:)))
		view.addGestureRecognizer(singleTapGestureRecognizer)
		
		let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler(sender:)))
		doubleTapGestureRecognizer.numberOfTapsRequired = 2
		view.addGestureRecognizer(doubleTapGestureRecognizer)
		
		let tripleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tripleTapHandler(sender:)))
		tripleTapGestureRecognizer.numberOfTapsRequired = 3
		view.addGestureRecognizer(tripleTapGestureRecognizer)
	}
}

// MARK: - Methods
extension TextIdentificationViewController {
	
	func drawAggregatedRects() {
		if !didDrawAggregatedRects {
			image.generateAggregatedWordRectsAsynchronously(in: imageView.frame) { [weak self] (aggregatedRects) in
				guard let strongSelf = self else { return }
				strongSelf.aggregatedRects = aggregatedRects
				DispatchQueue.main.async { [weak self] in
					guard let strongSelf = self else { return }
					for rect in strongSelf.aggregatedRects {
						let borderedView = BorderedView(frame: rect)
						strongSelf.view.addSubview(borderedView)
						strongSelf.interestingAreaViews.append(borderedView)
					}
				}
			}
		}
		didDrawAggregatedRects = true
	}
	
	func interestingViewContaining(point: CGPoint) -> UIView? {
		var tappedView: UIView? = nil
		for interestingView in interestingAreaViews {
			if interestingView.frame.contains(point) {
				tappedView = interestingView
				break;
			}
		}
		
		return tappedView
	}
}

//MARK: - Gesture handlers
extension TextIdentificationViewController {
	@objc func singleTapHandler(sender: UITapGestureRecognizer) {
		let pointInView = sender.location(in: self.view)
		let tappedView = interestingViewContaining(point:pointInView)
		if let tappedView = tappedView, tappedView.isKind(of: BorderedView.self) {
			let borderedView = tappedView as! BorderedView
			borderedView.borderColor = borderedView.borderColor == UIColor.black ? UIColor.yellow : UIColor.black
		}
	}
	
	@objc func doubleTapHandler(sender: UITapGestureRecognizer) {
		let pointInView = sender.location(in: self.view)
		let tappedView = interestingViewContaining(point:pointInView)
		if let tappedView = tappedView, tappedView.isKind(of: BorderedView.self) {
			let borderedView = tappedView as! BorderedView
			borderedView.borderColor = borderedView.borderColor == UIColor.black ? UIColor.green : UIColor.black
		}
	}
	
	@objc func tripleTapHandler(sender: UITapGestureRecognizer) {
		let pointInView = sender.location(in: self.view)
		let tappedView = interestingViewContaining(point:pointInView)
		if let tappedView = tappedView, tappedView.isKind(of: BorderedView.self) {
			let borderedView = tappedView as! BorderedView
			borderedView.borderColor = borderedView.borderColor == UIColor.black ? UIColor.blue : UIColor.black
		}
	}
}

//MARK: - BorderedView
class BorderedView: UIView {
	
	//MARK: - Public Properties
	var borderColor = UIColor.clear {
		didSet {
			layer.borderColor = borderColor.cgColor
		}
	}
	
	//MARK: Initializers
	override init(frame: CGRect) {
		frame.insetBy(dx: -2.0, dy: -2.0)
		super.init(frame: frame)
		layer.borderWidth = 2.0
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}

