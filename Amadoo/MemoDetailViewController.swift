//
//  MemoDetailViewController.swift
//  Amadoo
//
//  Created by MAC on 11/17/23.
//

import UIKit
import CoreData

protocol DataProtocol {
    func sendData(data: String)
}

class MemoDetailViewController: UIViewController {
    
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var memoTextField: UITextField!
    
    var delegate: DataProtocol?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerBtn.layer.cornerRadius = 20
        
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        guard let data = memoTextField.text , !data.isEmpty else {return}
        if let data = memoTextField.text {
            delegate?.sendData(data: data)
        }
        navigationController?.popViewController(animated: true)
    }
}


