//
//  InstructionsListTableViewController.swift
//  Cooks
//
//  Created by Jonathan Long on 9/12/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import UIKit

class InstructionsListTableViewController: UITableViewController {
    
    static let instructionListTableViewCellReuseIdentifier = "InstructionListCellReuseIdentifier"
    
    @IBOutlet weak var tableHeaderView: UIImageView!
    var instructions : [String] = []
    
    var previousScrollOffset = CGFloat(0.0)
    let maxHeaderHeight = UIScreen.main.bounds.height
    let minHeaderHeight = CGFloat(40)
    
    override func loadView() {
        super.loadView()
        
        tableView.delegate = self
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

// MARK: - Table view data source
extension InstructionsListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InstructionsListTableViewController.instructionListTableViewCellReuseIdentifier)!
        let instruction = instructions[indexPath.row]
        
        cell.textLabel?.text = instruction
        
        return cell
    }
}

// MARK: Table View Delegate
extension InstructionsListTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - previousScrollOffset
        let isScrollingDown = scrollDiff > 0
        let isScrollingUp = scrollDiff < 0
        
        if let headerView = tableView.tableHeaderView {
            let oldHeight = headerView.frame.height
            var newHeight = oldHeight
            if isScrollingDown {
                newHeight = max(minHeaderHeight, oldHeight - abs(scrollDiff))
            } else if isScrollingUp {
                newHeight = min(maxHeaderHeight, oldHeight + abs(scrollDiff))
            }
            
            tableView.beginUpdates()
            headerView.frame = CGRect(x: headerView.frame.origin.x, y: headerView.frame.origin.y, width: headerView.frame.width, height: newHeight)
            tableView.endUpdates()
        }
        previousScrollOffset = scrollView.contentOffset.y
    }
}
