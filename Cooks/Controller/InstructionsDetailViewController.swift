//
//  InstructionsDetailViewController.swift
//  Cooks
//
//  Created by Jonathan Long on 9/12/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import UIKit

class InstructionsDetailViewController: UIViewController {
    
    static let instructionListEmbedSegueIdentifier = "InstructionListeEmbedSegue"
    var instructionsListViewController = InstructionsListTableViewController()
    
    @IBOutlet weak var imageHeaderBottomConstraint: NSLayoutConstraint!
    
    var recipe = Recipe() {
        didSet {
            instructionsListViewController.instructions = recipe.instructions
            instructionsListViewController.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier  {
            switch segueIdentifier {
                case InstructionsDetailViewController.instructionListEmbedSegueIdentifier:
                instructionsListViewController = segue.destination as! InstructionsListTableViewController
                default:
                    break
            }
        }
    }

}
