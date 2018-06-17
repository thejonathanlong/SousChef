//
//  FloatingButtonNavigationController.swift
//  SousChef
//
//  Created by Jonathan Long on 2/4/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit
import MessageUI

//MARK: FloatingButtonNavigationController
class FloatingButtonNavigationController: UINavigationController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {

	//MARK: - Public properties
	let contentView = UIView()
	
	// MARK: - Private properties
	private let containingStackView = UIStackView()
	
	private let leadingFloatingButtonStack = UIStackView()
	
	private let trailingFloatingButtonStack = UIStackView()
	
	private let backButton = SousChefButton(frame: .zero)
	
	private var buttonsForViewController = [UIViewController : [SousChefButton]]()
	
	// MARK: - Initializers
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
		if self.leadingFloatingButtonStack.arrangedSubviews.count > 0 && self.trailingFloatingButtonStack.arrangedSubviews.count > 0 {
			return
		}
		
		delegate = self
		view.clipsToBounds = true
		leadingFloatingButtonStack.axis = .horizontal
		leadingFloatingButtonStack.distribution = .equalSpacing
		leadingFloatingButtonStack.alignment = .fill
		leadingFloatingButtonStack.spacing = 5.0
		leadingFloatingButtonStack.translatesAutoresizingMaskIntoConstraints = false
		
		trailingFloatingButtonStack.axis = .horizontal
		trailingFloatingButtonStack.distribution = .equalSpacing
		trailingFloatingButtonStack.alignment = .fill
		trailingFloatingButtonStack.spacing = 5.0
		trailingFloatingButtonStack.translatesAutoresizingMaskIntoConstraints = false
		
		let backButtonImage = UIImage(named: "BackArrow")!
		backButton.setImage(backButtonImage, for: .normal)
		backButton.addTarget(self, action: #selector(goBack), for: .primaryActionTriggered)
		backButton.translatesAutoresizingMaskIntoConstraints = false
		backButton.isHidden = true
		
		let bugButton = SousChefButton(frame: .zero)
		let bugButtonImage = UIImage(named: "Bug")!
		bugButton.setImage(bugButtonImage, for: .normal)
		bugButton.addTarget(self, action: #selector(reportBug), for: .primaryActionTriggered)
		bugButton.translatesAutoresizingMaskIntoConstraints = false
		
		// Without the dummyView the stackView animates weird when hiding and unhiding the buttons.
		let leadingDummyView = UIView()
		leadingDummyView.translatesAutoresizingMaskIntoConstraints = false
		
		let trailingDummyView = UIView()
		trailingDummyView.translatesAutoresizingMaskIntoConstraints = false
		
		leadingFloatingButtonStack.addArrangedSubview(leadingDummyView)
		leadingFloatingButtonStack.addArrangedSubview(backButton)
		leadingFloatingButtonStack.addArrangedSubview(bugButton)
		
		trailingFloatingButtonStack.addArrangedSubview(trailingDummyView)
		
		containingStackView.axis = .horizontal
		containingStackView.alignment = .center
		containingStackView.translatesAutoresizingMaskIntoConstraints = false
		
		containingStackView.addArrangedSubview(leadingFloatingButtonStack)
		containingStackView.addArrangedSubview(contentView)
		containingStackView.addArrangedSubview(trailingFloatingButtonStack)

		contentView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(containingStackView)
		
		let constraint = [
			containingStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: SousChefStyling.standardMargin),
			containingStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -SousChefStyling.standardMargin),
			containingStackView.heightAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonHeight),
			containingStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -SousChefStyling.standardMargin),
			containingStackView.heightAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonHeight),
			contentView.heightAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonHeight),
			leadingDummyView.widthAnchor.constraint(equalToConstant: 1),
			leadingDummyView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
			trailingDummyView.widthAnchor.constraint(equalToConstant: 1),
			trailingDummyView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
			backButton.widthAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonWidth),
			backButton.heightAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonHeight),
			bugButton.widthAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonWidth),
			bugButton.heightAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonHeight),
			
		]
		
		NSLayoutConstraint.activate(constraint)
	}
}

//MARK: - Overridden Methods
extension FloatingButtonNavigationController {
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

// MARK: - Methods
extension FloatingButtonNavigationController {
	
	func addTrailingFloatingButton(title: String?, image: UIImage?, target: Any, action: Selector, viewController: UIViewController?) {
		addFloatingButton(title: title, image: image, target: target, action: action, viewController: viewController, alignment: .trailing)
	}
	
	func addLeadingFloatingButton(title: String?, image: UIImage?, target: Any, action: Selector, viewController: UIViewController?) {
		addFloatingButton(title: title, image: image, target: target, action: action, viewController: viewController, alignment: .leading)
	}
	
	func floatingButton(title: String?, image: UIImage?, target: Any, action: Selector) -> SousChefButton {
		let floatingButton = SousChefButton(frame: .zero)
		floatingButton.setImage(image, for: .normal)
		floatingButton.setTitle(title, for: .normal)
		floatingButton.addTarget(target, action: action, for: .primaryActionTriggered)
		floatingButton.translatesAutoresizingMaskIntoConstraints = false
		
		let constraints = [
			floatingButton.widthAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonWidth),
			floatingButton.heightAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonHeight)
		]
		NSLayoutConstraint.activate(constraints)
		
		return floatingButton
	}
}

//MARK: - Utilities
private enum FloatingButtonAlignment {
	case leading
	case trailing
}
extension FloatingButtonNavigationController {
	
	private func addFloatingButton(title: String?, image: UIImage?, target: Any, action: Selector, viewController: UIViewController?, alignment: FloatingButtonAlignment) {
		let button = floatingButton(title: title, image: image, target: target, action: action)
		let stackView = alignment == .leading ? leadingFloatingButtonStack : trailingFloatingButtonStack
		button.isHidden = true
		stackView.addArrangedSubview(button)
		stackView.layoutIfNeeded()
		UIView.animate(withDuration: 0.33) {
			button.isHidden = false
			stackView.layoutIfNeeded()
		}
		
		if let vc = viewController {
			if !buttonsForViewController.keys.contains(vc) {
				buttonsForViewController[vc] = []
			}
			buttonsForViewController[vc]?.append(button)
		}
	}
	
	private func removeFloatingButtons(for viewController: UIViewController, viewControllerCount: Int) {
		UIView.animate(withDuration: 0.33, animations: {
			self.buttonsForViewController[viewController]?.forEach({ $0.isHidden = true })
			self.backButton.isHidden = viewControllerCount <= 1
			self.view.layoutIfNeeded()
			self.leadingFloatingButtonStack.layoutIfNeeded()
			self.trailingFloatingButtonStack.layoutIfNeeded()
		}) { (completed) in
			if completed {
				self.buttonsForViewController[viewController]?.forEach({ $0.removeFromSuperview() })
			}
		}
	}
	
	private func screenshot() -> UIImage? {
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
}

// MARK: - MFMailComposeViewControllerDelegate
extension FloatingButtonNavigationController {
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true, completion: nil)
	}
}
