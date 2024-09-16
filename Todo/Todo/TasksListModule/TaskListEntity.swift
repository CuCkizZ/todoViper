//
//  TaskListEntity.swift
//  Todo
//
//  Created by Nikita Beglov on 15.09.2024.
//

import Foundation

struct CellDataModel {
    let todo: String
    let completed: Bool
    
    init(model: Todo) {
        self.todo = model.todo
        self.completed = model.completed
    }
}
