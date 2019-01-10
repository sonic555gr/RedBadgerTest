//
//  RobotsOnMarsTests.swift
//  RobotsOnMarsTests
//
//  Created by Alkiviadis Papadakis on 10/01/2019.
//  Copyright © 2019 Alkimo. All rights reserved.
//

import XCTest
@testable import RobotsOnMars

class RobotsOnMarsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRobotTurnsLeftTwiceFromNorthSetsDirectionToSouth() {
        var robot = Robot(Point(0, 0), .N)
        robot.turnLeft()
        robot.turnLeft()
        XCTAssertEqual(robot.currentDirection, .S)
    }
    
    func testRobotHasThesameDirectionAfterBeingTurned4TimesLeftStartingNorth() {
        var robot = Robot(Point(0, 0), .N)
        robot.turnLeft()
        robot.turnLeft()
        robot.turnLeft()
        robot.turnLeft()
        XCTAssertEqual(robot.currentDirection, .N)
    }
    
    func testRobotHasTheSameDirectionAfterBeingTurned4TimesRightStartingNorth() {
        var robot = Robot(Point(0, 0), .N)
        robot.turnRight()
        robot.turnRight()
        robot.turnRight()
        robot.turnRight()
        XCTAssertEqual(robot.currentDirection, .N)
    }
    
    func testRobotHasTheSameDirectionAfterBeingTurned4TimesRightStartingEast() {
        var robot = Robot(Point(0, 0), .E)
        robot.turnRight()
        robot.turnRight()
        robot.turnRight()
        robot.turnRight()
        XCTAssertEqual(robot.currentDirection, .E)
    }
}

extension RobotsOnMarsTests {
    func testNavigatorStrippedStringCommandReturnsOnlyLRFForAnyGivenInput() {
        let navigator = Navigator(gridWidth: 10, gridHeight: 10, robot: Robot(Point(0, 0), .N))
        var trimmedString = navigator.strippedStringCommand(from: "1234445EEGVCCBE")
        XCTAssertTrue(trimmedString.isEmpty)
        trimmedString = navigator.strippedStringCommand(from: "lLRrFf")
        XCTAssertEqual(trimmedString, "LLRRFF")
        trimmedString = navigator.strippedStringCommand(from: "LwLRR33FxF")
        XCTAssertEqual(trimmedString, "LLRRFF")
    }
}

extension RobotsOnMarsTests {
    func testNavigatorMovesRobotWithStringCommand() {
        let robot = Robot(Point(0, 0), .N)
        let navigator = Navigator(gridWidth: 10, gridHeight: 10, robot: robot)
        navigator.executeCommand("RFFLFFLFF")
        XCTAssertEqual(navigator.robot.currentPoint.xCoordinate, 0)
        XCTAssertEqual(navigator.robot.currentPoint.yCoordinate, 2)
        XCTAssertEqual(navigator.robot.currentDirection, .W)
    }
}
