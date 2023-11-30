//
//  MemoViewController.swift
//  Amadoo
//
//  Created by MAC on 11/16/23.
//

import UIKit
import CoreData

class MemoViewController: UIViewController , MemoDataProtocol {
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    
    func sendData(data: String) {
        self.memos.append(data)
        
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
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var writeMemoBtn: UIButton!
    
    var memos = [String]() {
        didSet {
            print(" didSet 호출됬다. --> memos 배열의 갯수는 ? \(memos.count) 개")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readCoreData()
        writeMemoBtn.layer.cornerRadius = 20
        
        self.tableView.rowHeight = UITableView.automaticDimension
        
        print("MemoViewController viewDidLoad 호출됨")
    }
    
    @IBAction func tapWriteBtn(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "MemoDetailViewController") as? MemoDetailViewController else {return}
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func tapQuestionmark(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "도움말", message: "메모삭제방법: 메모를 왼쪽으로 드래그 " , preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okBtn)
        present(alert, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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
        self.tableView.reloadData()
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
    
}

extension MemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as? MemoCell else {
            return UITableViewCell()
        }
        let data = memos[indexPath.row]
        cell.memoLabel.text = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let memo = memos[indexPath.row]
            self.memos.remove(at: indexPath.row)
            deleteCoreData(memo)
        }
        tableView.reloadData()
    }
    
}

extension MemoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
