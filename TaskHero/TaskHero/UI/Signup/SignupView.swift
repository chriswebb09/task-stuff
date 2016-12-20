//
//  SignupView.swift
//  TaskTiger
//
//  Created by Christopher Webb-Orenstein on 9/24/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class SignupView: UIView {
    
    lazy var signupViewLabel: UILabel = {
        let signupViewLabel = UILabel()
        signupViewLabel.textColor = UIColor.black
        signupViewLabel.text = "Become a Member"
        signupViewLabel.font = Constants.Font.fontLarge
        signupViewLabel.textAlignment = .center
        return signupViewLabel
    }()
    
    lazy var usernameField: TextFieldExtension = {
        let emailField = TextFieldExtension().emailField(placeholder: "Choose a username")
        return emailField
    }()
    
    lazy var emailField: TextFieldExtension = {
        let emailField = TextFieldExtension().emailField(placeholder: "Enter email address")
        return emailField
    }()
    
    lazy var confirmEmailField: TextFieldExtension = {
        let emailField = TextFieldExtension().emailField(placeholder: "Confirm email address")
        return emailField
    }()
    
    lazy var passwordField: TextFieldExtension = {
        let passwordField = TextFieldExtension().passwordField()
        return passwordField
    }()
    
    lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Constants.Login.loginButtonColor
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Constants.Font.fontNormal
        return button
    }()
}

extension SignupView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.white
        frame = UIScreen.main.bounds
        setupConstraints()
    }
    
    func configureField(field: UIView) {
        addSubview(field)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.widthAnchor.constraint(equalTo:widthAnchor, multiplier: Constants.Login.loginFieldWidth).isActive = true
        field.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.Login.loginFieldHeight).isActive = true
        field.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    // sets up constraints on signupview
    
    fileprivate func setupConstraints() {
        configureField(field: signupViewLabel)
        signupViewLabel.topAnchor.constraint(equalTo: topAnchor , constant: bounds.height * Constants.Signup.entryFieldTopOffset).isActive = true
        configureField(field: usernameField)
        usernameField.topAnchor.constraint(equalTo:signupViewLabel.bottomAnchor, constant: bounds.height * Constants.Signup.entryFieldTopOffset).isActive = true
        configureField(field: emailField)
        emailField.topAnchor.constraint(equalTo:usernameField.bottomAnchor, constant: bounds.height * Constants.Signup.entryFieldTopOffset).isActive = true
        configureField(field: confirmEmailField)
        confirmEmailField.topAnchor.constraint(equalTo:emailField.bottomAnchor, constant: bounds.height * Constants.Signup.entryFieldTopOffset).isActive = true
        configureField(field: passwordField)
        passwordField.topAnchor.constraint(equalTo:confirmEmailField.bottomAnchor, constant: bounds.height * Constants.Signup.entryFieldTopOffset).isActive = true
        passwordField.isSecureTextEntry = true
        addSubview(signupButton)
        configureField(field: signupButton)
        signupButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: bounds.height * Constants.Signup.buttonTopOffset).isActive = true
    }
}
