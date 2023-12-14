//
//  MemoViewModel.swift
//  Amadoo
//
//  Created by 시모니 on 12/14/23.
//

import UIKit
import CoreData

class MemoViewModel {
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    
    func changeType(_ managedObject: NSManagedObject) -> String {
        let data = managedObject.value(forKey: "memo") as? String ?? ""
        return data
    }
    
    func readCoreData() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "MemoData")
        do {
            let data = try context.fetch(request)
            memos = data.map{changeType($0)}
            print("메모 코어데이터를 정상적으로 Read 했어.")
        } catch {
            print("메모 코어데이터를 Read 하지 못했어. --> \(error.localizedDescription)")
        }
    }
    
    func deleteCoreData(_ memo: String) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "MemoData")
        request.predicate = NSPredicate(format: "memo == %@", memo)
        
        do {
            let results = try context.fetch(request)
            for object in results {
                context.delete(object)
                print("메모 코어데이터를 성공적으로 delete 했어.")
            }
            try context.save()
        } catch {
            print("메모 코어데이터를 delete 하지 못했어 -->  \(error.localizedDescription)")
        }
    }
    
    var memos = [String]() {
        didSet {
            print(" didSet 호출됬다. --> memos 배열의 갯수는 ? \(memos.count) 개")
            
        }
    }
    
    var memo: String = "" {
        didSet {
            print("값이 퍼블리쉬드한테서 왔다. 내값은 --> \(memo)")
            memos.append(memo)
        }
    }
    
}
