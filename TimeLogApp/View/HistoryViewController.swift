//
//  DidViewController.swift
//  Todoapl
//
//  Created by Apple on 2018/10/07.
//  Copyright © 2018年 Baminami. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var taskList: Array<Dictionary<String, Any>> = []
    
    @IBOutlet weak var tableView: UITableView!
    
    //表示するcell数を決めるデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    //表示するcellの中身を決めるデリゲートメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        //変数の中身を作る
//        cell.textLabel!.text = taskList[indexPath.row]["taskName"]
        let taskName = taskList[indexPath.row]["taskName"] as? String ?? ""
        if taskName.hasPrefix("#") {
            let idTaskName = String(taskName[taskName.index(taskName.startIndex, offsetBy: 1)...])
            let underScoreIndex = idTaskName.index(of: "_")
            var id: String?
            var task: String?
            if let index = underScoreIndex {
                id = String(idTaskName[..<index])
                let underScoreTask = String(idTaskName[index...])
                task = String(underScoreTask[underScoreTask.index(underScoreTask.startIndex, offsetBy: 1)...])
            }
            if let id = id {
                cell.categoryName.text = id
            }
            if let task = task {
                cell.taskName.text = task
            } else {
                cell.taskName.text = taskList[indexPath.row]["taskName"] as? String ?? ""
            }
        }
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy年M月d日H:m", options: 0, locale: Locale(identifier: "ja_JP"))
        print(formatter.string(from: Date())) // 2017年8月12日
        //            dict["startTime"] = formatter.string(from: model.startTime ?? Date())
        let startTime = formatter.string(from: taskList[indexPath.row]["startTime"] as! Date)
        let endTime = formatter.string(from: taskList[indexPath.row]["endTime"] as! Date)

        cell.time.text = "\(startTime)~\(endTime)"
//        var passageTime = taskList[indexPath.row]["passageTime"] as? String ?? ""
//        passageTime = String(passageTime[...passageTime.index(passageTime.startIndex, offsetBy: 4)])
        cell.passageTime.text = taskList[indexPath.row]["passageTime"] as? String ?? ""
        //戻り値の設定（表示する中身)
        return cell
    }
    
    //セルをタップした際に画面遷移をする
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let historyDetailVC = HistoryDetailViewController()
        historyDetailVC.index = indexPath.row
        self.present(historyDetailVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.taskList = UserDefaults.standard.array(forKey: "timeLogList") as? Array<Dictionary<String, Any>> ?? []
        tableView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        //override前の処理を継続してさせる
        super.setEditing(editing, animated: animated)
        //tableViewの編集モードを切り替える
        tableView.isEditing = editing //editingはBool型でeditButtonに依存する変数
    }
    
    // Cellのスワイプ処理
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let swipeCellToDelete = UITableViewRowAction(style: .default, title: "削除") { action, index in
            self.swipeDelete(indexPath: indexPath)// 押されたときの動きを定義しています
        }
        let swipeCellToNoFinish = UITableViewRowAction(style: .default, title: "未完了") { action, index in
            self.swipeNoFinish(index: index.row, indexPath: indexPath)
        }
        
        // 背景色
        swipeCellToDelete.backgroundColor = .red
        swipeCellToNoFinish.backgroundColor = .green
        // 配列の右から順で表示される
        return [swipeCellToNoFinish, swipeCellToDelete]
    }
    
    // trueを返すことでCellのアクションを許可しています
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // スワイプされたとき用のメソッド
    func swipeDelete(indexPath: IndexPath) {
        taskList.remove(at: indexPath.row)
        UserDefaults.standard.set( taskList, forKey: "didList" )
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func swipeNoFinish(index: Int, indexPath: IndexPath) {

    }
}
