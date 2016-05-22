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
    
    @IBOutlet weak var tipSegmentControl: UISegmentedControl!
    var tip: Tip?
    
    weak var delegate: SettingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipSegmentControl.tintColor = UIColor.flatLimeColor()
        tipSegmentControl.backgroundColor = UIColor.flatSandColor()
        tipSegmentControl.selectedSegmentIndex = (tip?.rawValue)!
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = true
    }
    
    @IBAction func segmentControlAction(sender: UISegmentedControl) {
        let currentSegmentIndex = sender.selectedSegmentIndex
        tip?.setValueForTip(currentSegmentIndex)
        self.delegate?.currentSegmentIndexChange(self.tip!)
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}

