//
//  MemoViewController.swift
//  Amadoo
//
//  Created by MAC on 11/16/23.
//

import UIKit

class MemoViewController: UIViewController {
    
    var viewmodel: MemoViewModel!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var writeMemoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        writeMemoBtn.layer.cornerRadius = 20
        viewmodel = MemoViewModel()
        viewmodel.readCoreData()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    @IBAction func tapWriteBtn(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "MemoDetailViewController") as? MemoDetailViewController else {return}
        
        vc.memoViewModel = self.viewmodel
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
    
}

extension MemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as? MemoCell else {
            return UITableViewCell()
        }
        let data = viewmodel.memos[indexPath.row]
        cell.memoLabel.text = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let memo = viewmodel.memos[indexPath.row]
            viewmodel.memos.remove(at: indexPath.row)
            viewmodel.deleteCoreData(memo)
        }
        tableView.reloadData()
    }
    
}

extension MemoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
