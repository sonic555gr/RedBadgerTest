//
//  Robot.swift
//  RobotsOnMars
//
//  Created by Alkiviadis Papadakis on 10/01/2019.
//  Copyright © 2019 Alkimo. All rights reserved.
//

import Foundation

struct Point: Equatable {
    var xCoordinate: Int
    var yCoordinate: Int
    init(_ xCoordinate: Int, _ yCoordinate: Int) {
        self.xCoordinate = xCoordinate
        self.yCoordinate = yCoordinate
    }
    
    func description() -> String {
        return "\(xCoordinate) \(yCoordinate)"
    }
    
    static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.xCoordinate == rhs.xCoordinate && lhs.yCoordinate == rhs.yCoordinate
    }
}

enum Direction: Int {
    case N = 0
    case E = 1
    case S = 2
    case W = 3
    
    func description() -> String {
        switch self {
        case .N:
            return "North"
        case .E:
            return "East"
        case .S:
            return "South"
        case .W:
            return "West"
        }
    }
    
}

enum Command: String {
    case L = "L"
    case R = "R"
    case F = "F"
}

class Robot {
    let startPoint: Point
    let startDirection: Direction
    var currentPoint: Point
    var currentDirection: Direction
    
    init(_ startPoint: Point, _ startDirection: Direction) {
        self.startDirection = startDirection
        self.startPoint = startPoint
        self.currentPoint = startPoint
        self.currentDirection = startDirection
    }
    
    func nextLocation() -> Point {
        var nextPoint = currentPoint
        switch currentDirection {
        case .N:
            nextPoint.yCoordinate = currentPoint.yCoordinate + 1
        case .E:
            nextPoint.xCoordinate = currentPoint.xCoordinate + 1
        case .S:
            nextPoint.yCoordinate = currentPoint.yCoordinate - 1
        case .W:
            nextPoint.xCoordinate = currentPoint.xCoordinate - 1
        }
        return nextPoint
    }
    
    func moveForward() {
        self.currentPoint = nextLocation()
    }
    
    func turnLeft() {
        turn(to: currentDirection.rawValue - 1)
    }
    func turnRight() {
        turn(to: currentDirection.rawValue + 1)
    }
    
    private func turn(to value: Int) {
        var newDirectionValue = value
        if newDirectionValue < 0 {
            newDirectionValue = 3
        }
        if newDirectionValue > 3 {
            newDirectionValue  = 0
        }
        currentDirection = Direction(rawValue: newDirectionValue)!
    }
    
    func description() -> String {
        return "\(currentPoint.description()) \(currentDirection)"
    }
}
