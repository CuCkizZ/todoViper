//
//  UserManager.swift
//  Todo
//
//  Created by Nikita Beglov on 15.09.2024.
//

import Foundation

final class UserManager {
    static let shared = UserManager()
    static let firstLoad = "firstLoad"
    
    private init() {}
    
    var isFirstLoad: Bool {
        get { UserDefaults.standard.bool(forKey: UserManager.firstLoad) }
        set { UserDefaults.standard.set(newValue, forKey: UserManager.firstLoad) }
    }
}
