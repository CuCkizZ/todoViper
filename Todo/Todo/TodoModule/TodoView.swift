//
//  TodoView.swift
//  Todo
//
//  Created by Nikita Beglov on 14.09.2024.
//

import UIKit

private let namePlaycholder = "Your task"
private let groupPlaycholder = "Group"
private let saveButtonTitle = "Save"
private let deleteButtonTitle = "Delete"
private let closeImageName = "xmark.circle"

protocol TodoViewProtocol: AnyObject {
    func groupsFetched()
}

final class TodoView: UIViewController {
    var presenter: TodoPresenterProtocol?
    var userManager = UserManager.shared
    var model: TodoEntity?
    
    private lazy var todoTextField = UITextField()
    private lazy var groupTextField = UITextField()
    private lazy var datePicker = UIDatePicker()
    private lazy var fromTimePicker = UIDatePicker()
    private lazy var toTimePicker = UIDatePicker()
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(saveButtonTitle, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(deleteButtonTitle, for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(deleteTodo), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: closeImageName), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(closeButtobTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [datePicker, fromTimePicker, toTimePicker])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [todoTextField, groupTextField, 
                                                   dateStackView, saveButton, deleteButton])
        stack.backgroundColor = .white
        stack.axis = .vertical
        stack.spacing = 16
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        stack.layer.cornerRadius = 12
        stack.alignment = .center
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        setupLayout()
    }

    func configuration(model: TodoEntity) {
        self.model = model
        todoTextField.text = model.name
        groupTextField.text = model.group
        datePicker.date = model.date ?? Date()
        fromTimePicker.date = model.fromTime ?? Date()
        toTimePicker.date = model.toTime ?? Date()
    }
}

private extension TodoView {
    func setupLayout() {
        setupView()
        setupTextFields()
        setupPickers()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .systemGray6
        view.addSubview(stackView)
        view.addSubview(closeButton)
    }
    
    func setupPickers() {
        datePicker.datePickerMode = .date
        fromTimePicker.datePickerMode = .time
        toTimePicker.datePickerMode = .time
    }
    
    func setupTextFields() {
        let todoPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: todoTextField.frame.height))
        let groupPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: groupTextField.frame.height))
        todoTextField.layer.cornerRadius = 12
        todoTextField.layer.borderWidth = 1
        todoTextField.layer.borderColor = CGColor(gray: 0.8, alpha: 1)
        todoTextField.backgroundColor = .white
        todoTextField.placeholder = namePlaycholder
        todoTextField.leftView = todoPaddingView
        todoTextField.leftViewMode = .always
        
        
        groupTextField.layer.borderWidth = 1
        groupTextField.layer.borderColor = CGColor(gray: 0.8, alpha: 1)
        groupTextField.layer.cornerRadius = 12
        groupTextField.backgroundColor = .white
        groupTextField.placeholder = groupPlaycholder
        groupTextField.leftView = groupPaddingView
        groupTextField.leftViewMode = .always
        groupTextField.clearButtonMode = .whileEditing
    }
    
    @objc func deleteTodo() {
        guard let model = self.model else { return }
        presenter?.deleteTodo(model: model )
        presenter?.dismiss()
    }
    
    @objc func saveAction() {
        if model?.name == nil {
            presenter?.saveNewTodo(name: todoTextField.text ?? "",
                                   group: groupTextField.text ?? "",
                                   date: datePicker.date,
                                   fromTime: fromTimePicker.date,
                                   toTime: toTimePicker.date,
                                   comleted: false)
            self.userManager.isFirstLoad = false

            presenter?.dismiss()
        } else {
            self.model?.updateTodo(newName: todoTextField.text ?? "",
                                   newGroup: groupTextField.text ?? "",
                                   newDate: datePicker.date,
                                   fromNewTime: fromTimePicker.date,
                                   toNewTime: toTimePicker.date)
            presenter?.dismiss()
        }
    }
    
    @objc func closeButtobTapped() {
        presenter?.dismiss()
    }
    
    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        todoTextField.translatesAutoresizingMaskIntoConstraints = false
        groupTextField.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        dateStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300),
           // stackView.heightAnchor.constraint(equalToConstant: 300),
            
//            todoTextField.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 16),
            todoTextField.widthAnchor.constraint(equalToConstant: 270),
            todoTextField.heightAnchor.constraint(equalToConstant: 30),
            groupTextField.widthAnchor.constraint(equalToConstant: 270),
            groupTextField.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
}

extension TodoView: TodoViewProtocol {
    func groupsFetched() {
        
    }
}
