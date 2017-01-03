//
//  ProfileHeaderModel.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 12/8/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol ProfileHeaderModel {
    var user: User? { get set }
    var joinDate: String { get }
    var levelLabel: String { get }
    var profilePicture: String { get }
    var usernameLabel: String { get }
    var emailLabel: String { get }
}

class ProfileHeaderCellModel {
    
    // ================================
    // MARK: - Internal Variables
    // ================================
    
    let store = DataStore.sharedInstance
    
    internal var user: User?
    internal var emailLabel: String
    internal var usernameLabel: String
    internal var profilePicture: String
    internal var levelLabel: String
    internal var joinDate: String
    internal var joinDateIsHidden: Bool
    internal var profilePictureImage: UIImage? = nil
    
    // =======================================
    // MARK: - Initialization
    // =======================================
    
    init() {
        self.user = self.store.currentUser!
        self.emailLabel = (self.user?.email)!
        self.usernameLabel = (self.user?.username)!
        self.profilePicture = (self.user?.profilePicture!)!
        self.levelLabel = "Level: \((self.user?.level)!)"
        self.joinDate = "Joined: \((self.user?.joinDate)!)"
        self.joinDateIsHidden = true 
    }
    
    func getImage() {
        self.store.firebaseAPI.downloadImage(imageName: "1E0C05FD-9A19-4E93-B2D0-398515CC1BF2.png", completion: { profilePic in
            self.profilePictureImage = profilePic
        })
    }
}
