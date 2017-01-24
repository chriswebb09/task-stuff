//
//  FriendsSettingsViewController+Extension.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 12/6/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension FriendsSettingsViewController {
    
    // MARK: - Delegate methods
    
    func popup() {
        alertPop.popView.isHidden = false
        friendsSettingsView.searchField.resignFirstResponder()
        alertPop.popView.layer.opacity = 0
        alertPop.containerView.isHidden = false
        alertPop.containerView.layer.opacity = Constants.Settings.dismissedOpacity
        alertPop.showPopView(viewController: self)
        UIView.animate(withDuration: 0.1) {
            self.alertPop.popView.layer.opacity = 1
            self.alertPop.containerView.layer.opacity = 0.1
        }
        alertPop.alertPopView.resultLabel.text = "No results found. Please try again later."
        alertPop.alertPopView.doneButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        alertPop.alertPopView.cancelButton.addTarget(self, action: #selector(dismissButton), for: .touchUpInside)
    }
    
    // Hides popover UI - prioritised to main thread when user hits dismiss button
    
    func dismissButton() {
        self.alertPop.popView.isHidden = true
        self.alertPop.containerView.isHidden = true
        self.alertPop.hidePopView(viewController: self)
        UINavigationController().popViewController(animated: false)
        
    }
    
    func hide() {
        self.alertPop.popView.isHidden = true
        self.alertPop.containerView.isHidden = true
        self.alertPop.hidePopView(viewController: self)
    }
}
