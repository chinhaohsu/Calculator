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
2. does not live in heap, pass by by copying (not pointer)
3. automatically initialize
*/

struct CalculatorBrain {
    
    private var accumulator: Double? //no value when started the brain
    
    private enum Operation {
        case constant(Double)  //optionals are enum, can have associated value
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
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
                
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
    
   
    
    mutating func setOperand(_ operand: Double){    //tell swift it writes, so that swift would copy the struct again
        accumulator = operand
    }
    
    var result: Double? {   //make it read-only
        get {
            return accumulator
        }
    }
}
