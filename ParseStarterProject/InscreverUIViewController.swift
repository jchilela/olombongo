//
//  InscreverUIViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Júlio Gabriel Chilela on 8/17/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class InscreverUIViewController: UIViewController {

   
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var endereco: UITextField!
    @IBOutlet weak var telefone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var dataDeNascimento: UIDatePicker!
    @IBOutlet weak var ultimoNome: UITextField!
    @IBOutlet weak var primeiroNome: UITextField!
    @IBAction func voltar(sender: AnyObject) {
        performSegueWithIdentifier("principal", sender: self)
    }
    @IBAction func criarCartao(sender: AnyObject) {
        performSegueWithIdentifier("irParaCartao", sender: self)
        
    }
}
