//
//  CustomSegmentedControll.swift
//  Todo
//
//  Created by Nikita Beglov on 15.09.2024.
//

import UIKit

protocol CustomSegmentControlDelegate: AnyObject {
    func segmentControl(_ segmentControl: CustomSegmentControl, didSelectSegmentAt index: Int)
}

final class CustomSegmentControl: UIView {
    weak var delegate: CustomSegmentControlDelegate?
    private let allButton = UIButton(type: .system)
    private let openButton = UIButton(type: .system)
    private let closedButton = UIButton(type: .system)
    private let separatorLine = UIView()
    
    var allCount: Int
    var openCount: Int
    var closeCount: Int
    
    init(allCount: Int, openCount: Int, closeCount: Int, frame: CGRect) {
        self.allCount = allCount
        self.openCount = openCount
        self.closeCount = closeCount
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCount(newAllCount: Int, newOpenCount: Int, newCloseCount: Int) {
        allCount = newAllCount
        openCount = newOpenCount
        closeCount = newCloseCount
        
        allButton.setTitle("\(Constants.allLabel) \(allCount)", for: .normal)
        openButton.setTitle("\(Constants.openLabel) \(openCount)", for: .normal)
        closedButton.setTitle("\(Constants.closedLabel) \(closeCount)", for: .normal)
    }
}

private extension CustomSegmentControl {
    func setupView() {
        configureButton(allButton, title: "\(Constants.allLabel) \(allCount)", isSelected: true)
        configureButton(openButton, title: "\(Constants.openLabel) \(openCount)", isSelected: false)
        configureButton(closedButton, title: "\(Constants.closedLabel) \(closeCount)", isSelected: false)
        
        separatorLine.backgroundColor = .systemGray4
        let stackView = UIStackView(arrangedSubviews: [allButton, separatorLine, openButton, closedButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorLine.heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: -10),
            separatorLine.widthAnchor.constraint(equalToConstant: 2),
        ])
        
        allButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        openButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        closedButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    func configureButton(_ button: UIButton, title: String, isSelected: Bool) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(isSelected ? .systemBlue : .systemGray3, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
    }

    @objc func buttonTapped(_ sender: UIButton) {
        [allButton, openButton, closedButton].forEach { button in
            configureButton(button, title: button.currentTitle ?? "", isSelected: false)
        }
        
        configureButton(sender, title: sender.currentTitle ?? "", isSelected: true)
        let selectedIndex = sender == allButton ? 0 : (sender == openButton ? 1 : 2)
        delegate?.segmentControl(self, didSelectSegmentAt: selectedIndex)
    }
}
