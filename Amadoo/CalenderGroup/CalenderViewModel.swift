//
//  CalenderViewModel.swift
//  Amadoo
//
//  Created by 시모니 on 12/15/23.
//

import UIKit
import CoreData

class CalenderViewModel {
    
    var date: String = "" {
        didSet {
            print("퍼블리셔한테서 값이 전달되어왔다. 날짜는!? --> \(date)")
        }
    }
    var event: String = "" {
        didSet {
            print("퍼블리셔한테서 값이 전달되어왔다. 이벤트는!? --> \(event)")
            makeStructAndAppendData() // 여기에넣은이유는 퍼블리셔가 date 가 먼저 들어오고 그다음에 event 가 들어오니까 이걸 구조체로 바꿔서 배열에 넣어야함.
        }
    }
    
    func makeStructAndAppendData() {
        var date = self.date
        var event = self.event
        let data = Event(date: date, eventText: event)
        self.events.append(data)
        
    }
    
    var events: [Event] = [] {
        didSet {
            print("event 배열의 갯수는 --> \(events.count) 개")
        }
    }
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    
    func changeType(_ managedObject: NSManagedObject) -> Event{
        let date = managedObject.value(forKey: "eventDate") as? String ?? ""
        let eventName = managedObject.value(forKey: "eventText") as? String ?? ""
        return Event(date: date, eventText: eventName)
    }
    
    func readCoreData() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "EventData")
        do {
            let data = try context.fetch(request)
            events = data.map {changeType($0)}
            print("캘린더 코어데이터를 정상적으로 Read 했어.")
        } catch {
            print("캘린더 코어데이터를 Read 하지 못했어. --> \(error.localizedDescription)")
        }
    }
    
    func deleteCoreData(_ event: Event) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "EventData")
        request.predicate = NSPredicate(format: "eventDate == %@", event.date)
        
        do {
            let results = try context.fetch(request)
            for object in results {
                context.delete(object)
                print("캘린더 코어데이터를 성공적으로 delete 했어.")
            }
            try context.save()
        } catch {
            print("캘린더 코어데이터를 delete 하지 못했어 -->  \(error.localizedDescription)")
        }
    }
   
}
