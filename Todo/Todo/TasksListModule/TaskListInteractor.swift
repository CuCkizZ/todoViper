//
//  TaskListInteractor.swift
//  Todo
//
//  Created by Nikita Beglov on 14.09.2024.
//

import Foundation
import CoreData

enum ModelTypes {
    case all
    case closed
    case open
}

protocol TaskListInteractorProtocol {
    func fetchData()
    func didFetchTasks(with result: [CellDataModel])
    func didDataFetched()
    func numberOfRowInCoreDataSection(with modelType: ModelTypes) -> Int
    func returnItems(at indexPath: IndexPath, with type: ModelTypes) -> TodoEntity?
    
    
    func taskWasDone(task: TodoEntity, isDone: Bool)
}

final class TaskListInteractor {
    var presenter: TaskListPresenterProtocol?
    var networkManager: NetworkManagerProtocol?
    private let coreManager = CoreManager.shared
    private let userManager = UserManager.shared
    var fetchedResultController: NSFetchedResultsController<TodoEntity>?
    
    private var model: [TodoEntity] = []
    private var onlineModel: [Todo] = []
    private var closedModel: [TodoEntity] = []
    private var openedModel: [TodoEntity] = []
    var cellDataModel: [CellDataModel] = []
    
    private func filterCloseData() {
        closedModel = model.filter { $0.completed == true }
    }
    
    private func filterOpenData() {
        openedModel = model.filter { $0.completed == false }
    }
    
    private func mapModel() {
        cellDataModel = onlineModel.compactMap { CellDataModel(model: $0) }
    }
    
}

extension TaskListInteractor: TaskListInteractorProtocol {
    func fetchData() {
        if userManager.isFirstLoad {
            fetchOnlineData()
        } else {
            setupFetchedResultsController()
            filterCloseData()
            filterOpenData()
            didDataFetched()
        }
    }
    
    func fetchOnlineData() {
        networkManager?.fetchTodoList(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.onlineModel = data
                    self.mapModel()
                    self.didFetchTasks(with: self.cellDataModel)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func didFetchTasks(with result: [CellDataModel]) {
        presenter?.onlineDataFetched(model: result)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            guard let self = self else { return }
            self.userManager.isFirstLoad = false
        })
    }
    
    func didDataFetched() {
        presenter?.dataFetched()
    }
    
    func taskWasDone(task: TodoEntity, isDone: Bool) {
        task.updateState(completed: isDone)
        coreManager.saveContext()
        presenter?.dataFetched()
    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let context = coreManager.persistentContainer.viewContext
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                             managedObjectContext: context,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
        
        try? fetchedResultController?.performFetch()
        self.model = fetchedResultController?.fetchedObjects ?? []
    }
    
    func numberOfRowInCoreDataSection(with modelType: ModelTypes) -> Int {
        switch modelType {
        case .all:
            guard let items = fetchedResultController?.fetchedObjects else { return 0 }
            return items.count
        case .closed:
            return closedModel.count
        case .open:
            return openedModel.count
        }
    }
    
    func returnItems(at indexPath: IndexPath, with modelType: ModelTypes) -> TodoEntity? {
        let filteredItems: [TodoEntity]
        switch modelType {
        case .all:
            filteredItems = model
        case .closed:
            filteredItems = model.filter { $0.completed == true }
        case .open:
            filteredItems = model.filter { $0.completed == false }
        }
        return indexPath.row < filteredItems.count ? filteredItems[indexPath.row] : nil
    }
}
