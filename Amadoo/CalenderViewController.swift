//
//  ViewController.swift
//  Amadoo
//
//  Created by MAC on 11/16/23.
//

import UIKit
import FSCalendar

class CalenderViewController: UIViewController {
    
    @IBOutlet weak var calenderView: FSCalendar!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    func configureView() {
        calenderView.scope = .month // 월단위로 보기
        calenderView.locale = Locale(identifier: "ko_KR") // 요일 한국어로 바꿔주고~
        calenderView.scrollEnabled = true   // 스크롤가능?? 가능~
        calenderView.scrollDirection = .horizontal // 스크롤방향은 좌우로가능~
        calenderView.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 20) // 헤더타이틀은 두껍게~ 20사이즈로
       
        calenderView.appearance.headerDateFormat = "YYYY년 MM월" // 한국형으로 구조 바꿔주고~
        
        

    }

}

//extension CalenderViewController: FSCalendarDataSource {
//    
//}

extension CalenderViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) { // 날짜선택ㅂ메서드
        let dateFormettor = DateFormatter()
        dateFormettor.locale = Locale(identifier: "ko_KR")
        dateFormettor.dateFormat = "yyyy년 MM월 dd일"
        print(dateFormettor.string(from: date) + "날짜가 선택되었스빈다")
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) { // 날짜 선택 해제 메서드
        let dateFormettor = DateFormatter()
        dateFormettor.locale = Locale(identifier: "ko_KR")
        dateFormettor.dateFormat = "yyyy년 MM월 dd일"
        print(dateFormettor.string(from: date) + "날짜가 선택해제되었습빈다")
    }
}

