//
//  MemoViewController.swift
//  Amadoo
//
//  Created by MAC on 11/16/23.
//

import UIKit
import CoreData
	
class MemoViewController: UIViewController , DataProtocol {
    
    func sendData(data: String) {
        self.memos.append(data)
        print("sendData 프로토콜발동!")
    }
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var writeMemoBtn: UIButton!
    
    var memos = [String]() {
        didSet {
            print(" didSet 호출됬다. --> memos 배열의 갯수는 ? \(memos.count) 개")
            saveMemosArray()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMemosArray()
        writeMemoBtn.layer.cornerRadius = 20
        print("MemoViewController viewDidLoad 호출됨")
    }
    
    
    @IBAction func tapWriteBtn(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "MemoDetailViewController") as? MemoDetailViewController else {return}
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func saveMemosArray() {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(memos, forKey: "memos") 
        print("userDefault 로 MemosArray 를 저장했다. ")
      
    }
    

    func loadMemosArray() {
        let userDefaults = UserDefaults.standard
        if let savedMemos = userDefaults.object(forKey: "memos") as? [String] {
            self.memos = savedMemos
            print("loadMemosArray: -->  UD 로 저장된 memos 배열을 불러왔습니다 , memos배열엔 이런것들이있네요 --> \(memos)")
        }
        else {
            print("memos로 저장된거 없다 리턴한다")
            return
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
        self.memos.remove(at: indexPath.row)
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "data")
        print("UD 에서 데이터가 지워졌습니다")
        tableView.reloadData()
    }
}

extension MemoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}


/*
 
    메모 부분은 코어데이터만 적용하면 끝.

 */
