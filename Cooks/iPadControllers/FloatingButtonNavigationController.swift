//
//  FloatingButtonNavigationController.swift
//  SousChef
//
//  Created by Jonathan Long on 2/4/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit

class FloatingButtonNavigationController: UINavigationController, UINavigationControllerDelegate {

	let floatingButtonStack = UIStackView()
	let backButton = SousChefButton(frame: .zero)
	// Without the dummyView the stackView animates weird when hiding and unhiding the buttons.
	let dummyView = UIView()
	
	var buttonsForViewController = [UIViewController : [SousChefButton]]()
	
	override init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		commonInit()
	}
	
	override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
		super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
		commonInit()
	}
	
	func commonInit() {
		delegate = self
		view.clipsToBounds = true
		floatingButtonStack.axis = .horizontal
		floatingButtonStack.distribution = .equalSpacing
		floatingButtonStack.alignment = .fill
		floatingButtonStack.spacing = 5.0
		floatingButtonStack.translatesAutoresizingMaskIntoConstraints = false
		
		let backButtonImage = UIImage(named: "BackArrow")!
		backButton.setImage(backButtonImage, for: .normal)
		backButton.addTarget(self, action: #selector(goBack), for: .primaryActionTriggered)
		backButton.translatesAutoresizingMaskIntoConstraints = false
		
		dummyView.translatesAutoresizingMaskIntoConstraints = false
		
		floatingButtonStack.addArrangedSubview(dummyView)
		floatingButtonStack.addArrangedSubview(backButton)
		view.addSubview(floatingButtonStack)
		
		let constraint = [
			floatingButtonStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: SousChefStyling.standardMargin),
			floatingButtonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -SousChefStyling.standardMargin),
			dummyView.widthAnchor.constraint(equalToConstant: 1),
			backButton.widthAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonWidth),
			backButton.heightAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonHeight)
		]
		
		NSLayoutConstraint.activate(constraint)
	}
	
	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		if let topViewController = self.topViewController {
			removeFloatingButtons(for: topViewController)
		}
		super.pushViewController(viewController, animated: animated)
	}
	
	override func popViewController(animated: Bool) -> UIViewController? {
		if let viewController = super.popViewController(animated: animated) {
			removeFloatingButtons(for: viewController)
			return viewController
		}
		return nil
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		let pleaseSignIntoTheCloudAlertController = UIAlertController(title: "Please Sign into iCloud", message: "In order for Sous Chef to work properly you need to be signed into iCloud. You can do this in System Preferences.", preferredStyle: .alert)
//		let isSignedIntoTheCloud = FileManager.default.ubiquityIdentityToken != nil
//		if !isSignedIntoTheCloud {
////			pushViewController(pleaseSignIntoTheCloudAlertController, animated: true)
//			topViewController?.present(pleaseSignIntoTheCloudAlertController, animated: true, completion: nil)
//		} else if presentedViewController == pleaseSignIntoTheCloudAlertController {
////			popViewController(animated: true)
//			pleaseSignIntoTheCloudAlertController.dismiss(animated: true, completion: nil)
//		}
	}
}

// MARK: - Floating Button Stack Additions
extension FloatingButtonNavigationController {
	
	func addFloatingButton(image: UIImage?, target: Any, action: Selector, viewController: UIViewController?) {
		let floatingButton = SousChefButton(frame: .zero)
		floatingButton.setImage(image, for: .normal)
		floatingButton.addTarget(target, action: action, for: .primaryActionTriggered)
		floatingButton.translatesAutoresizingMaskIntoConstraints = false
		
		let constraints = [
			floatingButton.widthAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonWidth),
			floatingButton.heightAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonHeight)
		]
		NSLayoutConstraint.activate(constraints)
		floatingButtonStack.addArrangedSubview(floatingButton)
		
		if let vc = viewController {
			if !buttonsForViewController.keys.contains(vc) {
				buttonsForViewController[vc] = []
			}
			buttonsForViewController[vc]?.append(floatingButton)
		}
	}
	
	func addFloatingButton(title: String, target: Any, action: Selector, viewController: UIViewController?) {
		let floatingButton = SousChefButton(frame: .zero)
		floatingButton.setTitle(title, for: .normal)
		floatingButton.addTarget(target, action: action, for: .primaryActionTriggered)
		floatingButton.translatesAutoresizingMaskIntoConstraints = false
		
		let constraints = [
			floatingButton.widthAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonWidth),
			floatingButton.heightAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonHeight)
		]
		NSLayoutConstraint.activate(constraints)
		UIView.animate(withDuration: 0.33) {
			self.floatingButtonStack.addArrangedSubview(floatingButton)
			self.view.layoutIfNeeded()
		}
		
		
		if let vc = viewController {
			if !buttonsForViewController.keys.contains(vc) {
				buttonsForViewController[vc] = []
			}
			buttonsForViewController[vc]?.append(floatingButton)
		}
	}
	
	func removeFloatingButtons(for viewController: UIViewController) {
		UIView.animate(withDuration: 0.33) {
			self.buttonsForViewController[viewController]?.forEach({ $0.removeFromSuperview() })
			self.view.layoutIfNeeded()
		}
	}
}

// Button Actions
extension FloatingButtonNavigationController {
	@objc func goBack() {
		popViewController(animated: true)
	}
}

// MARK: - UINavigationControllerDelegate
extension FloatingButtonNavigationController {
	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		UIView.animate(withDuration: 0.33) {
			self.backButton.isHidden = self.viewControllers.count <= 1
			self.view.layoutIfNeeded()
		}
	}
}
