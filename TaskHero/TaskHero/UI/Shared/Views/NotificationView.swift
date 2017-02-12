import UIKit

final class NotificationView: BasePopView {

    var doneButton: UIButton = {
        var button = ButtonType.system(title: "Okay", color: .white)
        var uiElement = button.newButton
        uiElement.layer.cornerRadius = 0
        uiElement.backgroundColor = .gray
        return uiElement
    }()
    
    var dataLabel: UILabel = {
        let searchLabel = UILabel()
        searchLabel.textColor = .black
        searchLabel.text = "Please try again later."
        searchLabel.font = Constants.Font.fontNormal
        searchLabel.textAlignment = .center
        return searchLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headBanner.backgroundColor = .black
        backgroundColor = .white
        setupConstraints()
    }
}

extension NotificationView {
    
    private func addDataLabel() {
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        dataLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dataLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
        dataLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        dataLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: bounds.height / 3).isActive = true
    }
    
    private func addDoneButton() {
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
        doneButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
    }
    
    override func setupConstraints() {
        addSubview(dataLabel)
        addSubview(doneButton)
        super.setupConstraints()
        addDataLabel()
        addDoneButton()
    }
}
