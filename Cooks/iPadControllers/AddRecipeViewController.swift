//
//  AddRecipeViewController.swift
//  SousChef
//
//  Created by Jonathan Long on 2/10/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit
import MobileCoreServices

//MARK: - HeaderView
class HeaderView: UIView, UITextViewDelegate {
	private let verticalStackView = UIStackView()
	private let horizontalStackView = UIStackView()
	private let textView = UITextView()
	private let headerDivider = UIView()
	private var textViewHeightConstraint = NSLayoutConstraint()
	private var textViewHeight: CGFloat = 0.0
	
	var text = "" {
		didSet {
			textView.text = text
			textViewDidChange(textView)
		}
	}
	
	var isEditable: Bool = false {
		didSet {
			textView.isEditable = isEditable
		}
	}

	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit() {
		textView.isEditable = isEditable
		
		verticalStackView.translatesAutoresizingMaskIntoConstraints = false
		horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
		textView.translatesAutoresizingMaskIntoConstraints = false
		headerDivider.translatesAutoresizingMaskIntoConstraints = false
		
		verticalStackView.axis = .vertical
		verticalStackView.distribution = .equalSpacing
		verticalStackView.alignment = .leading
		verticalStackView.spacing = 5.0
		
		horizontalStackView.axis = .horizontal
		horizontalStackView.distribution = .fill
		horizontalStackView.spacing = 5.0
		
		textView.font = SousChefStyling.preferredFont(for: .headline)
		textView.textColor = SousChefStyling.darkColor

		textView.delegate = self
		headerDivider.backgroundColor = SousChefStyling.darkColor
		
		horizontalStackView.addArrangedSubview(textView)
		verticalStackView.addArrangedSubview(horizontalStackView)
		verticalStackView.addArrangedSubview(headerDivider)
		
		addSubview(verticalStackView)
		
		textViewHeightConstraint = textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
		let constraints = [
			textViewHeightConstraint,
			headerDivider.heightAnchor.constraint(equalToConstant: 1.5),
			textView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
			headerDivider.widthAnchor.constraint(equalTo: widthAnchor),
			horizontalStackView.heightAnchor.constraint(equalTo: textView.heightAnchor),
			horizontalStackView.widthAnchor.constraint(equalTo: widthAnchor),
			verticalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			verticalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			verticalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			verticalStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
			]
		
		NSLayoutConstraint.activate(constraints)
	}
}

extension HeaderView {
	func textViewDidChange(_ textView: UITextView) {
		let width = self.frame.width
		let newSize = textView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
		textViewHeight = newSize.height
		textViewHeightConstraint.isActive = false
		textViewHeightConstraint = textView.heightAnchor.constraint(greaterThanOrEqualToConstant: newSize.height)
		textViewHeightConstraint.isActive = true
	}
}

extension HeaderView {
	func addActionButton(target: Any, action: Selector, image: UIImage?) {
		let button = SousChefButton(frame: .zero)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(target, action: action, for: .primaryActionTriggered)
		button.setImage(image, for: .normal)
		
		horizontalStackView.addArrangedSubview(button)
		
		let constraints = [
			button.heightAnchor.constraint(equalToConstant: textViewHeight),
			button.widthAnchor.constraint(equalToConstant: textViewHeight),
		]
		
		NSLayoutConstraint.activate(constraints)
	}
}

class SmartAddViewController: UIViewController {
	let header = HeaderView(frame: .zero)
	let resultingTextView = UITextView()
	
	override func loadView() {
		super.loadView()
		header.translatesAutoresizingMaskIntoConstraints = false
		resultingTextView.translatesAutoresizingMaskIntoConstraints = false
		
		resultingTextView.font = DetailTableViewCell.mainTextLabelFont
		resultingTextView.textColor = SousChefStyling.darkColor
		
		view.addSubview(header)
		view.addSubview(resultingTextView)
		
		let constraints = [
			header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			resultingTextView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: SousChefStyling.smallestAllowableMargin),
			resultingTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			resultingTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			resultingTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		]
		
		NSLayoutConstraint.activate(constraints)
	}
}

