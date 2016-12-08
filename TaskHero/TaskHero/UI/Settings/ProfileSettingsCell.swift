//
//  ProfileSettingsCell.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 11/27/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol ProfileSettingsCellDelegate: class {
    func editButtonTapped()
}

final class ProfileSettingsCell: UITableViewCell, ProfileSettingsCellDelegate {
    
    static let cellIdentifier = "ProfileSettingsCell"
    
    var delegate: ProfileSettingsCellDelegate?
    
    // MARK: - UIElements
    
    let profileSettingLabel: UILabel = {
        let profileLabel = UILabel()
        
        profileLabel.textColor = UIColor.settingsBackground()
        profileLabel.font = Constants.Font.fontNormal
        profileLabel.textAlignment = .left
        profileLabel.layer.masksToBounds = true
        
        return profileLabel
    }()
    
    let button: TagButton = {
        let button = ButtonType.tag(title: "Edit", color: UIColor.blue, tag: 20, index: IndexPath())
        let uiElement = button.tagButton
        uiElement.layer.borderWidth = 0
        return uiElement
    }()
    
    lazy var profileSettingField: TextFieldExtension = {
        let taskNameField = TextFieldExtension()
        
        taskNameField.font = Constants.signupFieldFont
        taskNameField.layer.borderColor = UIColor.lightGray.cgColor
        taskNameField.layer.cornerRadius = Constants.Settings.searchFieldButtonRadius
        taskNameField.layer.borderWidth = Constants.Settings.profileSearchButtonBorderWidth
        taskNameField.isHidden = true
        
        return taskNameField
    }()
    
}

extension ProfileSettingsCell {
    
    // MARK: - Initalization
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        selectionStyle = UITableViewCellSelectionStyle.none
        contentView.layer.masksToBounds = true
    }
    
    fileprivate func setupConstraints() {
        contentView.addSubview(profileSettingLabel)
        profileSettingLabel.translatesAutoresizingMaskIntoConstraints = false
        profileSettingLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier:Constants.Settings.profileSettingsLabelHeight).isActive = true
        profileSettingLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Constants.Settings.profileSettingsLabelWidth).isActive = true
        profileSettingLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.width * Constants.Settings.profileSettingsLeftOffset).isActive = true
        profileSettingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: Constants.Settings.profileSettingsLabelHeight).isActive = true
        button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Constants.Settings.profileViewHeightAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(profileSettingField)
        profileSettingField.translatesAutoresizingMaskIntoConstraints = false
        profileSettingField.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: Constants.Settings.labelHeight).isActive = true
        profileSettingField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Constants.Settings.labelHeight).isActive = true
        profileSettingField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.width * Constants.Settings.profileSettingsFieldCenterYAnchor).isActive = true
        profileSettingField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    // MARK: - Delegate Methods
    
    func configureCell(setting:String) {
        layoutSubviews()
        profileSettingLabel.text = setting
        if setting.contains("N/A") {
            profileSettingLabel.text = "FirstName LastName"
        }
        profileSettingField.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileSettingLabel.text = ""
    }
    
    func editButtonTapped() {
        delegate?.editButtonTapped()
        profileSettingLabel.isHidden = true
        profileSettingField.isHidden = false
        print("profile pic tapped\n\n\n\n\n\n")
    }
}
