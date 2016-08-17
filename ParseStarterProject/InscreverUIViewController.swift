//
//  InscreverUIViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Júlio Gabriel Chilela on 8/17/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class InscreverUIViewController: UIViewController {

    @IBAction func voltar(sender: AnyObject) {
        performSegueWithIdentifier("principal", sender: self)
    }
}
