//
//  TaskCell.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 9/24/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit


protocol TaskCellDelegate: class {
   func toggleForEditState(sender:UIGestureRecognizer)
   func toggleForButtonState(sender:UIButton)
}

class TaskCell: UITableViewCell {
    
    static let cellIdentifier = "TaskCell"
    weak var delegate: TaskCellDelegate?
    var toggled:Bool = false
    var taskViewModel: TaskCellViewModel!
    
    // MARK: - Setup UI Elements
    
    let taskNameLabel: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.black
        textView.font = Constants.Font.bolderFontLarge
        textView.textAlignment = .left
        textView.layer.masksToBounds = true
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    var taskDescriptionBox: UITextView = {
        let taskDescriptionBox = UITextView()
        taskDescriptionBox.layer.borderWidth = Constants.Settings.searchButtonWidth
        taskDescriptionBox.layer.borderColor = UIColor.lightGray.cgColor
        taskDescriptionBox.layer.cornerRadius = Constants.Settings.searchFieldButtonRadius
        taskDescriptionBox.font = Constants.signupFieldFont
        taskDescriptionBox.contentInset = Constants.TaskCell.boxInset
        return taskDescriptionBox
    }()
    
    let taskDescriptionLabel: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = Constants.TaskCell.descriptionLabelBackgroundColor
        textView.textColor = UIColor.white
        textView.layer.cornerRadius = Constants.TaskCell.cornerRadius
        textView.font = Constants.Font.fontMedium
        textView.textAlignment = .left
        textView.layer.masksToBounds = true
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let taskDueLabel: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.black
        textView.font = Constants.Font.fontMedium
        textView.textAlignment = .left
        textView.layer.masksToBounds = true
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    var taskCompletedView: UIImageView = {
        let taskCompletedImageView = UIImageView()
        taskCompletedImageView.isUserInteractionEnabled = true
        return taskCompletedImageView
    }()
    
    var saveButton: UIButton = {
        let button = ButtonType.system(title: "Save", color: UIColor.babyBlueColor())
        var ui = button.newButton
        ui.isHidden = true
        ui.isEnabled = false
        return ui
    }()
}

extension TaskCell {
    
    // MARK: - Initialization
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        contentView.layer.masksToBounds = true
    }
    
    // MARK: - Configure cell
    
    func configureView(view:UIView) {
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: Constants.TaskCell.nameLabelHeight).isActive = true
    }
    
    func configureDesription(view:UIView) {
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: Constants.TaskCell.descriptionBoxHeight).isActive = true
        view.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Constants.TaskCell.descriptionLabelWidth).isActive = true
    }
    
    func setupConstraints() {
        configureView(view: taskNameLabel)
        taskNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Constants.TaskCell.dueWidth).isActive = true
        taskNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.TaskCell.nameLabelTopOffset).isActive = true
        taskNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant:Constants.TaskCell.nameLabelLeftOffset).isActive = true

        configureView(view: taskDueLabel)
        taskDueLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Constants.TaskCell.dueWidth).isActive = true
        taskDueLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        taskDueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant:Constants.TaskCell.dueTopOffset).isActive = true
        
        configureDesription(view: taskDescriptionLabel)
        taskDescriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        taskDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.TaskCell.descriptionsLabelBottomOffset).isActive = true
        
        contentView.addSubview(taskCompletedView)
        taskCompletedView.translatesAutoresizingMaskIntoConstraints = false
        taskCompletedView.heightAnchor.constraint(equalToConstant: Constants.TaskCell.completedHeight).isActive = true
        taskCompletedView.widthAnchor.constraint(equalToConstant: Constants.TaskCell.completedHeight).isActive = true
        taskCompletedView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: Constants.TaskCell.completedViewRightOffset).isActive = true
        taskCompletedView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.TaskCell.completedTopOffset).isActive = true
        
        contentView.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.heightAnchor.constraint(equalToConstant: Constants.TaskCell.saveButtonHeight).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: Constants.TaskCell.saveButtonWidth).isActive = true
        saveButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: Constants.TaskCell.saveButtonRightOffset).isActive = true
        saveButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.TaskCell.saveButtonTopOffset).isActive = true
        
        configureDesription(view: taskDescriptionBox)
        taskDescriptionBox.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        taskDescriptionBox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.TaskCell.descriptionsLabelBottomOffset).isActive = true
    }
    
    func configureCell(taskVM:TaskCellViewModel, toggled:Bool) {
        taskDescriptionBox.isHidden = true
        taskNameLabel.text = taskVM.taskName
        taskDueLabel.text = "Due date: \(taskVM.taskDue)"
        taskDescriptionLabel.text = taskVM.taskDescription
        self.toggled = toggled
        saveButton.addTarget(self, action: #selector(toggleForButtonState(sender:)), for: .touchUpInside)
        layoutSubviews()
        styleAppearance()

        
        if taskVM.taskCompleted == "true" {
            taskCompletedView.image = UIImage(named:"checked")
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleForEditState))
            taskCompletedView.addGestureRecognizer(tap)
            saveButton.addTarget(self, action: #selector(toggleForEditState), for: .touchUpInside)
        } else {
            taskCompletedView.image = UIImage(named:"edit")
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleForEditState))
            taskCompletedView.addGestureRecognizer(tap)
        }
        layoutMargins = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
        contentView.backgroundColor = UIColor.clear
    }
    
    func setupCellView(width: CGFloat, height: CGFloat) {
        let cellView : UIView = UIView(frame: CGRect(x:0, y:1, width:width, height:height))
        cellView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 1.0])
        cellView.layer.masksToBounds = false
        cellView.layer.cornerRadius = Constants.TaskCell.cornerRadius
        cellView.layer.shadowOffset = Constants.TaskCell.shadowOffset
        cellView.layer.shadowOpacity = Constants.TaskCell.styledShadowOpacity
        contentView.addSubview(cellView)
        contentView.sendSubview(toBack: cellView)
    }
    
    
   
    
    //func namePickerView(_ namePickerView: NamePickerView, didSelectName name: String)
    //func namePickerViewShouldReload(_ namePickerView: NamePickerView) -> Bool
    
    func styleAppearance() {
        layer.masksToBounds = false
        layer.shadowOffset = Constants.TaskCell.styledShadowRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = Constants.TaskCell.shadowRadius
        layer.shadowOpacity = Constants.TaskCell.shadowOpacity
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taskNameLabel.text = ""
        taskDescriptionLabel.text = ""
    }
    
}
