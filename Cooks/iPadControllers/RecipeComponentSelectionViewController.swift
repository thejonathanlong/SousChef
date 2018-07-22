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
                textIdentificationViewController.instructionAreaViews = instructionAreaViews
                textIdentificationViewController.ingredientAreaViews = ingredientAreaViews
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
    
    private var instructionAreaViews: [UIView] = []
    
    private var ingredientAreaViews: [UIView] = []
	
	//MARK: - overridden methods
	override func loadView() {
		super.loadView()
		
		delegate = self
		dataSource = self
        
        if let floatingNavigationController = navigationController as? FloatingButtonNavigationController {
            let tapInstructionsLabel = UILabel()
            tapInstructionsLabel.numberOfLines = 3
            tapInstructionsLabel.text = "Tap once on the areas that represent ingredients.\nTap twice on the areas the represent th recipe directions.\nTap three times on the areas that represent other information."
            tapInstructionsLabel.translatesAutoresizingMaskIntoConstraints = false
            
            floatingNavigationController.contentView.addSubview(tapInstructionsLabel)
            
            let tapInstructionConstraints = [
                tapInstructionsLabel.topAnchor.constraint(equalTo: floatingNavigationController.contentView.topAnchor),
                tapInstructionsLabel.bottomAnchor.constraint(equalTo: floatingNavigationController.contentView.bottomAnchor),
                tapInstructionsLabel.leftAnchor.constraint(equalTo: floatingNavigationController.contentView.leftAnchor),
                tapInstructionsLabel.rightAnchor.constraint(equalTo: floatingNavigationController.contentView.rightAnchor),
            ]
            
            NSLayoutConstraint.activate(tapInstructionConstraints)
        }
	}
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let baseNavigationController = navigationController as? FloatingButtonNavigationController {
            baseNavigationController.addTrailingFloatingButton(title: "Next", image: nil, target: self, action: #selector(next(sender:)), viewController: self)
        }
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		nextViewController?.drawAggregatedRects()
	}
}

//MARK: - Actions
extension RecipeComponentSelectionPageViewController {
    @objc func next(sender: SousChefButton) {
        // Send all of this to the detail view for processing and stuff....
        let addRecipeViewController = AddRecipeViewController(nibName: nil, bundle: nil)
        var ingredientImages = [UIImage]()
        var instructionImages = [UIImage]()
        textIdentificationViewControllers.forEach { ingredientImages.append(contentsOf: $0.ingredientAreaViewImages) }
        textIdentificationViewControllers.forEach { instructionImages.append(contentsOf: $0.instructionAreaViewImages) }
        
        addRecipeViewController.ingredientImageRepresentations = ingredientImages
        addRecipeViewController.instructionImageRepresentations = instructionImages
        navigationController?.pushViewController(addRecipeViewController, animated: true)
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

                let removeMe = "REMOVE THE LINE BELOW THIS. IT IS FOR TESTING ONLY."
                  self.image = UIImage(named:"TestPhoto6")
//                PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: {[unowned self] image, _ in
//                    guard let image = image else { return }
//                    self.image = image
//                    self.image = UIImage(named:"TestPhoto6")
//                })
			}
		}
	}
    
    var ingredientAreaViewImages: [UIImage] {
        ingredientAreaViews.sort(by: { CGRect.sortedTopToBottomLeftToRight(rect1: $0.frame, rect2: $1.frame) })
        let images = ingredientAreaViews.map { (view) -> UIImage in
            if let borderedView = view as? BorderedView, let image = self.borderedViewImages[borderedView] {
                return image
            }
            
            return UIImage()
        }
        return images
    }
    
    var instructionAreaViewImages: [UIImage] {
        instructionAreaViews.sort(by: { CGRect.sortedTopToBottomLeftToRight(rect1: $0.frame, rect2: $1.frame) })
        let images = instructionAreaViews.map { (view) -> UIImage in
            if let borderedView = view as? BorderedView, let image = self.borderedViewImages[borderedView] {
                return image
            }
            
            return UIImage()
        }
        return images
    }
	
    //MARK: - fileprivate
    fileprivate var ingredientAreaViews: [UIView] = []
    
    fileprivate var instructionAreaViews: [UIView] = []
    
	//MARK: - Private Properties
	private var interestingAreaViews: [UIView] = []
	
	private let imageView = UIImageView()
	
	private var image: UIImage? {
		set {
            self.imageView.image = UIImage(named: "TestPhoto6")
		}
        get {
            return imageView.image
        }
	}
	
	private var targetSize: CGSize {
		let scale = UIScreen.main.scale
		return CGSize(width: UIScreen.main.bounds.width * scale, height: UIScreen.main.bounds.height * scale)
	}
	
	private var aggregatedRectangleObservations: [TextRectangleObservation] = []
    
    private var borderedViewImages: [BorderedView : UIImage] = [:]
	
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
        
        singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
		
