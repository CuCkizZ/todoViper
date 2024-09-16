//
//  TaskListView.swift
//  Todo
//
//  Created by Nikita Beglov on 14.09.2024.
//

import UIKit
import CoreData

private let titleStr = "Today's Tasks"
private let allLabelText = "All"
private let openLabelText = "Open"
private let closedLabelText = "Closed"
private let addButtonTitle = "New Task"
private let addButtonImage = "plus"

private let cellPadding = UIEdgeInsets(top: 22, left: 25, bottom: 22, right: 25)
private let defaultButtonPadding: CGFloat = 15
private let defaultXPadding: CGFloat = 10
private let defaultYPadding: CGFloat = 20

protocol TaskListViewProtocol: AnyObject {
    func reloadData()
    func displayTodoList()
}

final class TaskListView: UIViewController {
    var presenter: TaskListPresenterProtocol?
    private let userManager = UserManager.shared
    
    private lazy var titleLabel = UILabel()
    private lazy var dateTitleLabel = UILabel()
    private lazy var addButton = UIButton()
    var cellDataSource: [CellDataModel] = []
    
    private lazy var customSegmentControl = CustomSegmentControl(allCount: presenter?.numbersOfRow(with: .all) ?? 0,
                                                                 openCount: presenter?.numbersOfRow(with: .open) ?? 0,
                                                                 closeCount: presenter?.numbersOfRow(with: .closed) ?? 0,
                                                                 frame: .zero)
    private var segmentedIndex = 0
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width - 50, height: 150)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        setupLayout()
    }
}

private extension TaskListView {
    func setupLayout() {
        setupView()
        setupLabel()
        setupButton()
        setupColelctionView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .systemGray6
        view.addSubview(collectionView)
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(dateTitleLabel)
        view.addSubview(customSegmentControl)
        customSegmentControl.delegate = self
    }
    
    func setupColelctionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TaskListCell.self, forCellWithReuseIdentifier: TaskListCell.reuseID)
        collectionView.backgroundColor = .systemGray6
    }
    
    func setupLabel() {
        titleLabel.text = titleStr
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        
        dateTitleLabel.text = presenter?.dateFormatter(date: Date())
        dateTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        dateTitleLabel.textColor = .systemGray
    }
    
    func setupButton() {
        var config = UIButton.Configuration.filled()
        
        config.title = addButtonTitle
        config.image = UIImage(systemName: addButtonImage)?.withTintColor(.systemBlue)
        config.baseBackgroundColor = .systemBlue.withAlphaComponent(0.1)
        config.baseForegroundColor = .link
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.background.cornerRadius = 12
        addButton.addTarget(self, action: #selector(addTaskButtonTapp), for: .touchUpInside)
        addButton.configuration = config
    }


    @objc func addTaskButtonTapp() {
        presenter?.addButtonTaped()
    }
    
    func updateSermentedContoll() {
        if userManager.isFirstLoad == true {
            let openCount = cellDataSource.filter { $0.completed == false }.count
            let closedCount = cellDataSource.filter { $0.completed == true }.count
            customSegmentControl.updateCount(newAllCount: cellDataSource.count,
                                             newOpenCount: openCount,
                                             newCloseCount: closedCount)
        } else {
            customSegmentControl.updateCount(newAllCount: presenter?.numbersOfRow(with: .all) ?? 0,
                                             newOpenCount: presenter?.numbersOfRow(with: .open) ?? 0,
                                             newCloseCount: presenter?.numbersOfRow(with: .closed) ?? 0)
        }
    }
    
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        dateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        customSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            customSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: defaultYPadding),
            customSegmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: defaultXPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: defaultYPadding),
            
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: defaultButtonPadding),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -defaultButtonPadding),
            
            dateTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: defaultXPadding / 2),
            dateTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: defaultYPadding),
            
            collectionView.topAnchor.constraint(equalTo: customSegmentControl.bottomAnchor, constant: defaultXPadding),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
}

extension TaskListView: TaskListViewProtocol {
    func displayTodoList() {
        cellDataSource = presenter?.returnCellDataSource() ?? []
        collectionView.reloadData()
        updateSermentedContoll()
    }

    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        updateSermentedContoll()
    }
    
}

extension TaskListView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if userManager.isFirstLoad == true {
            switch segmentedIndex {
            case 0:
                return cellDataSource.count
            case 1:
                return cellDataSource.filter { $0.completed == false }.count
            case 2:
                return cellDataSource.filter { $0.completed == true }.count
            default:
                break
            }
        } else {
            switch segmentedIndex {
            case 0:
                return presenter?.numbersOfRow(with: .all) ?? 0
            case 1:
                return presenter?.numbersOfRow(with: .open) ?? 0
            case 2:
                return presenter?.numbersOfRow(with: .closed) ?? 0
            default:
                break
            }
        }
        return 0
    }
    
    private func getOnlineModel() -> [CellDataModel] {
        if userManager.isFirstLoad == true {
            switch segmentedIndex {
            case 0:
                return cellDataSource
            case 1:
                return cellDataSource.filter { $0.completed == false }
            case 2:
                return cellDataSource.filter { $0.completed == true }
            default:
                break
            }
        }
        return cellDataSource
    }
    
    private func getModel(for indexPath: IndexPath) -> TodoEntity? {
        switch segmentedIndex {
        case 0:
            return presenter?.returnItems(at: indexPath, with: .all)
        case 1:
            return presenter?.returnItems(at: indexPath, with: .open)
        case 2:
            return presenter?.returnItems(at: indexPath, with: .closed)
        default:
            break
        }
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if userManager.isFirstLoad == true {
            let cellDataModel = getOnlineModel()
            let model = cellDataModel[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskListCell.reuseID,
                                                                for: indexPath) as? TaskListCell
            else {
                return UICollectionViewCell()
            }
            cell.configureOnline(model: model)
            cell.delegate = self
            return cell
        } else {
            guard let model = getModel(for: indexPath) else { return  UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskListCell.reuseID,
                                                                for: indexPath) as? TaskListCell
            else {
                return UICollectionViewCell()
            }
            cell.configure(model: model)
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        cellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = presenter?.returnItems(at: indexPath, with: .all) else { return }
        presenter?.presentConfigureTodo(model: model)
    }
}


extension TaskListView: TaskListCellDelegate {
    func didTapDoneButton(in cell: TaskListCell, task: TodoEntity, isDone: Bool) {
        presenter?.taskWasDone(task: task, isDone: isDone)
        DispatchQueue.main.async { [weak self] in
            self?.presenter?.viewDidLoad()
        }
        updateSermentedContoll()
    }
}

extension TaskListView: CustomSegmentControlDelegate {
    func segmentControl(_ segmentControl: CustomSegmentControl, didSelectSegmentAt index: Int) {
        switch index {
        case 0:
            self.segmentedIndex = 0
            presenter?.viewDidLoad()
        case 1:
            self.segmentedIndex = 1
            presenter?.viewDidLoad()
        case 2:
            self.segmentedIndex = 2
            presenter?.viewDidLoad()
        default:
            self.segmentedIndex = 0
        }
        reloadData()
    }
}
