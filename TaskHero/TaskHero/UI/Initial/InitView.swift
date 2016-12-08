//
//  InitView.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 11/26/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

typealias completion = () -> Void

class InitView: UIView {
    
    var animationDuration: Double = 0.8
    
    lazy var logoImageView: UIImageView = {
        let image = UIImage(named: "TaskHeroLogoNew2")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    lazy var loginButton: UIButton = {
        let button = ButtonType.login(title: "Login")
        var ui = button.newButton
        ui.isHidden = true
        return ui
    }()
    
    lazy var signupButton: UIButton = {
        let button = ButtonType.system(title:"Register Now", color:Constants.Init.signupButtonColor)
        var ui = button.newButton
        ui.isHidden = true
        return ui
    }()
    
    lazy var viewDivider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.isHidden = true
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.white
        frame = UIScreen.main.bounds
        setupConstraints()
    }
    
    func setupConstraints() {
        addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Logo.logoImageWidth).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier:Constants.Logo.logoImageHeight).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func zoomAnimation(_ handler: completion? = nil) {
        let duration: TimeInterval =  self.animationDuration * 0.7
        UIView.animate(withDuration: duration, animations:{
            self.logoImageView.transform = self.zoomOut()
            self.alpha = 0
        }, completion: { finished in
            DispatchQueue.main.async {
                let loginVC = UINavigationController(rootViewController:LoginViewController())
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = loginVC
            }
            handler?()
        })
    }
    
    fileprivate func zoomOut() -> CGAffineTransform {
        let zoomOutTranform: CGAffineTransform = CGAffineTransform(scaleX: 40, y: 40)
        return zoomOutTranform
    }
    
    
}