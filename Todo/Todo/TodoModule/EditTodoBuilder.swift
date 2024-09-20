//
//  TodoBuilder.swift
//  Todo
//
//  Created by Nikita Beglov on 14.09.2024.
//

import UIKit

final class EditTodoBuilder {
    static func createTodoWithConfugire(model: TodoEntity) -> EditTodo {
        let view = EditTodo()
        let interactor = EditTodoInteractor()
        let presenter = EditTodoPresenter()
        let router = EditTodoRouter()
        view.configuration(model: model)
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }
    
    static func createTodo() -> EditTodo {
        let view = EditTodo()
        let interactor = EditTodoInteractor()
        let presenter = EditTodoPresenter()
        let router = EditTodoRouter()
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }
}
