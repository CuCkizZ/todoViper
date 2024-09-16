//
//  TodoInteractor.swift
//  Todo
//
//  Created by Nikita Beglov on 14.09.2024.
//

import Foundation
import CoreData

protocol TodoInteractorProtocol {
    func fetchData()
    func saveNewTodo(name: String, group: String, date: Date, fromTime: Date, toTime: Date, completed: Bool)
    func deleteTodo(model: TodoEntity)
    func returnGroups() -> [String]
}

final class TodoInteractor {
    var presenter: TodoPresenterProtocol?
    let coreManager = CoreManager.shared
    private var fetchedResultController: NSFetchedResultsController<TodoEntity>?
}

extension TodoInteractor: TodoInteractorProtocol {
    func fetchData() {
        setupFetchedResultsController()
        presenter?.dataFetched()
    }
    
    func saveNewTodo(name: String, 
                     group: String,
                     date: Date,
                     fromTime: Date,
                     toTime: Date,
                     completed: Bool = false) {
        
        coreManager.addNewTodo(name: name, 
                               group: group, 
                               date: date,
                               fromTime: fromTime,
                               toTime: toTime,
                               completed: completed)
    }
    
    func deleteTodo(model: TodoEntity) {
        coreManager.deleteTodo(model: model)
    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        let context = coreManager.persistentContainer.viewContext
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                             managedObjectContext: context,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
        
        try? fetchedResultController?.performFetch()
    }
    
    func returnGroups() -> [String] {
        let model = fetchedResultController?.fetchedObjects as? [TodoEntity]
        let groups = model?.compactMap { $0.group } ?? []
        let uniqueGroups = Array(Set(groups)).filter { !$0.isEmpty }
        return uniqueGroups
    }
    
}
