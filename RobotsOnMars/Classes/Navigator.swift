//
//  Navigator.swift
//  RobotsOnMars
//
//  Created by Alkiviadis Papadakis on 10/01/2019.
//  Copyright © 2019 Alkimo. All rights reserved.
//

import Foundation

struct Point {
    var xCoordinate: Int
    var yCoordinate: Int
    init(_ xCoordinate: Int, _ yCoordinate: Int) {
        self.xCoordinate = xCoordinate
        self.yCoordinate = yCoordinate
    }
}

enum Direction: Int {
    case N = 0
    case E = 1
    case S = 2
    case W = 3
}

struct MoveCommand {
    let commands: [String]
}

struct Robot {
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
    
    mutating func moveForward() {
        switch currentDirection {
        case .N:
            currentPoint.yCoordinate = currentPoint.yCoordinate + 1
        case .E:
            currentPoint.xCoordinate = currentPoint.xCoordinate + 1
        case .S:
            currentPoint.yCoordinate = currentPoint.yCoordinate - 1
        case .W:
            currentPoint.xCoordinate = currentPoint.xCoordinate - 1
        }
    }
    
    mutating func turnLeft() {
        turn(to: currentDirection.rawValue - 1)
    }
    mutating func turnRight() {
        turn(to: currentDirection.rawValue + 1)
    }
    
    private mutating func turn(to value: Int) {
        var newDirectionValue = value
        if newDirectionValue < 0 {
            newDirectionValue = 3
        }
        if newDirectionValue > 3 {
            newDirectionValue  = 0
        }
        currentDirection = Direction(rawValue: newDirectionValue)!
    }
}
