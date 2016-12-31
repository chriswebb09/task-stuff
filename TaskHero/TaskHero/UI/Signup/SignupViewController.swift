//
//  SignupViewController.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 9/28/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import Firebase

final class SignupViewController: UIViewController, UITextFieldDelegate {
    
    let store = DataStore.sharedInstance
    
    let signupView = SignupView()
    var emailInvalidated = false
    let CharacterLimit = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signupView)
        edgesForExtendedLayout = []
        navigationController?.navigationBar.tintColor = UIColor.white
        setupDelegate()
        signupView.signupButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.store.firebaseAPI.fetchValidUsernames()
    }
    
    private func setupDelegate() {
        signupView.layoutSubviews()
        signupView.emailField.delegate = self
        signupView.confirmEmailField.delegate = self
        signupView.usernameField.delegate = self
        signupView.passwordField.delegate = self
    }
}

extension SignupViewController {
    
    // Checks for character length (implemented for username length) if characters exceed allowed range, text field will no longer except new characters
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)  -> Bool {
        if textField == self.signupView.usernameField {
            let currentUserName = self.signupView.usernameField.text! as NSString
            let updatedText = currentUserName.replacingCharacters(in: range, with: string)
            return updatedText.characters.count <= CharacterLimit
        }
        return true
    }
}

extension SignupViewController {
    
    func handleRegister() {
        view.endEditing(true)
        let loadingView = LoadingView()
        guard let email = signupView.emailField.text, let password = signupView.passwordField.text, let username = signupView.usernameField.text else {
            loadingView.hideActivityIndicator(viewController:self)
            print("Form is not valid")
            return
        }
        
        if validateEmailInput(email:email, confirm:self.signupView.confirmEmailField.text!) {
            loadingView.showActivityIndicator(viewController: self)
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
                if error != nil {
                    loadingView.hideActivityIndicator(viewController: self)
                    print(error ?? "unable to get specific error")
                    return
                }
                guard (user?.uid) != nil else {
                    loadingView.hideActivityIndicator(viewController: self)
                    return
                }
                
                let newUser = self.createUser(username: username, email: email)
                
                self.store.firebaseAPI.registerUser(user: newUser)
                self.store.currentUserString = FIRAuth.auth()?.currentUser?.uid
                self.store.firebaseAPI.setupRefs()
                self.store.currentUser = newUser
                self.setupTabBar()
            }
        } else {
            let alertController = UIAlertController(title: "Invalid", message: "Something is wrong here.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { result in print("Okay") }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
    }
    
    fileprivate func setupTabBar() {
        let tabBar = TabBarController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBar
    }
    
    private func createUser(username:String, email:String) -> User {
        let newUser = User()
        newUser.username = username
        newUser.email = email
        newUser.profilePicture = "None"
        newUser.firstName = "N/A"
        newUser.lastName = "N/A"
        newUser.experiencePoints = 0
        newUser.tasks = [Task]()
        return newUser
    }
}
