//
//  TaskListCell.swift
//  Todo
//
//  Created by Nikita Beglov on 14.09.2024.
//

import UIKit

protocol TaskListCellDelegate: AnyObject {
    func didTapDoneButton(in cell: TaskListCell, task: TodoEntity, isDone: Bool)
}

final class TaskListCell: UICollectionViewCell {
    static let reuseID = "cell"
    weak var delegate: TaskListCellDelegate?
    private var task: TodoEntity?
    
    private lazy var headerTaskLabel = UILabel()
    private lazy var detailtTaskLabel = UILabel()
    private lazy var dateTaskLabel = UILabel()
    private lazy var timeTaskLabel = UILabel()
    private lazy var separatorView = UIView()
    private lazy var doneTaskButton = UIButton(type: .system)
    var isDone: Bool = false {
        didSet {
            let image = isDone ? UIImage(systemName: CellConstants.doneImage) :
            UIImage(systemName:CellConstants.defaultImage)
            doneTaskButton.setImage(image, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: TodoEntity) {
        task = model
        isDone = model.completed
        print(isDone)
        headerTaskLabel.text = model.name
        detailtTaskLabel.text = model.group
        
        if let fromTime = model.fromTime, let toTime = model.toTime {
            timeTaskLabel.text = timeFormatter(time: fromTime) + " - " + timeFormatter(time: toTime)
        }
        
        if let todoDate = model.date {
            if isToday(todoDate) {
                dateTaskLabel.text = CellConstants.dayToday
            } else {
                dateTaskLabel.text = dateFormatter(date: todoDate)
            }
        }
        checkTask()
    }
    
    func configureOnline(model: CellDataModel) {
        self.isDone = model.completed
        headerTaskLabel.text = model.todo
        checkTask()
    }
}

private extension TaskListCell {
    func setupLayout() {
        setupView()
        setupLabels()
        setupButton()
        setupSeparator()
        setupConstraints()
    }
    
    func setupView() {
        layer.cornerRadius = 12
        addSubview(headerTaskLabel)
        addSubview(detailtTaskLabel)
        addSubview(dateTaskLabel)
        addSubview(timeTaskLabel)
        addSubview(separatorView)
        contentView.addSubview(doneTaskButton)
    }
    
    func setupLabels() {
        headerTaskLabel.numberOfLines = 2
        headerTaskLabel.font = UIFont.systemFont(ofSize: CellConstants.defaultTextSize + 4)
        detailtTaskLabel.font = UIFont.systemFont(ofSize: CellConstants.defaultTextSize, weight: UIFont.Weight.bold)
        detailtTaskLabel.textColor = .systemGray
        dateTaskLabel.font = UIFont.systemFont(ofSize: CellConstants.dateTextSize, weight: UIFont.Weight.regular)
        dateTaskLabel.textColor = .systemGray
        timeTaskLabel.font = UIFont.systemFont(ofSize:CellConstants.dateTextSize, weight: UIFont.Weight.regular)
        timeTaskLabel.textColor = .systemGray4
    }
    
    func setupButton() {
        doneTaskButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
    }
    
    @objc func buttonTapped() {
        guard let task = task else { return }
        guard let text = headerTaskLabel.text else { return }
        isDone.toggle()
        let attributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: isDone ? NSUnderlineStyle.single.rawValue : 0
        ]
        headerTaskLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
        delegate?.didTapDoneButton(in: self, task: task, isDone: isDone)
    }
    
    func checkTask() {
        if isDone == true {
            guard let text = headerTaskLabel.text else { return }
            let attributes: [NSAttributedString.Key: Any] = [ .strikethroughStyle: isDone ?
                                                              NSUnderlineStyle.single.rawValue : 0 ]
            
            headerTaskLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
        } else {
            guard let text = headerTaskLabel.text else { return }
            let attributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: 0
            ]
            headerTaskLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
        }
    }

    
    func setupSeparator() {
        separatorView.layer.borderColor = CGColor(gray: 0.8, alpha: 1)
        separatorView.layer.borderWidth = 1
    }
    
    func isToday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }
    
    func dateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = CellConstants.dateFormat
        return dateFormatter.string(from: date)
    }
    
    func timeFormatter(time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = CellConstants.timeFormat
        return dateFormatter.string(from: time)
    }
    
    func setupConstraints() {
        headerTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        detailtTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        dateTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        timeTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        doneTaskButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerTaskLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width / 1.1),
            headerTaskLabel.topAnchor.constraint(equalTo: topAnchor, constant: CellConstants.defaultTopPadding),
            headerTaskLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CellConstants.defaultPadding),
            
            detailtTaskLabel.topAnchor.constraint(equalTo: headerTaskLabel.bottomAnchor,
                                                  constant: CellConstants.defaultTopPadding / 2),
            detailtTaskLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant:CellConstants.defaultPadding),

            separatorView.topAnchor.constraint(equalTo: headerTaskLabel.bottomAnchor,
                                               constant: CellConstants.defaultPadding * 3.5),
            separatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.widthAnchor.constraint(equalToConstant: contentView.bounds.width - CellConstants.defaultPadding * 2),
            
            dateTaskLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -CellConstants.defaultBottomPadding),
            dateTaskLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CellConstants.defaultPadding),
            
            timeTaskLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -CellConstants.defaultBottomPadding),
            timeTaskLabel.leadingAnchor.constraint(equalTo: dateTaskLabel.trailingAnchor,
                                                   constant: CellConstants.defaultTopPadding / 2),
            
            doneTaskButton.topAnchor.constraint(equalTo: topAnchor, constant: CellConstants.defaultTopPadding),
            doneTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CellConstants.defaultTopPadding)
        ])
    }
}
