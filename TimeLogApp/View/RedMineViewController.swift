//
//  TopViewController.swift
//  TimeLogApp
//
//  Created by Apple on 2020/03/20.
//  Copyright © 2020年 Baminami. All rights reserved.
//

import Foundation
import UIKit

class RedMineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var taskList: Array<Dictionary<String, Any>> = []
    
    @IBOutlet weak var tableView: UITableView!
    
    //表示するcell数を決めるデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    //表示するcellの中身を決めるデリゲートメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RedMineTableViewCell", for: indexPath) as! RedMineTableViewCell
        //変数の中身を作る
        cell.taskName.text = taskList[indexPath.row]["id_subject"] as? String ?? ""
        //戻り値の設定（表示する中身)
        return cell
    }
    
    //セルをタップした際に画面遷移をする
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 別の画面に遷移
        if let topVC = self.tabBarController?.viewControllers?[0] as? TopViewController {
            topVC.taskTextView.text = self.taskList[indexPath.row]["id_subject"] as? String ?? ""
            self.tabBarController?.selectedIndex = 0
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "RedMineTableViewCell", bundle: nil), forCellReuseIdentifier: "RedMineTableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        HTTPUtil.getJsonData(url: "http://yuki7827.m10.coreserver.jp/getIssues") { (json) in
            let array = json.arrayObject
            self.taskList = array as? Array<Dictionary<String, Any>> ?? []
            self.tableView.reloadData()
        }
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
