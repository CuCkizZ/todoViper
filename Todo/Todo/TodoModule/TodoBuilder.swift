//
//  TodoBuilder.swift
//  Todo
//
//  Created by Nikita Beglov on 14.09.2024.
//

import UIKit

final class TodoBuilder {
    static func createTodoWithConfugire(model: TodoEntity) -> TodoView {
        let view = TodoView()
        let interactor = TodoInteractor()
        let presenter = TodoPresenter()
        let router = TodoRouter()
        view.configuration(model: model)
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }
    
    static func createTodo() -> TodoView {
        let view = TodoView()
        let interactor = TodoInteractor()
        let presenter = TodoPresenter()
        let router = TodoRouter()
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }
}
