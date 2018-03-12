//
//  FloatingButtonNavigationController.swift
//  SousChef
//
//  Created by Jonathan Long on 2/4/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit
import MessageUI

class FloatingButtonNavigationController: UINavigationController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {

	let floatingButtonStack = UIStackView()
	let backButton = SousChefButton(frame: .zero)
	let bugButton = SousChefButton(frame: .zero)
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
		backButton.isHidden = true
		
		let bugButtonImage = UIImage(named: "Bug")!
		bugButton.setImage(bugButtonImage, for: .normal)
		bugButton.addTarget(self, action: #selector(reportBug), for: .primaryActionTriggered)
		bugButton.translatesAutoresizingMaskIntoConstraints = false
		
		dummyView.translatesAutoresizingMaskIntoConstraints = false
		
		floatingButtonStack.addArrangedSubview(dummyView)
		floatingButtonStack.addArrangedSubview(backButton)
		floatingButtonStack.addArrangedSubview(bugButton)
		
		view.addSubview(floatingButtonStack)

		let constraint = [
			floatingButtonStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: SousChefStyling.standardMargin),
			floatingButtonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -SousChefStyling.standardMargin),
			floatingButtonStack.heightAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonHeight),
			dummyView.widthAnchor.constraint(equalToConstant: 1),
			dummyView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
			backButton.widthAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonWidth),
			backButton.heightAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonHeight),
			bugButton.widthAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonWidth),
			bugButton.heightAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonHeight),
			
		]
		
		NSLayoutConstraint.activate(constraint)
	}
	
	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		if let topViewController = self.topViewController {
			removeFloatingButtons(for: topViewController, viewControllerCount: self.viewControllers.count + 1)
		}
		super.pushViewController(viewController, animated: animated)
	}
	
	override func popViewController(animated: Bool) -> UIViewController? {
		if let viewController = super.popViewController(animated: animated) {
			removeFloatingButtons(for: viewController, viewControllerCount: self.viewControllers.count - 1)
			return viewController
		}
		return nil
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// Without this call the stackView animates in from the top left...
		self.viewIfLoaded?.layoutIfNeeded()
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
	
	func removeFloatingButtons(for viewController: UIViewController, viewControllerCount: Int) {
		UIView.animate(withDuration: 0.33) {
			self.buttonsForViewController[viewController]?.forEach({ $0.removeFromSuperview() })
			self.backButton.isHidden = viewControllerCount <= 1
			self.view.layoutIfNeeded()
		}
	}
}

// MARK: - Button Actions
extension FloatingButtonNavigationController {
	@objc func goBack() {
		let _ = popViewController(animated: true)
	}
	
	@objc func reportBug() {
		if MFMailComposeViewController.canSendMail() {
			let mailComposeViewController = MFMailComposeViewController()
			let timeInterval = NSDate().timeIntervalSince1970
			mailComposeViewController.setSubject("Bug SC://\(timeInterval)")
			mailComposeViewController.setToRecipients(["sue.souschef@gmail.com"])
			mailComposeViewController.mailComposeDelegate = self
			if let screenCap = screenshot(), let screenCapData = UIImageJPEGRepresentation(screenCap, 1.0) {
				mailComposeViewController.addAttachmentData(screenCapData, mimeType: "image/jpeg", fileName: "screenCap-\(timeInterval).jpg")
			}
			
			if let topVC = topViewController {
				topVC.present(mailComposeViewController, animated: true, completion: nil)
			}
		}
		else {
		}
	}
	
	//Utility
	func screenshot() -> UIImage? {
		if let topViewController = topViewController {
			let size = topViewController.view.frame.size
			UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
			topViewController.view.drawHierarchy(in: topViewController.view.frame, afterScreenUpdates: true)
			let image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			return image
		}
		
		return nil
	}
}

// MARK: - MFMailComposeViewControllerDelegate
extension FloatingButtonNavigationController {
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true, completion: nil)
	}
}
