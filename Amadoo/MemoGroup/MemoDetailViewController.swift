//
//  MemoDetailViewController.swift
//  Amadoo
//
//  Created by MAC on 11/17/23.
//

import UIKit


protocol MemoDataProtocol {
    func sendData(data: String)
}

class MemoDetailViewController: UIViewController {
    
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var memoTextField: UITextField!
    
    var delegate: MemoDataProtocol?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerBtn.layer.cornerRadius = 20
        memoTextField.placeholder = "메모를 작성해 주세요."
        
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        guard let data = memoTextField.text , !data.isEmpty else {return}
        if let data = memoTextField.text {
            delegate?.sendData(data: data)
        }
        navigationController?.popViewController(animated: true)
    }
}


