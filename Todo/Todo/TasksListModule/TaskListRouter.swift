//
//  TaskListRouter.swift
//  Todo
//
//  Created by Nikita Beglov on 14.09.2024.
//

import UIKit

protocol TaskListRouterProtocol {
    func presentConfigureTodo(model: TodoEntity)
    func presentTodo()
}

final class TaskListRouter {
    weak var view: UIViewController?
}

extension TaskListRouter: TaskListRouterProtocol {
    func presentConfigureTodo(model: TodoEntity) {
        let todoView = EditTodoBuilder.createTodoWithConfugire(model: model)
        if let sheet = todoView.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 16
            sheet.prefersGrabberVisible = true
        }
        view?.present(todoView, animated: true)
    }
    
    func presentTodo() {
        let todoView = EditTodoBuilder.createTodo()
        if let sheet = todoView.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 16
            sheet.prefersGrabberVisible = true
        }
        view?.present(todoView, animated: true)
    }
    
}
