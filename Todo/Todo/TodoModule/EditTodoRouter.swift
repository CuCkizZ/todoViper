//
//  TodoRouter.swift
//  Todo
//
//  Created by Nikita Beglov on 14.09.2024.
//

import UIKit

protocol TodoRouterProtocol {
    func dismiss()
}

final class EditTodoRouter {
    weak var view: UIViewController?
}

extension EditTodoRouter: TodoRouterProtocol {
    func dismiss() {
        guard let view = view else { return }
        view.dismiss(animated: true) {
            NotificationCenter.default.post(name: .dismissModal, object: nil)
        }
    }
}

extension Notification.Name {
    static let dismissModal = Notification.Name("dismissModal")
}
