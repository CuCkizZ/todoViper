//
//  TaskListBuilderTest.swift
//  TodoTests
//
//  Created by Nikita Beglov on 16.09.2024.
//

import XCTest
@testable import Todo

class TaskListBuilderTests: XCTestCase {
    func testCreateTaskList() {
        let viewController = TaskListBuilder.createTaskList()

        XCTAssertTrue(viewController is TaskListView)

        guard let view = viewController as? TaskListView else {
            XCTFail("View error")
            return
        }

        XCTAssertNotNil(view.presenter)
        XCTAssertTrue(view.presenter is TaskListPresenter)

        guard let presenter = view.presenter as? TaskListPresenter else {
            XCTFail("Presenter error")
            return
        }

        XCTAssertNotNil(presenter.view)
        XCTAssertTrue(presenter.view is TaskListView)

        XCTAssertNotNil(presenter.interactor)
        XCTAssertTrue(presenter.interactor is TaskListInteractor)

        guard let interactor = presenter.interactor as? TaskListInteractor else {
            XCTFail("Interactor error")
            return
        }

        XCTAssertNotNil(interactor.presenter)
        XCTAssertTrue(interactor.presenter is TaskListPresenter)

        XCTAssertNotNil(interactor.networkManager)
        XCTAssertTrue(interactor.networkManager is NetworkManager)

        XCTAssertNotNil(presenter.router)
        XCTAssertTrue(presenter.router is TaskListRouter)

        guard let router = presenter.router as? TaskListRouter else {
            XCTFail("Router error")
            return
        }

        XCTAssertNotNil(router.view)
        XCTAssertTrue(router.view is TaskListView)
    }
}
