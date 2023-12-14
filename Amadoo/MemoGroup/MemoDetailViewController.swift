//
//  MemoDetailViewController.swift
//  Amadoo
//
//  Created by MAC on 11/17/23.
//

import UIKit
import Combine

class MemoDetailViewController: UIViewController {
    
    var memoViewModel: MemoViewModel!
    var viewmodel: MemoDetailViewModel!
    
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var memoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        viewmodel = MemoDetailViewModel()
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        guard let data = memoTextField.text , !data.isEmpty else {return}
        
        viewmodel.saveData(data: data) // 받은 data 를 코어데이터에 저장함.
        viewmodel.memodata = data // 받은 data 를 뷰모델의 퍼블리쉬드한테 보냄
        viewmodel.$memodata.assign(to: \.memo, on: memoViewModel)
            .store(in: &viewmodel.bag)
        
        navigationController?.popViewController(animated: true)
    }
    
    private func configureView() {
        registerBtn.layer.cornerRadius = 20
        memoTextField.placeholder = "메모를 작성해 주세요."
    }
    
}


