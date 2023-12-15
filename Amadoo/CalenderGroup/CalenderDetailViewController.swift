//
//  CalenderDetailViewController.swift
//  Amadoo
//
//  Created by MAC on 11/21/23.
//

import UIKit
import Combine

class CalenderDetailViewController: UIViewController {
    
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var eventTextField: UITextField!
    @IBOutlet var eventRegisterBtn: UIButton!
    
    var viewmodel: CalenderDetailViewModel!
    var calenderVM: CalenderViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        eventRegisterBtn.layer.cornerRadius = 20
        viewmodel = CalenderDetailViewModel()
        
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
        viewmodel.saveCoreData(date: dateText, eventName: eventText)
        viewmodel.date = dateText
        viewmodel.event = eventText
        viewmodel.$date.assign(to: \.date, on: calenderVM)
            .store(in: &viewmodel.bag)
        viewmodel.$event.assign(to: \.event, on: calenderVM)
            .store(in: &viewmodel.bag)
        
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) 
    }
    
}
