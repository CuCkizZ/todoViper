//
//  RouterTest.swift
//  TodoTests
//
//  Created by Nikita Beglov on 16.09.2024.
//

import XCTest
@testable import Todo

class TaskListRouterTests: XCTestCase {
    var router: TaskListRouter!
    var viewController: UIViewController!

    override func setUp() {
        super.setUp()
        router = TaskListRouter()
        viewController = UIViewController()
        router.view = viewController
    }

    override func tearDown() {
        router = nil
        viewController = nil
        super.tearDown()
    }

    func testPresentConfigureTodo() {
        let model = TodoEntity()
        router.presentConfigureTodo(model: model)
        XCTAssertTrue(viewController.presentedViewController is TodoView)
        let todoViewController = viewController.presentedViewController as! TodoView
        XCTAssertEqual(todoViewController.model, model)
    }

    func testPresentTodo() {
        router.presentTodo()
        XCTAssertTrue(viewController.presentedViewController is TodoView)
        let todoViewController = viewController.presentedViewController as! TodoView
        XCTAssertNil(todoViewController.model)
    }
}

