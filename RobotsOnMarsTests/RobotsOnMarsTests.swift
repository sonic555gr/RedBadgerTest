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
        let robot = Robot(Point(0, 0), .N)
        robot.turnLeft()
        robot.turnLeft()
        XCTAssertEqual(robot.currentDirection, .S)
    }
    
    func testRobotHasThesameDirectionAfterBeingTurned4TimesLeftStartingNorth() {
        let robot = Robot(Point(0, 0), .N)
        robot.turnLeft()
        robot.turnLeft()
        robot.turnLeft()
        robot.turnLeft()
        XCTAssertEqual(robot.currentDirection, .N)
    }
    
    func testRobotHasTheSameDirectionAfterBeingTurned4TimesRightStartingNorth() {
        let robot = Robot(Point(0, 0), .N)
        robot.turnRight()
        robot.turnRight()
        robot.turnRight()
        robot.turnRight()
        XCTAssertEqual(robot.currentDirection, .N)
    }
    
    func testRobotHasTheSameDirectionAfterBeingTurned4TimesRightStartingEast() {
        let robot = Robot(Point(0, 0), .E)
        robot.turnRight()
        robot.turnRight()
        robot.turnRight()
        robot.turnRight()
        XCTAssertEqual(robot.currentDirection, .E)
    }
    
    func testRobotNextLocationForEachDirectionIsCorrect() {
        var robot = Robot(Point(0, 0), .E)
        XCTAssertEqual(robot.nextLocation(), Point(1, 0))
        robot = Robot(Point(0, 0), .W)
        XCTAssertEqual(robot.nextLocation(), Point(-1, 0))
        robot = Robot(Point(0, 0), .N)
        XCTAssertEqual(robot.nextLocation(), Point(0, 1))
        robot = Robot(Point(0, 0), .S)
        XCTAssertEqual(robot.nextLocation(), Point(0, -1))
    }
}

extension RobotsOnMarsTests {
    func testNavigatorStrippedStringCommandReturnsOnlyLRFForAnyGivenInput() {
        let navigator = Navigator(gridWidth: 10, gridHeight: 10)
        navigator.addRobot(Robot(Point(0, 0), .N))
        var trimmedString = navigator.strippedCommandString(from: "1234445EEGVCCBE")
        XCTAssertTrue(trimmedString.isEmpty)
        trimmedString = navigator.strippedCommandString(from: "lLRrFf")
        XCTAssertEqual(trimmedString, "LLRRFF")
        trimmedString = navigator.strippedCommandString(from: "LwLRR33FxF")
        XCTAssertEqual(trimmedString, "LLRRFF")
    }
}

extension RobotsOnMarsTests {
    func testNavigatorMovesRobotWithCommandString() {
        let robot = Robot(Point(0, 0), .N)
        let navigator = Navigator(gridWidth: 10, gridHeight: 10)
        navigator.addRobot(robot)
        navigator.performCommandString("RFFLFFLFF")
        XCTAssertEqual(navigator.robot!.currentPoint.xCoordinate, 0)
        XCTAssertEqual(navigator.robot!.currentPoint.yCoordinate, 2)
        XCTAssertEqual(navigator.robot!.currentDirection, .W)
    }

    func testNavigatorThrowsErrorWhenRobotOutOfBounds() {
        let navigator = Navigator(gridWidth: 10, gridHeight: 10)
        navigator.addRobot(Robot(Point(0, 0), .N))
        let commands = navigator.parseCommandString("LF")
        XCTAssertThrowsError(try navigator.executeCommands(commands))
    }
    
    func testNavigatorThrowsErrorWhenRobotOutOfBoundsTopNorth() {
        let navigator = Navigator(gridWidth: 10, gridHeight: 10)
        navigator.addRobot(Robot(Point(0, 0), .N))
        let commands = navigator.parseCommandString("FFFFFFFFFF")
        XCTAssertThrowsError(try navigator.executeCommands(commands))
    }
    
    func testNavigatorSkipsFowardCommandIfOtherRobotPreviouslyLostInSamePosition() {
        let navigator = Navigator(gridWidth: 10, gridHeight: 10)
        var robot = Robot(Point(0,0), .W)
        navigator.addRobot(robot)
        navigator.performCommandString("F")
        robot = Robot(Point(0,0), .W)
        navigator.addRobot(robot)
        navigator.performCommandString("FRF")
        
        XCTAssertEqual(robot.currentPoint, Point(0, 1))
    }
}