//        let tripleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tripleTapHandler(sender:)))
//        tripleTapGestureRecognizer.numberOfTapsRequired = 3
//        view.addGestureRecognizer(tripleTapGestureRecognizer)
	}
}

// MARK: - Methods
extension TextIdentificationViewController {
	
	func drawAggregatedRects() {
		if !didDrawAggregatedRects, let image = image {
			image.generateAggregatedWordRectsAsynchronously(in: imageView.frame) { [weak self] (aggregatedRects) in
				guard let strongSelf = self else { return }
				strongSelf.aggregatedRectangleObservations = aggregatedRects
				DispatchQueue.main.async { [weak self] in
					guard let strongSelf = self else { return }
					for rectangleObservation in strongSelf.aggregatedRectangleObservations {
						let borderedView = BorderedView(frame: rectangleObservation.rect)
						strongSelf.view.addSubview(borderedView)
						strongSelf.interestingAreaViews.append(borderedView)
                        if let image = strongSelf.image, let cgImage = image.cgImage {
                            let normalizedRect = rectangleObservation.normalizedRect
                            let rectInImageCoordinates = CGRect(x: normalizedRect.minX * image.size.width, y: normalizedRect.minY * image.size.height, width: normalizedRect.width * image.size.width, height: normalizedRect.height * image.size.height).insetBy(dx: -5, dy: -5)
                            guard let croppedCGImage = cgImage.cropping(to: rectInImageCoordinates) else { print("Failed to crop CGImage to \(rectInImageCoordinates)."); return }
                            strongSelf.borderedViewImages[borderedView] = UIImage(cgImage: croppedCGImage)
                        }
					}
				}
			}
		}
		didDrawAggregatedRects = true
	}
    
}

//MARK: - Private Methods
extension TextIdentificationViewController {
    private func interestingViewContaining(point: CGPoint) -> UIView? {
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
		guard let borderedView = tappedView as? BorderedView else { print("The tapped view was not a \(BorderedView.self)"); return }
        
        borderedView.toggleSelected(borderColor: UIColor.yellow)
        if let borderedViewIndex = ingredientAreaViews.index(of: borderedView) {
            ingredientAreaViews.remove(at: borderedViewIndex)
        } else {
            ingredientAreaViews.append(borderedView)
        }
	}
	
	@objc func doubleTapHandler(sender: UITapGestureRecognizer) {
		let pointInView = sender.location(in: self.view)
		let tappedView = interestingViewContaining(point:pointInView)
        guard let borderedView = tappedView as? BorderedView else { print("The tapped view was not a \(BorderedView.self)"); return }
        
        borderedView.toggleSelected(borderColor: UIColor.green)
        if let borderedViewIndex = instructionAreaViews.index(of: borderedView) {
            instructionAreaViews.remove(at: borderedViewIndex)
        } else {
            instructionAreaViews.append(borderedView)
        }
	}
	
	@objc func tripleTapHandler(sender: UITapGestureRecognizer) {
		let pointInView = sender.location(in: self.view)
		let tappedView = interestingViewContaining(point:pointInView)
		if let tappedView = tappedView, tappedView.isKind(of: BorderedView.self) {
			let borderedView = tappedView as! BorderedView
            borderedView.isSelected = !borderedView.isSelected
		}
	}
}

//MARK: - BorderedView
class BorderedView: UIView {
	
	//MARK: - Public Properties
    var selectedBorderColor = UIColor.clear
    var borderColor = UIColor.black
    var isSelected = false {
        didSet {
            layer.borderColor = isSelected ? selectedBorderColor.cgColor : borderColor.cgColor
        }
    }
	
	//MARK: Initializers
	override init(frame: CGRect) {
		frame.insetBy(dx: -2.0, dy: -2.0)
		super.init(frame: frame)
		layer.borderWidth = 2.0
        borderColor = UIColor.black
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}

//MARK: - Methods
extension BorderedView {
    func toggleSelected(borderColor: UIColor) {
        selectedBorderColor = borderColor
        isSelected = !isSelected
    }
}

