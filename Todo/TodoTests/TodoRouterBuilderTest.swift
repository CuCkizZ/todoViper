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
        let viewController = TodoBuilder.createTodo()

        XCTAssertTrue(viewController is TodoView)

        guard let view = viewController as? TodoView else {
            XCTFail("View error")
            return
        }

        XCTAssertNotNil(view.presenter)
        XCTAssertTrue(view.presenter is TodoPresenter)

        guard let presenter = view.presenter as? TodoPresenter else {
            XCTFail("Presenter error")
            return
        }

        XCTAssertNotNil(presenter.view)
        XCTAssertTrue(presenter.view is TodoView)

        XCTAssertNotNil(presenter.interactor)
        XCTAssertTrue(presenter.interactor is TodoInteractor)

        guard let interactor = presenter.interactor as? TodoInteractor else {
            XCTFail("Interactor error")
            return
        }

        XCTAssertNotNil(interactor.presenter)
        XCTAssertTrue(interactor.presenter is TodoPresenter)

        XCTAssertNotNil(presenter.router)
        XCTAssertTrue(presenter.router is TodoRouter)

        guard let router = presenter.router as? TodoRouter else {
            XCTFail("Router error")
            return
        }

        XCTAssertNotNil(router.view)
        XCTAssertTrue(router.view is TodoView)
    }
}
