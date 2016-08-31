//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 凌何 on 16/8/30.
//  Copyright © 2016年 凌何. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    var ifPartialResult:Bool
    {
        get
        {
            return pending != nil
        }
    }
    private var ifNewOperand = false
    private var accumulator:Double = 0.0
    private var pending: PendingBinaryOperationInfo? = nil
    private var operationDic:Dictionary<String, Operation> =
    [
        "C": Operation.Clean,
        "+": Operation.BinaryOperation({return $0 + $1}),
        "−": Operation.BinaryOperation({return $0 - $1}),
        "×": Operation.BinaryOperation({return $0 * $1}),
        "÷": Operation.BinaryOperation({return $0 / $1}),
        "+/−": Operation.UnaryOperation({return -$0}),
        "n^2": Operation.UnaryOperation({return $0 * $0}),
        "sqrt": Operation.UnaryOperation({return sqrt($0)}),
        "=": Operation.Equal
    ]
    private enum Operation
    {
        case Clean
        case Constant(Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double,Double)->Double)
        case Equal
    }
    
    private struct PendingBinaryOperationInfo
    {
        var firstOperand: Double
        var operation: ((Double,Double)->Double)
    }
    
    func setOperand(operand: Double)
    {
        accumulator = operand
        ifNewOperand = true
    }
    
    func performOperation(symbol:String)
    {
        if let operationToPerform = operationDic[symbol]
        {
            switch operationToPerform
            {
            case Operation.Clean:
                accumulator = 0
                pending = nil
                ifNewOperand = false
            case .Constant(let cons):
                accumulator = cons
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(firstOperand: accumulator, operation: function)
            case .Equal:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation()
    {
        if pending != nil && ifNewOperand == true
        {
            ifNewOperand = false
            accumulator = pending!.operation(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    func getResult() -> Double{return accumulator}
}