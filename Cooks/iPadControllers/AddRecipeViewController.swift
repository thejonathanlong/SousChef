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
		commonInit(isDividerBelow: true)
	}
	
	init(frame: CGRect, isDividerBelow: Bool) {
		super.init(frame: frame)
		commonInit(isDividerBelow: isDividerBelow)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit(isDividerBelow: true)
	}
	
	func commonInit(isDividerBelow: Bool) {
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
		if isDividerBelow {
			verticalStackView.addArrangedSubview(horizontalStackView)
			verticalStackView.addArrangedSubview(headerDivider)
		}
		else {
			verticalStackView.addArrangedSubview(headerDivider)
			verticalStackView.addArrangedSubview(horizontalStackView)
		}
		
		
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
	
	func contains(button: UIButton) -> Bool {
		return self.horizontalStackView.arrangedSubviews.contains(button)
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
			resultingTextView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: SousChefStyling.smallestMargin),
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
	let recipeImageCameraButton = SousChefButton(frame: .zero)
	let recipeImagePhotoButton = SousChefButton(frame: .zero)
	
	let titleHeaderView = HeaderView(frame: .zero)
	let tagsHeaderView = HeaderView(frame: .zero, isDividerBelow: false)
	let ingredientSmartAddViewController = SmartAddViewController(nibName: nil, bundle: nil)
	let instructionSmartAddViewController = SmartAddViewController(nibName: nil, bundle: nil)
	
	var resultingView = UIView()
	let database = SousChefDatabase.shared
	let ingredientTagger = IngredientLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"), options: 0)
	
	override func loadView() {
		super.loadView()
		view.backgroundColor = SousChefStyling.lightColor
		
		let cameraImage = UIImage(named: "Camera")
		let photoImage = UIImage(named: "Photo")
		
		backgroundImageView.image = UIImage(named: "Default")
		backgroundImageView.contentMode = .scaleAspectFill
		backgroundImageView.clipsToBounds = true
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		
		recipeImagePhotoButton.translatesAutoresizingMaskIntoConstraints = false
		recipeImagePhotoButton.addTarget(self, action: #selector(recipeImageFromPhoto(sender:)), for: .primaryActionTriggered)
		recipeImagePhotoButton.setImage(photoImage, for: .normal)
		
		recipeImageCameraButton.translatesAutoresizingMaskIntoConstraints = false
		recipeImageCameraButton.addTarget(self, action: #selector(recipeImageFromCamera(sender:)), for: .primaryActionTriggered)
		recipeImageCameraButton.setImage(cameraImage, for: .normal)
		
		contentView.backgroundColor = SousChefStyling.lightColor
		contentView.translatesAutoresizingMaskIntoConstraints = false
		
		let ingredientSmartAddView = ingredientSmartAddViewController.view!
		ingredientSmartAddViewController.header.text = "Ingredients"
		ingredientSmartAddViewController.header.addActionButton(target: self, action: #selector(extractFromCamera(sender:)), image: cameraImage)
		ingredientSmartAddViewController.header.addActionButton(target: self, action: #selector(extractFromPhoto(sender:)), image: photoImage)
		ingredientSmartAddView.translatesAutoresizingMaskIntoConstraints = false
		ingredientSmartAddViewController.resultingTextView.text = "ingredient list goes here"
		
		let instructionSmartAddView = instructionSmartAddViewController.view!
		instructionSmartAddViewController.header.text = "Instructions"
		instructionSmartAddViewController.header.addActionButton(target: self, action: #selector(extractFromCamera(sender:)), image: cameraImage)
		instructionSmartAddViewController.header.addActionButton(target: self, action: #selector(extractFromPhoto(sender:)), image: photoImage)
		instructionSmartAddView.translatesAutoresizingMaskIntoConstraints = false
		instructionSmartAddViewController.resultingTextView.text = "instructions go here"
		
		titleHeaderView.translatesAutoresizingMaskIntoConstraints = false
		titleHeaderView.isEditable = true
		titleHeaderView.text = "Recipe Name"
		
		tagsHeaderView.translatesAutoresizingMaskIntoConstraints = false
		tagsHeaderView.isEditable = true
		tagsHeaderView.text = "Tags"
		
		view.addSubview(backgroundImageView)
		view.addSubview(contentView)
		view.addSubview(recipeImageCameraButton)
		view.addSubview(recipeImagePhotoButton)
		
		addChildViewController(ingredientSmartAddViewController)
		contentView.addSubview(ingredientSmartAddView)
		ingredientSmartAddViewController.didMove(toParentViewController: self)
		
		addChildViewController(instructionSmartAddViewController)
		contentView.addSubview(instructionSmartAddView)
		instructionSmartAddViewController.didMove(toParentViewController: self)
		
		contentView.addSubview(titleHeaderView)
		contentView.addSubview(tagsHeaderView)
		
		var constraints = NSLayoutConstraint.constraintsPinningEdges(of: backgroundImageView, toEdgesOf: view)
		let contentViewConstraints = NSLayoutConstraint.constraintsPinningEdges(of: contentView, toEdgesOf: view, insetBy: SousChefStyling.veryLargeMargin)
		constraints.append(contentsOf: contentViewConstraints)
		
		let contentConstraints = [
			recipeImagePhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SousChefStyling.standardMargin),
			recipeImagePhotoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -SousChefStyling.standardMargin),
			recipeImageCameraButton.trailingAnchor.constraint(equalTo: recipeImagePhotoButton.leadingAnchor, constant: -8),
			recipeImageCameraButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SousChefStyling.standardMargin),
			recipeImagePhotoButton.widthAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonWidth),
			recipeImagePhotoButton.heightAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonWidth),
			recipeImageCameraButton.widthAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonWidth),
			recipeImageCameraButton.heightAnchor.constraint(equalToConstant: SousChefStyling.navigationFloatingButtonWidth),
			
			titleHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SousChefStyling.standardMargin),
			titleHeaderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SousChefStyling.standardMargin),
			titleHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SousChefStyling.standardMargin),
			
			ingredientSmartAddView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SousChefStyling.standardMargin),
			ingredientSmartAddView.topAnchor.constraint(equalTo: titleHeaderView.bottomAnchor, constant: SousChefStyling.smallestMargin),
			ingredientSmartAddView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.33),
			ingredientSmartAddView.bottomAnchor.constraint(equalTo: tagsHeaderView.topAnchor, constant: -SousChefStyling.smallestMargin),
			
			instructionSmartAddView.leadingAnchor.constraint(equalTo: ingredientSmartAddView.trailingAnchor, constant: SousChefStyling.standardMargin),
			instructionSmartAddView.topAnchor.constraint(equalTo: titleHeaderView.bottomAnchor, constant: SousChefStyling.smallestMargin),
			instructionSmartAddView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65, constant: -SousChefStyling.standardMargin*3),
			instructionSmartAddView.bottomAnchor.constraint(equalTo: tagsHeaderView.topAnchor, constant: -SousChefStyling.smallestMargin),
			
			tagsHeaderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SousChefStyling.standardMargin),
			tagsHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SousChefStyling.standardMargin),
			tagsHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SousChefStyling.standardMargin),
		]
		
		constraints.append(contentsOf: contentConstraints)
		
		NSLayoutConstraint.activate(constraints)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let baseNavigationController = navigationController as? FloatingButtonNavigationController {
			baseNavigationController.addFloatingButton(title: "Done", target: self, action: #selector(done(sender:)), viewController: self)
		}
	}
}

