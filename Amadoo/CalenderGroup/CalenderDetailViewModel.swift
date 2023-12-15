//
//  CalenderDetailViewModel.swift
//  Amadoo
//
//  Created by 시모니 on 12/15/23.
//

import UIKit
import Combine
import CoreData

class CalenderDetailViewModel {
    
    @Published var date: String = "" {
        didSet {
            print("일정등록버튼이 눌리면서 @published 에 값이 들어왔다. date 값은 --> \(date)")
        }
    }
    @Published var event: String = "" {
        didSet {
            print("일정등록버튼이 눌리면서 @published 에 값이 들어왔다. event 값은 --> \(event)")
        }
    }
    
    var bag = Set<AnyCancellable>()
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    
    func saveCoreData(date: String , eventName: String) {
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "EventData", into: context)
        newEntity.setValue(date, forKey: "eventDate")
        newEntity.setValue(eventName, forKey: "eventText")
        
        if context.hasChanges {
            do {
                try context.save()
                print("캘린더이벤트를 코어데이터에 저장성공")
            } catch {
                print("캘린더이벤트를 코어데이터에 저장실패, 실패내용 --> \(error.localizedDescription)")
            }
        }
        
    }
    
}
