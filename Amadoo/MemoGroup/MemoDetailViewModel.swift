//
//  MemoDetailViewModel.swift
//  Amadoo
//
//  Created by 시모니 on 12/14/23.
//

import UIKit
import Combine
import CoreData

class MemoDetailViewModel {
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    
    @Published var memodata: String = "" {
        didSet {
            print("텍스트필드에 값들어왓노? 들어온값은 --> \(memodata)")
        }
    }
    
    var bag = Set<AnyCancellable>()
    
    func saveData(data: String) {
        
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "MemoData", into: context)
        newEntity.setValue(data, forKey: "memo")
        
        if context.hasChanges {
            do {
                try context.save()
                print("메모를 코어데이터에 저장성공")
            } catch {
                print("메모를 코어데이터에 저장실패, 실패내용 --> \(error.localizedDescription)")
            }
        }
        print("sendData 프로토콜발동! 배열에도 추가했고 , 코어데이터에도 추가했어.")
    }
    
}
