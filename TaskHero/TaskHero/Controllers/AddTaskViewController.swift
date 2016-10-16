//
//  AddTaskViewController.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 9/28/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import Firebase

class AddTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    let store = DataStore.sharedInstance
    let schema = Database.sharedInstance
    let addTaskView = AddTaskView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addSubview(addTaskView)
        edgesForExtendedLayout = []
        
        addTaskView.layoutSubviews()
        addTaskView.taskNameField.delegate = self
        addTaskView.taskDescriptionBox.delegate = self
        addTaskView.addTaskButton.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(image:UIImage(named:"back-1"), style: .done, target:self, action: #selector(backTapped))
        backButton.title = "Back"
        backButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: Constants.helveticaThin, size: 18)!], for: .normal)
        backButton.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn shouldChangeTextInRange: NSRange, replacementText: String) -> Bool {
        if(replacementText.isEqual("\n")) {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func addTaskButtonTapped() {
        let uid = NSUUID().uuidString
        guard let taskName = addTaskView.taskNameField.text else { return }
        
        guard let taskDescription = addTaskView.taskDescriptionBox.text else { return }
        let newTask = Task(taskID: uid, taskName: taskName, taskDescription: taskDescription, taskCreated:NSDate().dateWithFormat(), taskDue:NSDate().dateWithFormat(), taskCompleted: false)
        
        
        schema.addTasks(task: newTask)
        
        navigationController?.popToRootViewController(animated: false)
    }
    
    func backTapped(sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: false)
    }
    
}
