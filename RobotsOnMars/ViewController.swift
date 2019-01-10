//
//  ViewController.swift
//  RobotsOnMars
//
//  Created by Alkiviadis Papadakis on 10/01/2019.
//  Copyright © 2019 Alkimo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var gridSizeTextField: UITextField!
    @IBOutlet var newRobotTextField: UITextField!
    @IBOutlet var commandTextField: UITextField!
    
    @IBOutlet var consoleLogView: UITextView!
    
    var navigator: Navigator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func createGrid(button: UIButton) {
        var widthHeightComponents = gridSizeTextField.text!.components(separatedBy: .whitespaces)
        
        if widthHeightComponents.count < 2 {
            
            logMessage("You can't initilise a grid with only one dimention.")
            gridSizeTextField.becomeFirstResponder()
            return
        }
        
        if widthHeightComponents.count > 2 {
            logMessage("More than 2 numbers where detected. Trimming the rest.")
            widthHeightComponents.removeSubrange(2...)
        }
        
        let width = widthHeightComponents[0]
        let height = widthHeightComponents[1]
        navigator = Navigator(gridWidth: Int(width)!, gridHeight: Int(height)!, delegate: self)
        logMessage("Navigator was created with width:\(width), height: \(height).")
        button.setTitle("Create robot", for: .normal)
    }
    
    @IBAction func createRobot(button: UIButton) {
        let newRobotComponents = newRobotTextField.text!.components(separatedBy: .whitespaces)
        let robot = Robot(Point(Int(newRobotComponents[0])!, Int(newRobotComponents[1])!), directionFromString(newRobotComponents[2]))
        navigator?.addRobot(robot)
    }
    
    @IBAction func executeCommandButtonPressed(button: UIButton) {
        navigator?.performCommandString(commandTextField.text!)
    }
    
    func directionFromString(_ string: String) -> Direction {
        switch string {
            case "N":
                return .N
            case "E":
                return .E
            case "S":
                return .S
            case "W":
                return .W
            default:
                return .N
        }
    }
    
    func logMessage(_ string: String) {
        consoleLogView.text.append(string)
        consoleLogView.text.append("\n")
        let range = NSMakeRange(consoleLogView.text.count - 1, 0)
        consoleLogView.scrollRangeToVisible(range)
    }
}

extension ViewController: NavigatorLogger {
    func navigatorWantsToLog(message: String) {
        logMessage(message)
    }
}


