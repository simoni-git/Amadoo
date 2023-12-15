//
//  ViewController.swift
//  Amadoo
//
//  Created by MAC on 11/16/23.
//

import UIKit
import FSCalendar
import CoreData

class CalenderViewController: UIViewController  {
    
    var viewmodel: CalenderViewModel!
    
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addEventBtn: UIButton!
    
    var selectedDate: Date? // calenderDidSelcted 메서드에서 날짜가 눌리면 해당 날짜가 잠시 저장되는 변수를 만들어 준거임.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calenderView.delegate = self
        calenderView.dataSource = self
        viewmodel = CalenderViewModel()
        configureView()
        viewmodel.readCoreData()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        self.calenderView.reloadData()
    }
    
    @IBAction func tapQuestionmark(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "도움말", message: "🔴오늘날짜  , 🔵선택한날짜 , 일정 지우는 방법: 일정이 있는 날짜를 선택후 일정을 왼쪽으로 드래그 " , preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okBtn)
        present(alert, animated: true)
    }
    
    @IBAction func tapAddEventBtn(_ sender: UIButton) {
        guard let calenderDtVC = self.storyboard?.instantiateViewController(identifier: "CalenderDetailViewController") as? CalenderDetailViewController else {return}
        calenderDtVC.calenderVM = self.viewmodel
        
        navigationController?.pushViewController(calenderDtVC, animated: true)
    }

    func dateFormat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
    
    func configureView() {
        calenderView.scope = .month // 월단위로 보기
        calenderView.locale = Locale(identifier: "ko_KR") // 요일 한국어로 바꿔주고~
        calenderView.scrollEnabled = true   // 스크롤가능?? 가능~
        calenderView.scrollDirection = .horizontal // 스크롤방향은 좌우로가능~
        calenderView.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 20) // 헤더타이틀은 두껍게~ 20사이즈로
        calenderView.appearance.headerDateFormat = "YYYY년 MM월" // 한국형으로 구조 바꿔주고~
        addEventBtn.layer.cornerRadius = 20
    }
    
}

extension CalenderViewController: FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        //calendar(_:imageFor:) 메서드는 달력 셀에 이미지를 설정하는 메서드다
        
            let dateString = dateFormat(date)
            print("Checking for events on date: \(dateString)")
            
            // 이벤트 배열에서 현재 날짜와 일치하는 이벤트가 있는지 확인
        if viewmodel.events.contains(where: { $0.date == dateString }) {
                // 이벤트가 있는 경우 이미지 반환 (이미지를 원하는 이미지로 바꾸세요)
                print("이벤트가 있는 경우 이미지 반환")
                return UIImage(named: "1717")
            }
            // 이벤트가 없는 경우 nil 반환
            print("이벤트가 없는 경우 nil 반환")
            return nil
        }
    
}

extension CalenderViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) { // 날짜선택ㅂ메서드
        let dateFormettor = DateFormatter()
        dateFormettor.locale = Locale(identifier: "ko_KR")
        dateFormettor.dateFormat = "yyyy년 MM월 dd일"
        print(dateFormettor.string(from: date) + "날짜가 선택되었스빈다")
        
        selectedDate = date // 날짜가 눌리면 그 날짜에 해당하는 날짜가 위에변수에 찍히는거임.
        tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) { // 날짜 선택 해제 메서드
        let dateFormettor = DateFormatter()
        dateFormettor.locale = Locale(identifier: "ko_KR")
        dateFormettor.dateFormat = "yyyy년 MM월 dd일"
        print(dateFormettor.string(from: date) + "날짜가 선택해제되었습빈다")
    }

}
    
extension CalenderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let selectedDate = selectedDate {
            // 선택한 날짜에 해당하는 이벤트를 가져오기
            let dateString = dateFormat(selectedDate)
            let eventsForSelectedDate = viewmodel.events.filter { $0.date == dateString }
            return eventsForSelectedDate.count
        } else {
            // 선택한 날짜가 없을 경우 기본 개수 반환
            return 0
            // 리턴이 1인 이유는, 위에 if let selectedData 는 사용자가 날짜를 눌렀을때 해당하는거고, 혹시나 사용자가 아무것도 누르지 않은 상태라면 기본적으로 셀은 한개 있어야 하기 때문에 기본값이 1 인거임. 이메서드는 셀 몇개보여줄까~ 니까!
            //근데 1로하니까 굳이 안나와도될것이 나와서 0 으로 바꿈 . 해결완.
        }
    }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as? EventCell else {
                return UITableViewCell()
            }
            
            if let selectedDate = selectedDate {
                       // 선택한 날짜에 해당하는 이벤트를 가져오기
                       let dateString = dateFormat(selectedDate)
                let eventsForSelectedDate = viewmodel.events.filter { $0.date == dateString }
                       
                       if indexPath.row < eventsForSelectedDate.count {
                           // 이벤트가 있을 경우 해당 이벤트 표시
                           // indexPath.row 값은 0임. 왜냐면 기본적으로 셀은 한개가 있고, 그걸 행으로 나타내면 순번이 0이니까.
                           let event = eventsForSelectedDate[indexPath.row]
                           cell.eventLabel.text = event.eventText
                       } else {
                           // 이벤트가 없을 경우 기본 텍스트 표시
                           cell.eventLabel.text = "없음"
                       }
                   } else {
                       // 선택한 날짜가 없을 경우 기본 텍스트 표시
                       cell.eventLabel.text = "없음"
                   }
                   
                   return cell
               }
           }

extension CalenderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let data = viewmodel.events[indexPath.row]
            viewmodel.events.remove(at: indexPath.row)
            viewmodel.deleteCoreData(data)
        }
        self.tableView.reloadData()
        self.calenderView.reloadData()
    }
}
