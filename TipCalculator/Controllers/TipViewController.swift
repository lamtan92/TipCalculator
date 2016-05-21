//
//  TipViewController.swift
//  TipCalculator
//
//  Created by Lam Tran on 5/21/16.
//  Copyright © 2016 Lam Tran. All rights reserved.
//

import UIKit
import ChameleonFramework
import FlagKit

class TipViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var settingBarButton: UIBarButtonItem!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var percentSegment: UISegmentedControl!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    
    var tip: Tip!
    var currentTipPercent: Float {
        get {
            return tip.tipPercentage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tip = .Low
        
        priceTextField.delegate = self
        priceTextField.becomeFirstResponder()
        priceTextField.addTarget(self,
                                  action: #selector(TipViewController.priceTextFieldValueChanged(_:)),
                                  forControlEvents: .EditingChanged)
        
        amountView.backgroundColor = UIColor.flatMintColor()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: TextField Delegate method
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func priceTextFieldValueChanged(sender: AnyObject) {
        calculateTipAndTotalLabel()
    }
    
    // MARK: Dismiss Keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Update TipLabel And Total Label
    func calculateTipAndTotalLabel() {
        if priceTextField.text != "" {
            tipLabel.text = "\(Float(priceTextField.text!)! * currentTipPercent)"
            totalLabel.text = "\(Float(tipLabel.text!)! + (Float(priceTextField.text!))!)"
        } else {
            tipLabel.text = ""
            totalLabel.text = ""
        }
    }
    
    // MARK: Segment Control Value change
    
    @IBAction func segmentControlAction(sender: UISegmentedControl) {
        let currentSegmentIndex = sender.selectedSegmentIndex
        switch currentSegmentIndex {
        case 0 :
            tip = Tip.Low
            calculateTipAndTotalLabel()
        case 1 :
            tip = Tip.Medium
            calculateTipAndTotalLabel()
        case 2 :
            tip = Tip.High
            calculateTipAndTotalLabel()
        default: break
        }
    }

    @IBAction func settingButtonTapped(sender: UIBarButtonItem) {
    }
}
