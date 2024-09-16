//
//  TaskListBuilder.swift
//  Todo
//
//  Created by Nikita Beglov on 14.09.2024.
//

import UIKit
import CoreData

class TaskListBuilder {
    static func createTaskList() -> UIViewController {
        let view = TaskListView()
        let interactor = TaskListInteractor()
        let networkManager = NetworkManager()
        let presenter = TaskListPresenter()
        let router = TaskListRouter()

        view.presenter = presenter
        interactor.presenter = presenter
        interactor.networkManager = networkManager
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }
}
