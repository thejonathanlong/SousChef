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
	var textViewUnderRecognition = UITextView()
	
	let database = SousChefDatabase.shared
	let ingredientTagger = IngredientLinguisticTagger()
	
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
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if let baseNavigationController = navigationController as? FloatingButtonNavigationController {
			baseNavigationController.addFloatingButton(title: "Done", target: self, action: #selector(done(sender:)), viewController: self)
		}
	}
	
	@objc func done(sender: UIButton) {
		let recipeName = titleHeaderView.text
		
		ingredientTagger.string = ingredientSmartAddViewController.resultingTextView.text
		let ingredientList = ingredientTagger.ingredients()
		
		let instructionList = instructionSmartAddViewController.resultingTextView.text.split(separator: "\n")
		
		let recipe = Recipe(name: recipeName, ingredients: ingredientList, instructions: instructionList, image: <#T##UIImage?#>, tags: [])
	}
	
	@objc func extractFromCamera(sender: UIButton) {
		
		textViewUnderRecognition = ingredientSmartAddViewController.header.subviews.contains(sender) ? ingredientSmartAddViewController.resultingTextView : instructionSmartAddViewController.resultingTextView
		
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .camera
		imagePickerController.mediaTypes = [kUTTypeImage as String]
		imagePickerController.delegate = self
		
		present(imagePickerController, animated: true, completion: nil)
	}
	
	@objc func extractFromPhoto(sender: UIButton) {
		
		textViewUnderRecognition = ingredientSmartAddViewController.header.contains(button: sender) ? ingredientSmartAddViewController.resultingTextView : instructionSmartAddViewController.resultingTextView
		
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .savedPhotosAlbum
		imagePickerController.mediaTypes = [kUTTypeImage as String]
		imagePickerController.allowsEditing = true
		imagePickerController.delegate = self
		
		present(imagePickerController, animated: true, completion: nil)
	}
}

//MARK: - UIImagePickercontrollerDelegate
extension AddRecipeViewController {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		print("Did Finish picking media")
//		let uncroppedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
		let croppedImage = info[UIImagePickerControllerEditedImage] as? UIImage
		
		TextRecognizer.shared.recognizeText(in: croppedImage!) { (recognizedText) in
			let textWithoutNewlines = recognizedText.replacingOccurrences(of: "\n", with: " ")
			let sentences = self.findSentences(text: textWithoutNewlines)
			let paragraph = sentences.joined(separator: "\n")
			DispatchQueue.main.async {
				print("identified text: \(recognizedText)")
				self.textViewUnderRecognition.text = paragraph
			}
			
		}
		picker.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
	
}

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
