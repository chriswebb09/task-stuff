import UIKit

final class ProfileSettingsViewController: UIViewController,  UITableViewDataSource {
    
    // MARK: - Properties
    
    let store = UserDataStore.sharedInstance
    let profileSettingsView = ProfileSettingsView()
    var tapped: Bool = false
    var indexTap: IndexPath?
    let tableView = UITableView()
    let dataSource = ProfileSettingsViewControllerDataSource()
    var options = ["Email Address", "Name", "Profile Picture", "Username"]
    var username: String?
    var email: String?
    
}

extension ProfileSettingsViewController: UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        options = [self.store.currentUser.email,
                   "\(self.store.currentUser.firstName!) \(self.store.currentUser.lastName!)",
                    "Profile Picture", self.store.currentUser.username
                ]
        edgesForExtendedLayout = []
        setupTableViewDelegates()
        setupSubviews()
        profileSettingsView.layoutSubviews()
        dataSource.setupViews(profileSettingsView: profileSettingsView, tableView: tableView, view: view)
        tableView.setupTableView(view: view)
        //setupTableView(tableView: tableView)
        tableView.separatorColor = .black
    }
    
    
//    func setupTableView(tableView: UITableView) {
//        tableView.tableFooterView = UIView(frame: .zero)
//        tableView.separatorStyle = .singleLineEtched
//        tableView.allowsSelection = false
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = view.frame.height / 4
//        tableView.layoutMargins = UIEdgeInsets.zero
//        tableView.separatorInset = UIEdgeInsets.zero
//    }
//    
    func setupTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupSubviews() {
        view.addSubview(profileSettingsView)
        view.addSubview(tableView)
        tableView.register(ProfileSettingsCell.self, forCellReuseIdentifier: ProfileSettingsCell.cellIdentifier)
    }
}

extension ProfileSettingsViewController: UITextFieldDelegate, ProfileSettingsCellDelegate {
    
    // MARK: UITableViewController Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(options)
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSettingsCell.cellIdentifier, for: indexPath as IndexPath) as! ProfileSettingsCell
        cell.configureCell(setting: options[indexPath.row])
        
        cell.delegate = self
        cell.button.index = indexPath
        cell.button.tag = indexPath.row
        
        cell.button.addTarget(self, action:#selector(connected(sender:)), for: .touchUpInside)
        return cell
    }
    
    dynamic fileprivate func connected(sender: TagButton){
        indexTap = sender.index
        tapEdit()
    }
    
    fileprivate func tapEdit() {
        let tapCell = tableView.cellForRow(at: indexTap!) as! ProfileSettingsCell
        if tapped == true {
            tapped = false
            if (tapCell.profileSettingField.text?.characters.count)! > 0 {
                guard let name = tapCell.profileSettingField.text?.components(separatedBy: " ") else { return }
                if indexTap?.row == 1 {
                    dataSource.updateUserName(cell: tapCell, name: name)
                } else if indexTap?.row == 3 {
                    dataSource.updateUserName(cell: tapCell, name: name)
                }
                tapCell.profileSettingLabel.text = tapCell.profileSettingField.text
            } else {
                if let tap = indexTap {
                    tapCell.profileSettingLabel.text = options[tap.row]
                }
            }
            tapCell.profileSettingField.isHidden = true
            tapCell.profileSettingLabel.isHidden = false
        } else if tapped == false { tapped = true
            tapCell.profileSettingLabel.isHidden = true
            tapCell.profileSettingField.isHidden = false
        }
    }
    
    fileprivate func separateNames(name:String) -> [String] {
        let nameArray = name.components(separatedBy: " ")
        return nameArray
    }
    
    func editButtonTapped() {
        tapped = true
    }
}

