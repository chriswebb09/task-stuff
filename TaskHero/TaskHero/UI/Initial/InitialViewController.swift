//
//  InitialViewController.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 11/26/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class InitialViewController: UIViewController {
    // MARK: - Deallocation from memory
    
    deinit {
        print("InitialViewController deallocated from memory")
    }
    let initView = InitView()
}

extension InitialViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.addSubview(initView)
        view.backgroundColor = UIColor.white
        initView.layoutSubviews()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let when = DispatchTime.now() + 0.5 //
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.initView.zoomAnimation({ })
        }
    }
}

extension InitialViewController {
    
    func loginButtonTapped() {
        navigationController?.pushViewController(LoginViewController(), animated: false)
    }
    
    func signupButtonTapped() {
        navigationController?.pushViewController(SignupViewController(), animated: false)
    }
}
