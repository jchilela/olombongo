//
//  EcraInicialViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Júlio Gabriel Chilela on 8/17/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit


class EcraInicialViewController: UIViewController {
    @IBAction func entrar(sender: AnyObject) {
        performSegueWithIdentifier("entrar", sender: self)
    }

    @IBAction func inscrever(sender: AnyObject) {
        performSegueWithIdentifier("inscrever", sender: self)
    }
}
