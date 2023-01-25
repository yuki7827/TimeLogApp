//
//  HistoryDetailViewController.swift
//  TimeLogApp
//
//  Created by 福島友稀 on 2020/04/26.
//  Copyright © 2020 Baminami. All rights reserved.
//


import UIKit
import Eureka
import UserNotifications


class HistoryDetailViewController: FormViewController {
    
    var history: Dictionary<String, Any>?
    var timeLogList: Array<Dictionary<String, Any>>?
    var index: Int?
    var isFinished: Bool?
    var isNotification = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeLogList = UserDefaults.standard.object(forKey: "timeLogList") as? Array<Dictionary<String, Any>> ?? []
        self.history = self.timeLogList?[index!]
        
        //フォーム作成
        form +++ Section("title")
            <<< TextRow("title1") {row in
                row.title = "タイトル"
                row.placeholder = "タイトルを入力してください"
                row.value = history?["taskName"] as? String ?? ""
            }.onChange { row in
                let value = row.value
                if let printValue = value {
                    print(printValue)
                }
                //変数に入力内容を入れる
                if let index = self.index,
                    let rowValue = value {
                    self.timeLogList?[index]["taskName"] = rowValue
                    self.history?["taskName"] = rowValue
                    UserDefaults.standard.set( self.timeLogList, forKey: "timeLogList" )
                }
            }
            //            <<< TextAreaRow {row in
            //                row.placeholder = "メモを入力"
            //                row.value = self.history?["memo"] as? String
            //                }.onChange { row in
            //                    let value = row.value
            //                    if let printValue = value {
            //                        print(printValue)
            //                    }
            //
            //                    //変数に入力内容を入れる
            //                    if let index = self.index,
            //                        let rowValue = value {
            //                        if self.isFinished! {
            //                            didList[index]["memo"] = rowValue
            //                            //変数の中身をUDに追加
            //                            UserDefaults.standard.set( didList, forKey: "didList" )
            //                        } else {
            //                            todoList[index]["memo"] = rowValue
            //                            //変数の中身をUDに追加
            //                            UserDefaults.standard.set( todoList, forKey: "todoList" )
            //                        }
            //                        self.detailTodo?["memo"] = value
            //                    }
            //            }
            //            // ここからセクション2のコード
            //            +++ Section("セクション2")
            //            <<< TextRow { row in
            //                row.title = "1行メモ"
            //                row.placeholder = "1行メモを入力"
            //            }
            
            //            +++ Section("セクション4")
            <<< DateTimeRow("startTime") {
                $0.title = "開始日時"
                $0.value = history?["startTime"] as? Date
            }.onChange { row in
                let value = row.value
                print(value!)
                //変数に入力内容を入れる
                if let index = self.index,
                    let rowValue = value {
                    self.timeLogList?[index]["startTime"] = rowValue
                    let endTime = self.history?["endTime"] as! Date
                    let timeInterval = endTime.timeIntervalSince(rowValue)
                    let min = String(format: "%02d", Int(floor(Double(timeInterval))) / 60 % 60)
                    let hour = String(format: "%02d", Int(floor(Double(timeInterval))) / 3600)
                    self.timeLogList?[index]["passageTime"] = "\(hour):\(min)"
                    //変数の中身をUDに追加
                    UserDefaults.standard.set(self.timeLogList, forKey: "timeLogList" )
                    
                    self.history = self.timeLogList?[index]
                }
            }
            
            <<< DateTimeRow("endTime") {
                $0.title = "終了日時"
                $0.value = history?["endTime"] as? Date
            }.onChange { row in
                let value = row.value
                print(value!)
                //変数に入力内容を入れる
                if let index = self.index,
                    let rowValue = value {
                    self.timeLogList?[index]["endTime"] = rowValue
                    //変数の中身をUDに追加
                    UserDefaults.standard.set(self.timeLogList, forKey: "timeLogList" )
                    
                    self.history?["endTime"] = value
                }
            }
            
            <<< PickerInlineRow<String> {row in
                row.title = "作業時間登録用"
                row.options = ["0.25","0.50","0.75","1.00","1.25","1.50","1.75","2.00","2.25","2.50","2.75","3.00","3.25","3.50","3.75","4.00","4.25","4.50","4.75","5.00","5.25","5.50","5.75","6.00","6.25","6.50","6.75","7.00","7.25","7.50","7.75","8.00","8.25","8.50","8.75","9.00","9.25","9.50","9.75"]
                row.value = self.history?["workTime"] as? String
            }.onChange { row in
                if let index = self.index {
                    let value = row.value
                    self.timeLogList?[index]["workTime"] = value
                    //変数の中身をUDに追加
                    UserDefaults.standard.set(self.timeLogList, forKey: "timeLogList")
                    self.history?["workTime"] = value
                    
                    if let printValue = value {
                        print(printValue)
                    }
                }
            }
            
            <<< ButtonRow() {
                $0.title = "作業時間登録実行"
            }.cellSetup() { cell, row in
                cell.backgroundColor = UIColor.white
                cell.textLabel?.textColor = UIColor.red
            }.onCellSelection { cell, row in
                let calendar = Calendar.current
                let startDate = self.history?["startTime"] as! Date
                var param: Dictionary<String, Any> = [:]
                param["issueId"] = self.history?["issueId"] as? String
                param["year"] = calendar.component(.year, from: startDate)
                param["month"] = calendar.component(.month, from: startDate)
                param["day"] = calendar.component(.day, from: startDate)
                param["time"] = self.history?["workTime"] as? String

                HTTPUtil.getJsonData(url: "http://yuki7827.m10.coreserver.jp/saveWorkTime", addParamaters: param) { (json) in }
            }
        
            
//            <<< SwitchRow(){ row in
//                row.title = "通知ON/OFF"
//                row.value = detailTodo?["isNotification"] as? Bool
//            }.onChange{[unowned self] row in
//                if let index = self.index {
//                    let value = row.value
//                    if self.isFinished! {
//                        didList[index]["isNotification"] = value
//                        self.isNotification = value!
//                        //変数の中身をUDに追加
//                        UserDefaults.standard.set( didList, forKey: "didList" )
//                    } else {
//                        todoList[index]["isNotification"] = value
//                        self.isNotification = value!
//
//                        //変数の中身をUDに追加
//                        UserDefaults.standard.set( todoList, forKey: "todoList" )
//                    }
//                    self.detailTodo?["isNotification"] = value
//                    print(value!)
//                    let notification = self.detailTodo?["notification"] as? String ?? "0分前"
//                    var splitArray = notification.components(separatedBy: "分前")
//                    if self.isNotification {
//                        NotificationUtil.notificationSetting(title: self.detailTodo!["title"] as! String, body: self.detailTodo!["memo"] as! String, fromDate: self.detailTodo!["dateTime"] as! Date, addTime: (Int)(splitArray[0]) ?? 0  )
//                    } else {
//                        NotificationUtil.deleteNotification(identifier: self.detailTodo!["title"] as! String)
//                    }
//                }
//        }
        
        // Do any additional setup after loading the view.
        //detailLabel.text = detailMessage
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func FinishButtonTapped(){
//        didList.append(todoList[index!])
//        todoList.remove(at: index!)
//        UserDefaults.standard.set( todoList, forKey: "todoList" )
//        UserDefaults.standard.set( didList, forKey: "didList" )
//        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func NoFinishButtonTapped(){
//        todoList.append(didList[index!])
//        didList.remove(at: index!)
//        UserDefaults.standard.set( todoList, forKey: "todoList" )
//        UserDefaults.standard.set( didList, forKey: "didList" )
//        self.navigationController?.popViewController(animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