//MARK: - Actions
extension AddRecipeViewController {

	@objc func done(sender: UIButton) {
		let recipeName = titleHeaderView.text
		
//		ingredientTagger.string = ingredientSmartAddViewController.resultingTextView.text.split(separator: "\n")
		ingredientTagger.string = "6 Tbsp ghee, palm shortening, or grass—fed unsalted butter"
//		let ingredientList = ingredientTagger.ingredients()
		var ingredientList: [Ingredient] = []
		 ingredientTagger.enumerateTags { (ing) in
			ingredientList.append(ing)
		}
		
		let instructionList = instructionSmartAddViewController.resultingTextView.text.split(separator: "\n").map(String.init)
		
		let recipe = Recipe(name: recipeName, ingredients: ingredientList, instructions: instructionList, image: nil, tags: [])
		
		print(recipe)
		
		//		database.save(recipes: <#T##[Recipe]#>, onCompletionBlock: <#T##([CKRecord]?, [CKRecordID]?, Error?) -> Void#>)
	}
	
	@objc func extractFromCamera(sender: UIButton) {
		if ingredientSmartAddViewController.header.subviews.contains(sender) {
			resultingView = ingredientSmartAddViewController.resultingTextView
		}
		else if instructionSmartAddViewController.header.subviews.contains(sender) {
			resultingView = instructionSmartAddViewController.resultingTextView
		}
		
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .camera
		imagePickerController.mediaTypes = [kUTTypeImage as String]
		imagePickerController.delegate = self
		
		present(imagePickerController, animated: true, completion: nil)
	}
	
