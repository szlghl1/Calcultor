//
//  ViewController.swift
//  Calculator
//
//  Created by 凌何 on 16/8/30.
//  Copyright © 2016年 凌何. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var lableScreen: UILabel!
    
    private var ifSettingOperand = false
    private var calculatorBrain:CalculatorBrain = CalculatorBrain()
    private var screenDouble:Double
    {
        set
        {
            lableScreen.text = String(newValue)
        }
        get
        {
            return Double(lableScreen.text!)!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func performOperation(sender: UIButton)
    {
        if let symbol = sender.currentTitle
        {
            calculatorBrain.performOperation(symbol)
            ifSettingOperand = false
            screenDouble = calculatorBrain.getResult()
        }
    }
    @IBAction func setOperand(sender: UIButton)
    {
        if var currentScreen = lableScreen.text
        {
            if let buttonPressed = sender.currentTitle
            {
                if buttonPressed == "."
                {
                    if currentScreen.containsString(".") || !ifSettingOperand
                    {
                        return
                    }
                }
                if buttonPressed == "0" && currentScreen == "0"
                {
                    return
                }
                if ifSettingOperand
                {
                    currentScreen += buttonPressed
                }
                else
                {
                    currentScreen = buttonPressed
                    ifSettingOperand = true
                }
                lableScreen.text = currentScreen
                calculatorBrain.setOperand(Double(currentScreen)!)
            }
        }
    }

}

