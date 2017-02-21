//
//  HomeViewController.swift
//  TaskHero
//

import UIKit

/* HomeViewController is the first tab in the tabbar. It is a tableView that consists of a ProfileHeaderCell at indexPath.row 0
 - All other cells are of type TaskCell */

final class HomeViewController: UITableViewController, UINavigationControllerDelegate {
    
    var homeViewModel: HomeViewModel
    
    var taskMethods = SharedTaskMethods()
    var profileMethods = SharedProfileMethods()
    
    let backgroundQueue = DispatchQueue(label: "com.taskhero.queue", qos: .background, target: nil)
    
    let photoPopover = PhotoPickerPopover()
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        barSetup()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder)
    }
    
    init(_ coder: NSCoder? = nil) {
        self.homeViewModel = HomeViewModel()
        if let coder = coder {
            super.init(coder: coder)!
        } else {
            super.init(nibName: nil, bundle:nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskMethods.fetchUser(tableView: tableView)
        super.viewWillAppear(false)
    }
    
    /*  Removes reference to database - necessary to prevent duplicate task cells from loading when viewWillAppear is called again.
     -> Functionality implemented in helper class */
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        homeViewModel.removeRefHandle()
    }
    
    /* Registers cells to tableview, sets background color for view, sets picker delegate to self(HomeViewController), extends layout to start
     below navbar, adds button items to navcontroller navbar
     -> called in viewDidLoad */
    
    func viewSetup() {
        registerCellsToTableView()
        taskMethods.setupTableView(tableView: tableView, view: view)
        view.backgroundColor = Constants.Color.tableViewBackgroundColor.setColor
        picker.delegate = self
        edgesForExtendedLayout = []
    }
    
    func barSetup() {
        let rightBarImage: UIImage = SharedMethods.getAddTaskImage()
        let leftBarItem = SharedMethods.getLeftBarItem(selector: #selector(logoutButtonPressed), viewController: self)
        let rightBarItem = SharedMethods.getRightBarItem(image: rightBarImage, selector: #selector(addTaskButtonTapped), viewController: self)
        SharedMethods.setupNavItems(navigationItem: navigationItem, leftBarItem: leftBarItem, rightItem: rightBarItem)
    }
    
    func registerCellsToTableView() {
        tableView.register(ProfileHeaderCell.self, forCellReuseIdentifier: ProfileHeaderCell.cellIdentifier)
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.cellIdentifier)
    }
}

// MARK: - UITableViewController Methods

extension HomeViewController {
    
    /* Returns number of rows from view model based on task count in currentUser */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.numberOfRows
    }
    
    /* Gets rowheight from view model and returns it - rowheight is UITableViewAutomaticDimension */
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return homeViewModel.rowHeight
    }
    
    /* If first row returns profile headerCell else returns taskCell
     -> all cells configured within HomeViewController using setupCell methods */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type: HomeCellType = indexPath.row > 0 ? .task : .header
        switch type {
        case .task:
            let taskCell = tableView.dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as! TaskCell
            setupTaskCell(taskCell: taskCell, taskIndex: indexPath.row)
            taskCell.delegate = self
            return taskCell
        case .header:
            let headerCell = tableView.dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as! ProfileHeaderCell
            setupHeaderCell(headerCell: headerCell, indexPath: indexPath)
            headerCell.delegate = self
            if homeViewModel.profilePic != nil { headerCell.profilePicture.image = homeViewModel.profilePic! }
            return headerCell
        }
    }
}

// MARK: - Extension for setting up cells & TaskCell delegate logic implementation

extension HomeViewController {
    
    func setupHeaderCell(headerCell: ProfileHeaderCell, indexPath: IndexPath) {
        headerCell.emailLabel.isHidden = true
        if let user = homeViewModel.user { headerCell.configureCell(user: user) }
        let tap = UIGestureRecognizer(target:self, action: #selector(profilePictureTapped(sender:)))
        headerCell.profilePicture.addGestureRecognizer(tap)
    }
    
    func setupTaskCell(taskCell:TaskCell, taskIndex: Int) {
        let taskViewModel = homeViewModel.getViewModelForTask(taskIndex: taskIndex)
        taskCell.configureCell(taskVM: taskViewModel)
        taskCell.tag = taskIndex
        addInteractionToCell(cell: taskCell)
    }
    
    func addInteractionToCell(cell: TaskCell) {
        let tap = UIGestureRecognizer(target:self, action: #selector(toggleForEditState(_:)))
        cell.taskCompletedView.addGestureRecognizer(tap)
    }
}

// MARK: - Delete Task logic

extension HomeViewController {
    
    /* Cannot edit cell at tableview index row 0 */
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let editable: Bool = indexPath.row == 0 ? false : true
        return editable
    }
    
    /* Logic for deleting tasks from database when user deletes tableview cell */
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            backgroundQueue.async {
                self.taskMethods.deleteTask(indexPath: indexPath, tableView: self.tableView, type: .home)
                self.taskMethods.fetchUser(tableView: self.tableView)
            }
            tableView.endUpdates()
        }
    }
}

// MARK: Selector Methods

extension HomeViewController {
    
    func logoutButtonPressed() {
        setupUserDefaults()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = UINavigationController(rootViewController:AppScreenViewController())
    }
    
    func setupUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "hasLoggedIn")
        defaults.synchronize()
    }
    
    func addTaskButtonTapped() {
        navigationController?.pushViewController(AddTaskViewController(), animated:false)
    }
}

// MARK:  TaskCell Delegate Methods
/* Methods for toggling taskCell edit state. */

extension HomeViewController: TaskCellDelegate {
    
    func toggleForButtonState(_ sender:UIButton) {
        let superview = sender.superview
        let cell = superview?.superview as! TaskCell
        let indexPath = tableView.indexPath(for: cell)
        if let index = indexPath {
            taskMethods.tapEdit(viewController: self, tableView: tableView, atIndex: index, type: .home)
        }
    }
    
    /* Kicks off cycling between taskcell editing states */
    
    func toggleForEditState(_ sender:UIGestureRecognizer) {
        let tapLocation = sender.location(in: self.tableView)
        let tapIndex = tableView.indexPathForRow(at: tapLocation)
        if let index = tapIndex {
            taskMethods.tapEdit(viewController: self, tableView: tableView, atIndex:index, type: .home)
        }
    }
}

// MARK: - ProfileHeaderCell Delegate Method

extension HomeViewController: ProfileHeaderCellDelegate {
    
    internal func hidePopoverView() {
        photoPopover.hidePopView(viewController: self)
    }
    
    internal func profilePictureTapped(sender: UIGestureRecognizer) {
        photoPopover.showPopView(viewController: self)
        photoPopover.photoPopView.button.addTarget(self, action: #selector(tapPickPhoto(_:)), for: .touchUpInside)
    }
}

// Mark: Extension for UIImagePicker Delegate

extension HomeViewController: UIImagePickerControllerDelegate {
    
    func selectImage(picker: UIImagePickerController, viewController: UIViewController) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        viewController.present(picker, animated: true, completion: nil)
    }
    
    internal func tapPickPhoto(_ sender:UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        photoPopover.hideView(viewController: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            homeViewModel.profilePic = image
        } else {
            print("Something went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
}
