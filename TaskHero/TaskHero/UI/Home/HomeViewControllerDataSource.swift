//
//  HomeViewControllerDataSource.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 1/2/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

enum HomeCellType {
    case task, header
}

protocol cellMake {
    func configure(indexPath: IndexPath, cellType: HomeCellType, tableView:UITableView) -> UITableViewCell
}

class HomeViewControllerDataSource {
    
    /* Temporary abstraction of HomeViewController behavior. Not finalized will be organized into datasource and flowcontroller */
    
    let store = DataStore.sharedInstance
    fileprivate var taskViewModel: TaskCellViewModel!
    
    // Number of rows in HomeViewController, if no tasks it returns 1 for ProfileHeaderCell
    
    var rows: Int {
        get {
            if (store.currentUser.tasks?.count)! < 1 {
                return 1
            } else {
                return (store.currentUser.tasks!.count) + 1
            }
        }
    }
    var rowHeight = UITableViewAutomaticDimension
    var tableIndexPath: IndexPath!
    var autoHeight: UIViewAutoresizing?
}

/* Extension containing method for configuring cells in ViewController. If passed in indexPath.row is 0, the cell returned is ProfileHeaderCell */

extension HomeViewControllerDataSource: cellMake {
    
    func configure(indexPath:IndexPath, cellType:HomeCellType, tableView:UITableView) -> UITableViewCell {
        if cellType == .header {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: ProfileHeaderCell.cellIdentifier, for: indexPath) as! ProfileHeaderCell
            return headerCell
        } else {
            var taskViewModel: TaskCellViewModel!
            let taskCell = tableView.dequeueReusableCell(withIdentifier: TaskCell.cellIdentifier, for: indexPath) as! TaskCell
           // print(indexPath.row)
            self.store.currentUser.tasks = self.store.tasks
            print(indexPath.row - 1)
            //print(self.store.currentUser.tasks?[indexPath.row - 1])
            taskViewModel = TaskCellViewModel((self.store.currentUser.tasks?[indexPath.row - 1])!)
            taskCell.configureCell(taskVM: taskViewModel)
            return taskCell
        }
    }
}

// Methods for configure UIElements + registers cell types for tableView

extension HomeViewControllerDataSource {
    
    /* Sets estimatedRowHeight and registers cell types */

    func setupView(tableView:UITableView, view:UIView) {
        tableView.register(ProfileHeaderCell.self, forCellReuseIdentifier: ProfileHeaderCell.cellIdentifier)
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.cellIdentifier)
        tableView.setupTableView()
        tableView.estimatedRowHeight = view.frame.height / 4
    }
    
    /* Setup headerCell */
    
    func setupHeaderCell(headerCell:ProfileHeaderCell, viewController:HomeViewController) {
        headerCell.delegate = viewController
        headerCell.emailLabel.isHidden = true
        headerCell.configureCell(autoHeight: UIViewAutoresizing.flexibleHeight)

    }
    
    /* setup TaskCell */
    
    func setupTaskCell(taskCell:TaskCell, viewController:HomeViewController) {
        taskCell.delegate = viewController
        taskCell.taskDescriptionBox.delegate = viewController
        taskCell.toggled = viewController.tapped
        let tap = UIGestureRecognizer(target: viewController, action: #selector(viewController.toggleForEditState(sender:)))
        taskCell.taskCompletedView.addGestureRecognizer(tap)
    }
    
    func selectImage(picker:UIImagePickerController, viewController: UIViewController) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        viewController.present(picker, animated: true, completion: nil)
    }
    
    /* Deletes task at indexPath.row - 1 - subtraction because TaskCells are below the profileHeader cell */
    
    func deleteTask(indexPath: IndexPath, tableView:UITableView) {
        
        DispatchQueue.global(qos: .default).async {
            let removeTaskID: String = self.store.currentUser.tasks![indexPath.row - 1].taskID
            self.store.tasks = self.store.currentUser.tasks!
            self.store.tasks.remove(at: indexPath.row - 1)
            self.store.updateUserScore()
            self.store.firebaseAPI.registerUser(user: self.store.currentUser)
            self.store.firebaseAPI.removeTask(ref: removeTaskID, taskID: removeTaskID)
            DispatchQueue.main.async(execute: {
                tableView.reloadData()
            })
        }
        print(self.store.tasks)
    }
}


