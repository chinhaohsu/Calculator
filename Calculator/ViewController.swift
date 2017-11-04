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
    
    @IBOutlet weak var displayDescription: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    var userIsInTheMiddleOfTypingFloat = false
    var userIsInTheMiddleOfTypingZero = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "."
        {
            if userIsInTheMiddleOfTypingFloat {}
            else
            {
                if !userIsInTheMiddleOfTyping
                { display.text = "0." }
                else
                {
                    let textCurrentlyInDisplay = display.text!
                    display.text = textCurrentlyInDisplay + digit
                }
            }
            userIsInTheMiddleOfTyping = true
            userIsInTheMiddleOfTypingFloat = true
            userIsInTheMiddleOfTypingZero = false
        }
        else if digit == "0"
        {
            if userIsInTheMiddleOfTypingZero {}
            else
            {
                if userIsInTheMiddleOfTyping
                {
                    let textCurrentlyInDisplay = display.text!
                    display.text = textCurrentlyInDisplay + digit
                }
                else
                {
                    display.text = "0"
                    userIsInTheMiddleOfTypingZero = true
                    userIsInTheMiddleOfTyping = true
                }
            }
        }
        else
        {
            if userIsInTheMiddleOfTypingZero
            {
                display.text = digit
                userIsInTheMiddleOfTyping = true
                userIsInTheMiddleOfTypingZero = false
            }
            else
            {
                if userIsInTheMiddleOfTyping
                {
                    let textCurrentlyInDisplay = display.text!
                    display.text = textCurrentlyInDisplay + digit
                }
                else
                {
                    display.text = digit
                    userIsInTheMiddleOfTyping = true
                }
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
    
    @IBAction func perfromClear(_ sender: UIButton) {
        display.text = "0"
        displayDescription.text = " "
        brain.reset()
        userIsInTheMiddleOfTyping = false
        userIsInTheMiddleOfTypingFloat = false
        userIsInTheMiddleOfTypingZero = false
        
    }
    
    

}

