//
//  SettingsViewController.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 9/29/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    let userSettings = ["Username", "Email", "First Name", "Last Name", "Tasks Completed", "Friends"]
    let applicationSettings = ["Notifications", "Log Out", "Stay Logged In"]
    let segmentControl = UISegmentedControl(items: ["User Settings", "Application Settings"])
    var settings = [String]()
    let pop = PopMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings = userSettings
        
        edgesForExtendedLayout = []
        view.addSubview(segmentControl)
        setupSegment()
        setupTableView()
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.cellIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsCell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.cellIdentifier, for: indexPath as IndexPath) as! SettingsCell
        settingsCell.configureCell(setting: settings[indexPath.row])
        return settingsCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        pop.showPopView(viewController: self)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideView))
        pop.containerView.addGestureRecognizer(tap)
        //   if settings[indexPath.row] ==
        //        print(settings[indexPath.row])
        //        let alertController = UIAlertController(title: "Invalid", message: "\(settings[indexPath.row])", preferredStyle: UIAlertControllerStyle.alert)
        //        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        //            print("OK")
        //        }
        //        alertController.addAction(okAction)
        //        self.present(alertController, animated: true, completion: nil)
        // return
    }
    
    
    func hideView() {
        pop.hidePopView(viewController: self)
    }
}

extension SettingsViewController {
    func changeView(sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            settings = userSettings
        default:
            settings = applicationSettings
        }
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    func setupSegment() {
        let multipleAttributes: [String : Any] = [
            NSForegroundColorAttributeName: UIColor.blue]
        
        let multipleUnselectedAttributes: [String : Any] = [
            NSForegroundColorAttributeName: UIColor.lightGray]
        segmentControl.tintColor = UIColor.clear

        segmentControl.setTitleTextAttributes(multipleAttributes, for: .selected)
        segmentControl.setTitleTextAttributes(multipleUnselectedAttributes, for:.normal)
        segmentControl.layer.borderWidth = 1
        segmentControl.layer.borderColor = UIColor.gray.cgColor
        segmentControl.layer.cornerRadius = 8
        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.01).isActive = true
        segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.96).isActive = true
        segmentControl.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:Constants.loginFieldHeight).isActive = true
        segmentControl.addTarget(self, action: #selector(changeView), for: .valueChanged)
        
        
    }
    
    
}