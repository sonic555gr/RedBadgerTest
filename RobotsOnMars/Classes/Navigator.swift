//
//  Navigator.swift
//  RobotsOnMars
//
//  Created by Alkiviadis Papadakis on 10/01/2019.
//  Copyright © 2019 Alkimo. All rights reserved.
//

import Foundation

protocol NavigatorLogger: class {
    func navigatorWantsToLog(message: String)
}

enum NavigationError: Error {
    case RobotOutOfBounds(positionDescription: String)
}

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

public class Navigator {
    internal let gridWidth: Int
    internal let gridHeight: Int
    internal var robot: Robot?
    internal var lostRobotPositions: [Point] = []
    weak var loggerDelegate: NavigatorLogger?
    
    init(gridWidth: Int, gridHeight: Int, delegate: NavigatorLogger? = nil) {
        self.gridWidth = gridWidth
        self.gridHeight = gridHeight
        loggerDelegate = delegate
    }
    
    func addRobot(_ robot: Robot) {
        if self.robot != nil { return }
        self.robot = robot
        loggerDelegate?.navigatorWantsToLog(message: "New robot was created at x: \(robot.currentPoint.xCoordinate), y: \(robot.currentPoint.yCoordinate), facing \(robot.currentDirection.description())")
    }
    
    internal func strippedCommandString(from commandString: String) -> String {
        let disallowedCharacters = CharacterSet(charactersIn: "LRF").inverted
        let filteredCommand = commandString.uppercased().filter { (character) -> Bool in
            return character.unicodeScalars.contains(where: { !disallowedCharacters.contains($0)})
        }
        return filteredCommand
    }
    
    internal func parseCommandString(_ commandString: String) -> [Command]  {
        return commandString.map{ Command(rawValue: "\($0)")! }
    }
    
    internal func executeCommands(_ commands: [Command]) throws {
        guard let robot = robot else { return }
        for command in commands {
            switch command {
            case .L :
                robot.turnLeft()
            case .R:
                robot.turnRight()
            case .F:
                if lostRobotPositions.contains(robot.nextLocation()) {
                    continue
                }
                if isPositionOutOfBounds(robot.nextLocation()) {
                    lostRobotPositions.append(robot.nextLocation())
                    let currentPoint = robot.currentPoint
                    self.robot = nil
                    throw NavigationError.RobotOutOfBounds(positionDescription: currentPoint.description())
                }
                robot.moveForward()
            }
        }
    }
    
    public func performCommandString(_ commandString: String) {
        let strippedCommandString = self.strippedCommandString(from: commandString)
        let commands = parseCommandString(strippedCommandString)
        guard let robot = robot else { return }
        do {
            try executeCommands(commands)
            loggerDelegate?.navigatorWantsToLog(message:  robot.description())
        }
            
        catch NavigationError.RobotOutOfBounds(let positionDescription) {
            loggerDelegate?.navigatorWantsToLog(message: "\(positionDescription) LOST")
        }
        catch {
        }
    }
    
    internal func isRobotWherePreviousRobotDisappeared(_ robot: Robot) -> Bool {
        return lostRobotPositions.contains(where: {
            robot.currentPoint.xCoordinate == $0.xCoordinate && robot.currentPoint.yCoordinate == $0.yCoordinate
        })
    }
    
    internal func isPositionOutOfBounds(_ position: Point) -> Bool {
        let isWithinWidthBounds = position.xCoordinate < gridWidth && position.xCoordinate >= 0
        let isWithinHeightBounds = position.yCoordinate < gridHeight && position.yCoordinate >= 0
        return !isWithinWidthBounds || !isWithinHeightBounds
    }
}
