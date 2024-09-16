//
//  TodoPresenter.swift
//  Todo
//
//  Created by Nikita Beglov on 14.09.2024.
//

import Foundation

protocol TodoPresenterProtocol {
    func dataFetched()
    func viewDidLoad()
    func saveNewTodo(name: String, group: String, date: Date, fromTime: Date, toTime: Date, comleted: Bool)
    func deleteTodo(model: TodoEntity)
    func dismiss()
    
    func returnGroups() -> [String]
}

final class TodoPresenter {
    weak var view: TodoViewProtocol?
    var interactor: TodoInteractorProtocol?
    var router: TodoRouterProtocol?
}

extension TodoPresenter: TodoPresenterProtocol {
    func saveNewTodo(name: String, group: String, date: Date, fromTime: Date, toTime: Date, comleted: Bool = false) {
        interactor?.saveNewTodo(name: name,
                                group: group,
                                date: date,
                                fromTime: fromTime,
                                toTime: toTime,
                                completed: comleted)
    }

    func deleteTodo(model: TodoEntity) {
        interactor?.deleteTodo(model: model)
    }
    
    func viewDidLoad() {
        interactor?.fetchData()
    }
    
    func dataFetched() {
        view?.groupsFetched()
    }
    
    func dismiss() {
        router?.dismiss()
    }
    
    func returnGroups() -> [String] {
        guard let groups = interactor?.returnGroups() else { return [] }
        return groups
    }
    
}
