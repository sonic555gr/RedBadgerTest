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
