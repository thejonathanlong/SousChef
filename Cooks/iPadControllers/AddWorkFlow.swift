//
//  AddWorkFlow.swift
//  SousChef
//
//  Created by Jonathan Long on 1/18/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit

class RecipeSmartAddViewController: UIViewController {
	
	let titleLabel = UILabel()
	let buttonStackView = UIStackView()
	let cameraButton = UIButton(type: .system)
	let photosButton = UIButton(type: .system)
	let textButton = UIButton(type: .system)
	
	override func loadView() {
		super.loadView()
		
		view.backgroundColor = UIColor.white
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		buttonStackView.translatesAutoresizingMaskIntoConstraints = false
		cameraButton.translatesAutoresizingMaskIntoConstraints = false
		photosButton.translatesAutoresizingMaskIntoConstraints = false
		textButton.translatesAutoresizingMaskIntoConstraints = false

		cameraButton.setTitle("Camera", for: .normal)
		photosButton.setTitle("Photo", for: .normal)
		textButton.setTitle("Text", for: .normal)
		
		titleLabel.textColor = SousChefStyling.darkColor
		cameraButton.titleLabel?.textColor = SousChefStyling.darkColor
		photosButton.titleLabel?.textColor = SousChefStyling.darkColor
		textButton.titleLabel?.textColor = SousChefStyling.darkColor
		
		cameraButton.backgroundColor = UIColor.blue
		photosButton.backgroundColor = UIColor.red
		textButton.backgroundColor = UIColor.green
		
		
		cameraButton.isHidden = false
		
		cameraButton.addTarget(self, action: #selector(presentCamera(sender:)), for: .primaryActionTriggered)
		photosButton.addTarget(self, action: #selector(presentPhotoPicker(sender:)), for: .primaryActionTriggered)
		textButton.addTarget(self, action: #selector(presentTextInput(sender:)), for: .primaryActionTriggered)
		
		buttonStackView.axis = .horizontal
		buttonStackView.alignment = .center
		buttonStackView.distribution = .fillEqually
		buttonStackView.spacing = 25.0 // this number probably isn't right
		
		buttonStackView.addArrangedSubview(cameraButton)
		buttonStackView.addArrangedSubview(photosButton)
		buttonStackView.addArrangedSubview(textButton)
		
		view.addSubview(titleLabel)
		view.addSubview(buttonStackView)
		
		let constraints = [
			titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			buttonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
			buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25.0), // This number should be the same as the spacing probably
			buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25.0),
		]
		
		NSLayoutConstraint.activate(constraints)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
}

//MARK: - Button Actions
extension RecipeSmartAddViewController {
	@objc func presentCamera(sender: UIButton) {
		
	}
	
	@objc func presentPhotoPicker(sender: UIButton) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .photoLibrary
		imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
		
		present(imagePickerController, animated: true, completion: nil)
		
		
	}
	
	@objc func presentTextInput(sender: UIButton) {
		
	}
}

class RecipeReviewViewController: UIViewController, UITextViewDelegate {
	
	let titleTextView = UITextView()
	let ingredientExpandingTextView = ExpandingTextView()
	let directionExpandingTextView = ExpandingTextView()
	let ingredientExpandingTextViewTapGestureRecognizer = UITapGestureRecognizer()
	let directionTextViewTapGestureRecognizer = UITapGestureRecognizer()
	
	
	override func loadView() {
		super.loadView()
		view.backgroundColor = UIColor.white
		
		titleTextView.translatesAutoresizingMaskIntoConstraints = false
		ingredientExpandingTextView.translatesAutoresizingMaskIntoConstraints = false
		directionExpandingTextView.translatesAutoresizingMaskIntoConstraints = false
		
		titleTextView.text = "Recipe Name"
		titleTextView.font = SousChefStyling.preferredFont(for: .headline)
		titleTextView.textColor = SousChefStyling.darkColor
		titleTextView.alpha = 0.85
		
		titleTextView.delegate = self
		
		view.addSubview(titleTextView)
		view.addSubview(directionExpandingTextView)
		view.addSubview(ingredientExpandingTextView)
		
		directionTextViewTapGestureRecognizer.addTarget(self, action: #selector(expandDirectionDetails(gesture:)))
		directionExpandingTextView.addGestureRecognizer(directionTextViewTapGestureRecognizer)
		
		ingredientExpandingTextViewTapGestureRecognizer.addTarget(self, action: #selector(expandIngredientDetails(gesture:)))
		ingredientExpandingTextView.addGestureRecognizer(ingredientExpandingTextViewTapGestureRecognizer)
		
		let constraints = [
			titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			titleTextView.heightAnchor.constraint(equalToConstant: 40),
			ingredientExpandingTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			ingredientExpandingTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			ingredientExpandingTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
			directionExpandingTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			directionExpandingTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			directionExpandingTextView.topAnchor.constraint(equalTo: ingredientExpandingTextView.bottomAnchor),
		]
		
		NSLayoutConstraint.activate(constraints)
		
		ingredientExpandingTextView.headerTitle = "Ingredients"
		ingredientExpandingTextView.text = "I’d love to isolate the first time I heard these words, but I can’t. It predates my memory. I do, however, remember the first time I thought about these words, which didn’t happen until 2003. I was intrigued by the math: The main character (who’s technically the creation of non-Eagle Browne, since he wrote this particular verse) is fleeing from seven women."
		directionExpandingTextView.headerTitle = "Directions"
		directionExpandingTextView.text = "I’d love to isolate the first time I heard these words, but I can’t. It predates my memory. I do, however, remember the first time I thought about these words, which didn’t happen until 2003. I was intrigued by the math: The main character (who’s technically the creation of non-Eagle Browne, since he wrote this particular verse) is fleeing from seven women."
	}
	
	@objc func expandIngredientDetails(gesture: UITapGestureRecognizer) {
		ingredientExpandingTextView.isExpanded = !ingredientExpandingTextView.isExpanded
	}
	
	@objc func expandDirectionDetails(gesture: UITapGestureRecognizer) {
		directionExpandingTextView.isExpanded = !directionExpandingTextView.isExpanded
	}
}

//MARK: - UITextViewDelegate
extension RecipeReviewViewController {
	
	func textViewDidChange(_ textView: UITextView) {
		textView.alpha = 1.0
	}
	
}
