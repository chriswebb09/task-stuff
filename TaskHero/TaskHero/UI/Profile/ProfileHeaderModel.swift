//
//  ProfileHeaderModel.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 12/8/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol ProfileHeaderModel {
    var joinDate: String { get }
    var levelLabel: String { get }
    var profilePicture: String { get }
    var usernameLabel: String { get }
    var emailLabel: String { get }
}

struct ProfileHeaderCellModel {
    
    // MARK: - Internal Variables
    
    let store = UserDataStore.sharedInstance
    
    internal var emailLabel: String
    internal var usernameLabel: String
    internal var profilePicture: String
    internal var levelLabel: String
    internal var joinDate: String
    internal var joinDateIsHidden: Bool
    
    
    // MARK: - Initialization
    
    init() {
        
        
        if let user = self.store.currentUser {
            
            self.emailLabel = user.email
            self.usernameLabel = user.username
            if let profilePic = user.profilePicture {
                self.profilePicture = profilePic
            } else {
                profilePicture = "Void"
            }
            //self.profilePicture = user.profilePicture
            self.levelLabel = "Level: \(user.level)"
            self.joinDate = "Joined: \(user.joinDate)"
            self.joinDateIsHidden = true
        } else {
            self.emailLabel = "Void"
            self.usernameLabel = "Void"
            self.profilePicture = "Void"
            //self.profilePicture = user.profilePicture
            self.levelLabel = "Level: Void"
            self.joinDate = "Joined:  Void"
            self.joinDateIsHidden = true
        }
        
    }
    
}
