//
//  DidViewController.swift
//  Todoapl
//
//  Created by Apple on 2018/10/07.
//  Copyright © 2018年 Baminami. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var taskList: Array<Dictionary<String, String>> = []
    
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
        cell.taskName.text = taskList[indexPath.row]["taskName"]
        cell.time.text = taskList[indexPath.row]["passageTime"]
        //戻り値の設定（表示する中身)
        return cell
    }
    
    //セルをタップした際に画面遷移をする
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        self.taskList = UserDefaults.standard.array(forKey: "timeLogList") as! Array<Dictionary<String, String>>
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
