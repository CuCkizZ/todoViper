//
//  TodoRouterBuilderTest.swift
//  TodoTests
//
//  Created by Nikita Beglov on 16.09.2024.
//

import XCTest
@testable import Todo

class TodoRouterBuilderTest: XCTestCase {
    func testCreateTodo() {
        let viewController = EditTodoBuilder.createTodo()

        XCTAssertTrue(viewController is EditTodo)

        guard let view = viewController as? EditTodo else {
            XCTFail("View error")
            return
        }

        XCTAssertNotNil(view.presenter)
        XCTAssertTrue(view.presenter is EditTodoPresenter)

        guard let presenter = view.presenter as? EditTodoPresenter else {
            XCTFail("Presenter error")
            return
        }

        XCTAssertNotNil(presenter.view)
        XCTAssertTrue(presenter.view is EditTodo)

        XCTAssertNotNil(presenter.interactor)
        XCTAssertTrue(presenter.interactor is EditTodoInteractor)

        guard let interactor = presenter.interactor as? EditTodoInteractor else {
            XCTFail("Interactor error")
            return
        }

        XCTAssertNotNil(interactor.presenter)
        XCTAssertTrue(interactor.presenter is EditTodoPresenter)

        XCTAssertNotNil(presenter.router)
        XCTAssertTrue(presenter.router is EditTodoRouter)

        guard let router = presenter.router as? EditTodoRouter else {
            XCTFail("Router error")
            return
        }

        XCTAssertNotNil(router.view)
        XCTAssertTrue(router.view is EditTodo)
    }
}
