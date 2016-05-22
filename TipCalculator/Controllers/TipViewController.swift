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
    
    @IBOutlet weak var bigNumberLabel: UILabel!
    @IBOutlet weak var settingBarButton: UIBarButtonItem!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var percentSegment: UISegmentedControl!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    var currentSegmentIndex = 0
    
    var userDefault = NSUserDefaults.standardUserDefaults()
    let formatNumber = NSNumberFormatter()
    var currencySymbol: String!
    
    var tip: Tip!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bigNumberLabel.hidden = true
        tip = .Low
        
        percentSegment.tintColor = UIColor.flatLimeColor()
        percentSegment.backgroundColor = UIColor.flatSandColor()
        
        priceTextField.delegate = self
        priceTextField.becomeFirstResponder()
        priceTextField.addTarget(self,
                                  action: #selector(TipViewController.priceTextFieldValueChanged(_:)),
                                  forControlEvents: .EditingChanged)
        
        amountView.backgroundColor = UIColor.flatMintColor()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        formatNumber.numberStyle = .CurrencyStyle
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.hidden = false
        updateLocale()
        
        //Get seletedTip from last run application
        if let currentSelectedTip = userDefault.objectForKey("currentSelectedTip") as? Int {
            percentSegment.selectedSegmentIndex = currentSelectedTip
            tip.setValueForTip(currentSelectedTip)
        } else {
            percentSegment.selectedSegmentIndex = tip.rawValue
        }

        calculateTipAndTotalLabel()
    }
    
    // MARK: TextField Delegate method
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        bigNumberLabel.text = string
        return true
    }
    
    func priceTextFieldValueChanged(sender: AnyObject) {
        self.bigNumberLabel.hidden = false
        self.bigNumberLabel.alpha = 0
        UIView.animateWithDuration(0.7, animations: {
            self.bigNumberLabel.hidden = false
            self.bigNumberLabel.alpha = 1
            self.bigNumberLabel.transform = CGAffineTransformMakeScale(2.0, 2.0)
            }) { _ in
                self.bigNumberLabel.transform = CGAffineTransformIdentity
                self.bigNumberLabel.hidden = true
        }
        calculateTipAndTotalLabel()
    }
    
    // MARK: Dismiss Keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Update TipLabel And Total Label
    func calculateTipAndTotalLabel() {
        if priceTextField.text != "" {
            let tipNumber = Float(priceTextField.text!)! * tip.tipPercentage()
            let totalNumber = tipNumber + Float(priceTextField.text!)!
            tipLabel.text = formatNumber.stringFromNumber(NSNumber(float: tipNumber))
            totalLabel.text = formatNumber.stringFromNumber(NSNumber(float: totalNumber))
        } else {
            tipLabel.text = self.currencySymbol
            totalLabel.text = self.currencySymbol
        }
    }
    
    // MARK: Segment Control Value change

    @IBAction func segmentControlAction(sender: UISegmentedControl) {
        currentSegmentIndex = sender.selectedSegmentIndex
        tip.setValueForTip(currentSegmentIndex)
        calculateTipAndTotalLabel()
        userDefault.setInteger(tip.rawValue, forKey: "currentSelectedTip")
        userDefault.synchronize()
    }

    // MARK: settingButton Tapped
    
    @IBAction func settingButtonTapped(sender: UIBarButtonItem) {
        let settingVC = storyboard?.instantiateViewControllerWithIdentifier("SettingViewController") as! SettingViewController
        settingVC.tip = tip
        settingVC.delegate = self
        navigationController?.pushViewController(settingVC, animated: true)
    }
}

extension TipViewController: SettingViewControllerDelegate {
    func currentSegmentIndexChange(tip: Tip) {
        self.tip = tip
        calculateTipAndTotalLabel()
        userDefault.setInteger(tip.rawValue, forKey: "currentSelectedTip")
        userDefault.synchronize()
    }
}

extension TipViewController {
    // Update Flag and currencySymbol
    
    func updateLocale() {
        updateCurrencySymbol()
        updateFlag()
    }
    
    func updateFlag() {
        let image = UIImage(flagImageWithCountryCode: NSLocale.autoupdatingCurrentLocale().objectForKey(NSLocaleCountryCode) as! String)
        flagImageView.image = image
    }
    
    func updateCurrencySymbol() {
        let locale = NSLocale.currentLocale()
        
        if let currencyCode = locale.objectForKey(NSLocaleCurrencyCode),
            let currencySymbol = locale.displayNameForKey(NSLocaleCurrencySymbol,
                                                          value: currencyCode) {
            self.currencySymbol = currencySymbol
            priceTextField.placeholder = self.currencySymbol
        } else {
            priceTextField.placeholder = "$"
        }
    }
}
