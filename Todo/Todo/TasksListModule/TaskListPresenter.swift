//
//  TaskListPresenter.swift
//  Todo
//
//  Created by Nikita Beglov on 14.09.2024.
//

import Foundation

protocol TaskListPresenterProtocol {
//    Input
    func viewDidLoad()
    func presentConfigureTodo(model: TodoEntity)
    func dataFetched()
    func onlineDataFetched(model: [CellDataModel])
    func returnCellDataSource() -> [CellDataModel]
    func addButtonTaped()
    func taskWasDone(task: TodoEntity, isDone: Bool)
    
//    Output
    func dateFormatter(date: Date) -> String
    func displayTodoList()
    func numbersOfRow(with modelType: ModelTypes) -> Int 
    func returnItems(at indexPath: IndexPath, with type: ModelTypes) -> TodoEntity?
}

final class TaskListPresenter {
    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    
    var cellDataSource: [CellDataModel] = []
    
    init() {
           NotificationCenter.default.addObserver(self,
                                                  selector: #selector(reloadData),
                                                  name: .dismissModal,
                                                  object: nil)
       }
    
    @objc func reloadData() {
        viewDidLoad()
        displayTodoList()
    }
    
}

extension TaskListPresenter: TaskListPresenterProtocol {
    func viewDidLoad() {
        interactor?.fetchData()
    }
    
    func displayTodoList() {
        view?.displayTodoList()
    }
    
    func dataFetched() {
        displayTodoList()
    }
    
    func onlineDataFetched(model: [CellDataModel]) {
        cellDataSource = model
        view?.displayTodoList()
    }
    
    func taskWasDone(task: TodoEntity, isDone: Bool) {
        interactor?.taskWasDone(task: task, isDone: isDone)
    }
    
    func dateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        return dateFormatter.string(from: date)
    }
    
    func addButtonTaped() {
        router?.presentTodo()
    }
    
    func presentConfigureTodo(model: TodoEntity) {
        router?.presentConfigureTodo(model: model)
    }
    
    func numbersOfRow(with modelType: ModelTypes) -> Int {
        switch modelType {
        case .all:
            interactor?.numberOfRowInCoreDataSection(with: .all) ?? 0
        case .closed:
            interactor?.numberOfRowInCoreDataSection(with: .closed) ?? 0
        case .open:
            interactor?.numberOfRowInCoreDataSection(with: .open) ?? 0
        }
    }
    
    func returnCellDataSource() -> [CellDataModel] {
        return cellDataSource
    }
    
    func returnItems(at indexPath: IndexPath, with type: ModelTypes) -> TodoEntity? {
        interactor?.returnItems(at: indexPath, with: type)
    }
}
