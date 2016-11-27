//
//  DataStore.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 9/28/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import Firebase

class DataStore {
    static let sharedInstance = DataStore()
    
    let manager = AppManager.sharedInstance
    
    var currentUser: User!
    var currentUserString: String!
    var tasks = [Task]()
    
    var tasksRef: FIRDatabaseReference!
    var ref: FIRDatabaseReference!
    var refHandle: FIRDatabaseHandle!
    var validUsernames = [String]()
    var validUserData = [String]()
    
    var userData = Dictionary<String, AnyObject>()
    var usernameEmailDict = Dictionary<String, AnyObject>()
    var tasksDict = Dictionary<String, AnyObject>()
    
    var dataSnapshot = [FIRDataSnapshot]()
    var dbRef: FIRDatabaseReference!
    var userRef: FIRDatabaseReference!
    var usernameRef: FIRDatabaseReference!
    var auth = Auth()
    
    
    deinit {
        ref.removeObserver(withHandle: refHandle)
    }
    
    init() {
        dbRef = FIRDatabase.database().reference()
        userRef = dbRef.child("Users")
        usernameRef = dbRef.child("Usernames")
        tasksRef = userRef
    }
    
    func fetchData(handler: @escaping (User) -> Void) {
        if currentUserString == nil {
            currentUserString = currentUser.uid
            auth.fetchUser(with: currentUserString, handler: { user in
                self.manager.userIsLoggedIn(loggedIn: true, uid: user.uid)
                self.currentUser = user
                self.fetchTasks(completion: { task in
                    self.tasks.append(task)
                })
                self.currentUser.tasks = self.tasks
                self.manager.setUserData(user: self.currentUser)
                handler(user)
            })
        }
    }
    
    func fetchValidUsernames() {
        validUsernames.removeAll()
        usernameRef.observe(.childAdded, with: { snapshot in
            self.validUsernames.append(snapshot.key)
            self.usernameEmailDict[snapshot.key] = snapshot.value as AnyObject?
        })
    }
    
    func insertUser(user:User) {
        let userData: NSDictionary = ["Email": user.email,
                                      "FirstName": user.firstName ?? " ",
                                      "LastName": user.lastName ?? " ",
                                      "ProfilePicture": user.profilePicture ?? " ",
                                      "ExperiencePoints": user.experiencePoints ?? 0,
                                      "Level": user.level,
                                      "JoinDate": user.joinDate,
                                      "Username": user.username,
                                      "TasksCompleted": user.numberOfTasksCompleted ?? 0]
        userRef.updateChildValues(["/\(self.currentUserString!)": userData])
        usernameRef.updateChildValues([user.username:user.email])
    }
    
    func fetchTasks(completion:@escaping (_ task:Task) -> Void) {
        tasksRef = userRef.child(currentUserString).child("Tasks")
        refHandle = tasksRef.observe(.childAdded, with: { snapshot in
            guard let snapshotValue = snapshot.value as? [String: AnyObject] else { return }
            let newTask = Task()
            newTask.taskID = snapshot.key
            print(newTask.taskID)
            if let fetchName = snapshotValue["TaskName"] as? String {
                newTask.taskName = fetchName
            }
            if let fetchDescription = snapshotValue["TaskDescription"] as? String {
                newTask.taskDescription = fetchDescription
            }
            if let fetchCreated = snapshotValue["TaskCreated"] as? String {
                newTask.taskCreated = fetchCreated
            }
            if let fetchDue = snapshotValue["TaskDue"] as? String {
                newTask.taskDue = fetchDue
            }
            if let fetchCompleted = snapshotValue["TaskCompleted"] as? Bool {
                newTask.taskCompleted = fetchCompleted
            }
            completion(newTask)
        })
        
    }

    func addTasks(task:Task) {
        tasksRef = userRef.child(currentUserString!).child("Tasks")
        tasksRef.child("\(task.taskID)/TaskName").setValue(task.taskName)
        tasksRef.child("\(task.taskID)/TaskDescription").setValue(task.taskDescription)
        tasksRef.child("\(task.taskID)/TaskCreated").setValue(task.taskCreated)
        tasksRef.child("\(task.taskID)/TaskDue").setValue(task.taskDue)
        tasksRef.child("\(task.taskID)/TaskCompleted").setValue(task.taskDue)
    }
    
    func removeTask(ref:String, taskID: String) {
        tasksRef = userRef.child(currentUserString).child("Tasks")
        tasksRef.child(ref).removeValue()
    }
}
