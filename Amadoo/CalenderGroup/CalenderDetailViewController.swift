//
//  CalenderDetailViewController.swift
//  Amadoo
//
//  Created by MAC on 11/21/23.
//

import UIKit

protocol CalenderDataProtocol {
    func sendData(date: String , eventName: String)
}

class CalenderDetailViewController: UIViewController {
    
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var eventTextField: UITextField!
    @IBOutlet var eventRegisterBtn: UIButton!
    var delegate: CalenderDataProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        eventRegisterBtn.layer.cornerRadius = 20
        
    }
    
    func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        
        dateTextField.inputView = datePicker
        dateTextField.placeholder = "날짜를 선택해 주세요"
        eventTextField.placeholder = "일정을 작성해 주세요."
        
    }
    
    @objc func changeDate(_ datePicker: UIDatePicker) {
        self.dateTextField.text = dateFormat(datePicker.date)
    }
    
    func dateFormat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
    
    
    @IBAction func tapEventRegisterBtn(_ sender: UIButton) {
        guard let dateText = dateTextField.text , !dateText.isEmpty,
              let eventText = eventTextField.text , !eventText.isEmpty else {return}
        
        if let dateText = dateTextField.text , let eventText = eventTextField.text {
            delegate?.sendData(date: dateText, eventName: eventText)
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) // 저번프로젝트에이어 또사용하는 키보드내려가랏메서드
    }
    
}