	@objc func extractFromPhoto(sender: UIButton) {
		if ingredientSmartAddViewController.header.subviews.contains(sender) {
			resultingView = ingredientSmartAddViewController.resultingTextView
		}
		else if instructionSmartAddViewController.header.subviews.contains(sender) {
			resultingView = instructionSmartAddViewController.resultingTextView
		}
		
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .savedPhotosAlbum
		imagePickerController.mediaTypes = [kUTTypeImage as String]
		imagePickerController.allowsEditing = true
		imagePickerController.delegate = self
		
		present(imagePickerController, animated: true, completion: nil)
	}
	
	@objc func recipeImageFromPhoto(sender: UIButton) {
		resultingView = backgroundImageView
		
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .savedPhotosAlbum
		imagePickerController.mediaTypes = [kUTTypeImage as String]
		imagePickerController.allowsEditing = true
		imagePickerController.delegate = self
		
		present(imagePickerController, animated: true, completion: nil)
	}
	
	@objc func recipeImageFromCamera(sender: UIButton) {
		resultingView = backgroundImageView
		
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .camera
		imagePickerController.mediaTypes = [kUTTypeImage as String]
		imagePickerController.delegate = self
		
		present(imagePickerController, animated: true, completion: nil)
	}
}

//MARK: - UIImagePickercontrollerDelegate
extension AddRecipeViewController {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		print("Did Finish picking media")
		let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
		if resultingView is UITextView {
			TextRecognizer.shared.recognizeText(in: editedImage!) { (recognizedText) in
				DispatchQueue.main.async {
					let text = self.resultingView == self.instructionSmartAddViewController.resultingTextView ? recognizedText.replacingOccurrences(of: "\n", with: " ") : recognizedText
					let sentences = self.findSentences(text: text)
					let paragraph = self.resultingView == self.instructionSmartAddViewController.resultingTextView ? sentences.joined(separator: "\n") : sentences.joined(separator: "")
					print("identified text: \(paragraph)")
					if let resultingTextView = self.resultingView as? UITextView {
						resultingTextView.text = paragraph
					}
					else {
						print("There was a problem... the resulting view should be a text view... not \(self.resultingView.self)")
					}
				}
			}
		}
		else {
			backgroundImageView.image = editedImage
		}
		picker.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
	
}

// MARK: - Utility
extension AddRecipeViewController {
	
	// Splits a chunk of texts up by sentences.
	func findSentences(text: String) -> [String] {
		var sentences: [String] = []
		let sentenceTagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"), options: 0)
		sentenceTagger.string = text
		sentenceTagger.enumerateTags(in: NSMakeRange(0, text.count), unit: .sentence, scheme: .language, options: .joinNames) { (tagOrNil, range, stop) in
			let start = text.index(text.startIndex, offsetBy: range.location)
			let end = text.index(text.startIndex, offsetBy: (range.location + range.length))
			let tokenInQuestion = String(text[start..<end])
			if (tokenInQuestion != "\n")
			{
				sentences.append(tokenInQuestion)
			}
		}
		
		return sentences
	}
}
