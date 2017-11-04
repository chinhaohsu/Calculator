//
//  ViewController.swift
//  Calculator
//
//  Created by Chin-Hao Hsu on 2017/11/3.
//  Copyright © 2017年 Chin-Hao Hsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!  //automactically initialized with nil, automatically unwrapped it every single time it appears in the code
    
    var userIsInTheMiddleOfTyping = false
    var userIsInTheMiddleOfTypingFloat = false
    var userIsInTheMiddleOfTypingZero = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "."
        {
            if userIsInTheMiddleOfTypingFloat || !userIsInTheMiddleOfTyping { }
            else
            {
                userIsInTheMiddleOfTypingFloat = true
                let textCurrentlyInDisplay = display.text!
                display.text = textCurrentlyInDisplay + digit
            }
            userIsInTheMiddleOfTypingZero = false
        }
        else if digit == "0" && userIsInTheMiddleOfTypingZero {}
        else
        {
            if userIsInTheMiddleOfTyping
            {
                let textCurrentlyInDisplay = display.text!
                display.text = textCurrentlyInDisplay + digit
                userIsInTheMiddleOfTypingZero = false
            }
            else
            {
                display.text = digit
                userIsInTheMiddleOfTyping = true
                if digit == "0"
                { userIsInTheMiddleOfTypingZero = true }
                else
                { userIsInTheMiddleOfTypingZero = false }
            }
        }
        
    }
    
    var displayValue: Double {
        get { return Double(display.text!)! }
        set { display.text = String(newValue) }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping
        {
            brain.setOperand(displayValue)
        }
        
        userIsInTheMiddleOfTyping = false
        userIsInTheMiddleOfTypingFloat = false
        userIsInTheMiddleOfTypingZero = false
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            
        }
        if let result = brain.result {
            displayValue = result
        }
    }
    
    
    

}

