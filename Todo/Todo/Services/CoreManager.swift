//
//  CoreManager.swift
//  Todo
//
//  Created by Nikita Beglov on 14.09.2024.
//

import Foundation
import CoreData

final class CoreManager {
    static let shared = CoreManager()
    private var todos = [TodoEntity]()
    private init() {}
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func setupFetchResultController() -> NSFetchedResultsController<TodoEntity> {
        let fetchReqest = TodoEntity.fetchRequest()
        let context = persistentContainer.viewContext
        let sortDescription = NSSortDescriptor(key: "name", ascending: true)
        fetchReqest.sortDescriptors = [sortDescription]
        let resultController = NSFetchedResultsController(fetchRequest: fetchReqest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return resultController
    }
    
    func fetchAllTodos() {
        let request = TodoEntity.fetchRequest()
        if let todos = try? persistentContainer.viewContext.fetch(request) {
            self.todos = todos
        }
    }
    
    func addNewTodo(name: String, group: String, date: Date, fromTime: Date, toTime: Date, completed: Bool) {
        let todos = TodoEntity(context: persistentContainer.viewContext)
        todos.name = name
        todos.group = group
        todos.date = date
        todos.fromTime = fromTime
        todos.toTime = toTime
        todos.completed = false
        
        saveContext()
    }
    
    func deleteTodo(model: TodoEntity) {
        persistentContainer.viewContext.delete(model)
        saveContext()
    }
    
}

extension TodoEntity  {
    func updateTodo(newName: String, newGroup: String, newDate: Date, fromNewTime: Date, toNewTime: Date) {
        self.name = newName
        self.group = newGroup
        self.date = newDate
        self.fromTime = fromNewTime
        self.toTime = toNewTime
        
        try? managedObjectContext?.save()
    }
    
    func updateState(completed: Bool) {
        self.completed = completed
        try? managedObjectContext?.save()
    }
    
}
