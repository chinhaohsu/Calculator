//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Chin-Hao Hsu on 2017/11/3.
//  Copyright © 2017年 Chin-Hao Hsu. All rights reserved.
//

import Foundation


/*
struct vs class
1. no inheritance
2. valued type: does not live in heap, pass around by copying (not pointer)
3. automatically initialize
*/

/* why struct for calculatorbrain?
not goint to have a lot of things referencing to it
*/


struct CalculatorBrain {
    
    private var accumulator: Double? //no value when started the brain
    private var resultIsPending = false
    private var description: String?   //to build...
    
    private enum Operation {
        case constant(Double)  //enum can have associated value, ex. optionals have two enum nil or not nil (associated with specific type
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> =
    [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),  //sqrt
        "cos": Operation.unaryOperation(cos),
        "±": Operation.unaryOperation({ -$0 }),
        "×": Operation.binaryOperation({ $0 * $1 }), //closure, swift knows it would be a (Double, Double) -> Double function
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),
        "=": Operation.equals
        
    ]
    
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value):
                accumulator = value
                resultIsPending = false
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
                resultIsPending = false
            case .binaryOperation(let function):
                if accumulator != nil {
                    if pendingBinaryOperation != nil {
                        performPendingBinaryOperation()
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    } else {
                    
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                        accumulator = nil
                    }
                    resultIsPending = true
                    
                }
            case .equals:
                performPendingBinaryOperation()
                resultIsPending = false
                
            }
        }
        
        
        /*
        switch symbol{
        case "π" :
            accumulator = Double.pi
        case "√" :
            if let operand = accumulator{
                accumulator = sqrt(operand)
            }
        default:
            break
 
        }
        */
        
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
      
    }
    private var pendingBinaryOperation: PendingBinaryOperation?    //why declare here, why optional??
    
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double { //didn't mutate accumulator
            return function(firstOperand, secondOperand)
        }
    }
    
   
    
    mutating func setOperand(_ operand: Double)  //tell swift it writes, so that swift would copy the struct again
    {
        
        accumulator = operand
    }
    
    var result: Double?  //make it read-only
    {
        get { return accumulator }
    }
    var toDisplayRaw: String?
    {
        get { return description }
    }
    
}