//MARK: - AddRecipeViewController
class AddRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	let contentView = UIView()
	let backgroundImageView = UIImageView()
	let titleHeaderView = HeaderView(frame: .zero)
	let ingredientSmartAddViewController = SmartAddViewController(nibName: nil, bundle: nil)
	let instructionSmartAddViewController = SmartAddViewController(nibName: nil, bundle: nil)
	
	override func loadView() {
		super.loadView()
		view.backgroundColor = SousChefStyling.lightColor
		
		let cameraImage = UIImage(named: "Camera")
		let photoImage = UIImage(named: "Photo")
		
		backgroundImageView.image = UIImage(named: "Default")
		backgroundImageView.contentMode = .scaleAspectFill
		backgroundImageView.clipsToBounds = true
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		
		contentView.backgroundColor = SousChefStyling.lightColor
		contentView.translatesAutoresizingMaskIntoConstraints = false
		
		let ingredientSmartAddView = ingredientSmartAddViewController.view!
		ingredientSmartAddViewController.header.text = "Ingredients"
		ingredientSmartAddViewController.header.addActionButton(target: self, action: #selector(extractFromCamera), image: cameraImage)
		ingredientSmartAddViewController.header.addActionButton(target: self, action: #selector(extractFromPhoto), image: photoImage)
		ingredientSmartAddView.translatesAutoresizingMaskIntoConstraints = false
		
		let instructionSmartAddView = instructionSmartAddViewController.view!
		instructionSmartAddViewController.header.text = "Instructions"
		instructionSmartAddViewController.header.addActionButton(target: self, action: #selector(extractFromCamera), image: cameraImage)
		instructionSmartAddViewController.header.addActionButton(target: self, action: #selector(extractFromPhoto), image: photoImage)
		instructionSmartAddView.translatesAutoresizingMaskIntoConstraints = false
		
		titleHeaderView.translatesAutoresizingMaskIntoConstraints = false
		titleHeaderView.isEditable = true
		titleHeaderView.text = "Recipe Name"
		
		view.addSubview(backgroundImageView)
		view.addSubview(contentView)
		
		addChildViewController(ingredientSmartAddViewController)
		contentView.addSubview(ingredientSmartAddView)
		ingredientSmartAddViewController.didMove(toParentViewController: self)
		
		addChildViewController(instructionSmartAddViewController)
		contentView.addSubview(instructionSmartAddView)
		instructionSmartAddView.clipsToBounds = true
		instructionSmartAddViewController.didMove(toParentViewController: self)
		
		contentView.addSubview(titleHeaderView)
		
		var constraints = NSLayoutConstraint.constraintsPinningEdges(of: backgroundImageView, toEdgesOf: view)
		let contentViewConstraints = NSLayoutConstraint.constraintsPinningEdges(of: contentView, toEdgesOf: view, insetBy: SousChefStyling.largestAllowableMargin)
		constraints.append(contentsOf: contentViewConstraints)
		
		let contentConstraints = [
			titleHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SousChefStyling.allowableMargin),
			titleHeaderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SousChefStyling.allowableMargin),
			titleHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SousChefStyling.allowableMargin),
			ingredientSmartAddView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SousChefStyling.allowableMargin),
			ingredientSmartAddView.topAnchor.constraint(equalTo: titleHeaderView.bottomAnchor, constant: SousChefStyling.smallestAllowableMargin),
			ingredientSmartAddView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
			ingredientSmartAddView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SousChefStyling.smallestAllowableMargin),
			instructionSmartAddView.leadingAnchor.constraint(equalTo: ingredientSmartAddView.trailingAnchor, constant: SousChefStyling.allowableMargin),
			instructionSmartAddView.topAnchor.constraint(equalTo: titleHeaderView.bottomAnchor, constant: SousChefStyling.smallestAllowableMargin),
			instructionSmartAddView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5, constant: -SousChefStyling.allowableMargin*3),
			instructionSmartAddView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SousChefStyling.smallestAllowableMargin),
		]
		
		constraints.append(contentsOf: contentConstraints)
		
		NSLayoutConstraint.activate(constraints)
	}
	
	@objc func extractFromCamera() {
		let imagePickerController = UIImagePickerController()
		
		imagePickerController.sourceType = .camera
		imagePickerController.mediaTypes = [kUTTypeImage as String]
		imagePickerController.delegate = self
		
		present(imagePickerController, animated: true, completion: nil)
	}
	
	@objc func extractFromPhoto() {
		let imagePickerController = UIImagePickerController()
		
		imagePickerController.sourceType = .savedPhotosAlbum
		imagePickerController.mediaTypes = [kUTTypeImage as String]
		imagePickerController.delegate = self
		
		present(imagePickerController, animated: true, completion: nil)
	}
}

//MARK: - UIImagePickercontrollerDelegate
extension AddRecipeViewController {
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
		let uncroppedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
		let croppedImage = info[UIImagePickerControllerEditedImage] as? UIImage
		let cropRect = info[UIImagePickerControllerCropRect]!.cgRectValue
		
		picker.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
	
}
