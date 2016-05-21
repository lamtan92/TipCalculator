//
//  SettingViewController.swift
//  TipCalculator
//
//  Created by Lam Tran on 5/21/16.
//  Copyright © 2016 Lam Tran. All rights reserved.
//

import UIKit

protocol SettingViewControllerDelegate: class {
    func currentSegmentIndexChange(tip: Tip)
}

class SettingViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tipSegmentControl: UISegmentedControl!
    var tip: Tip?
    
    weak var delegate: SettingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipSegmentControl.selectedSegmentIndex = (tip?.rawValue)!
    }
    @IBAction func segmentControlAction(sender: UISegmentedControl) {
        let currentSegmentIndex = sender.selectedSegmentIndex
        tip?.setValueForTip(currentSegmentIndex)
        self.delegate?.currentSegmentIndexChange(self.tip!)
    }
    @IBAction func backButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

