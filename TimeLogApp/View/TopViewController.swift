//
//  TopViewController.swift
//  TimeLogApp
//
//  Created by Apple on 2020/03/20.
//  Copyright © 2020年 Baminami. All rights reserved.
//

import Foundation
import UIKit

protocol TimeLogDelegate: class {
    func onViewChange(model: TimeLogModel)
}

class TopViewController: UIViewController {
    
    private var presenter: TimeLogPresenter?
    private var timeLogModel: TimeLogModel!
    private var startTimeLabel: UILabel!
    private var taskTextView: UITextField!
    private var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
        self.view.backgroundColor = UIColor.white

        myButton = UIButton()
        myButton.frame = view.frame
        myButton.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 20)
        myButton.setTitle(TimeLogConst.ButtonType.MEASURE_START.rawValue, for: .normal)
        myButton.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        myButton.translatesAutoresizingMaskIntoConstraints = false

        //上記の内容でViewController上に配置する
        self.view.addSubview(myButton)
        
        //タップを押した時の処理 tapButtonを実行 引数(_:)によってボタンそのものを引数として受け取る
        myButton.addTarget(self, action: #selector(self.tapButton(_:)), for: UIControl.Event.touchUpInside)
        
        myButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        myButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        startTimeLabel = UILabel()
        startTimeLabel.backgroundColor = UIColor.red
        startTimeLabel.frame = view.frame
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(startTimeLabel)
        
        // redViewの横方向の中心は、親ビューの横方向の中心と同じ
        startTimeLabel.centerXAnchor.constraint(equalTo: self.myButton.centerXAnchor).isActive = true
        // redViewの縦方向の中心は、親ビューの縦方向の中心と同じ
        startTimeLabel.topAnchor.constraint(equalToSystemSpacingBelow: self.myButton.bottomAnchor, multiplier: 20).isActive = true
        
        taskTextView = UITextField()
        taskTextView.frame = view.frame
        taskTextView.translatesAutoresizingMaskIntoConstraints = false
        // プレースホルダを設定
        taskTextView.placeholder = "入力してください。"
        // キーボードタイプを指定
        taskTextView.keyboardType = .default
        // 枠線のスタイルを設定
        taskTextView.borderStyle = .roundedRect
        // 改行ボタンの種類を設定
        taskTextView.returnKeyType = .done
        taskTextView.layer.borderWidth = 1
        taskTextView.layer.borderColor = UIColor.black.cgColor

        self.view.addSubview(taskTextView)
        
        // redViewの横方向の中心は、親ビューの横方向の中心と同じ
        // redViewの縦方向の中心は、親ビューの縦方向の中心と同じ
        taskTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        taskTextView.topAnchor.constraint(equalTo: self.myButton.bottomAnchor, constant: 20).isActive = true
        taskTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        taskTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 20).isActive = true

    }
    
        private func initialize() {
            timeLogModel = TimeLogModel()
            presenter = TimeLogPresenter(view: self, model: timeLogModel)
        }
    
    
    //action tapButtonの内容。 (_:)のsenderはタップされたボタンを引数として渡すということ
    @objc  func tapButton(_ sender: UIButton) {
        print("ボタンがタップされました！")
        self.timeLogModel.taskName = self.taskTextView.text ?? ""
        if sender.currentTitle == TimeLogConst.ButtonType.MEASURE_START.rawValue {
            presenter?.onTapButton(buttonType: .MEASURE_START)
        } else {
            presenter?.onTapButton(buttonType: .MEASURE_END)
        }
    }
}

// MARK: CountViewDelegate
extension TopViewController: TimeLogDelegate {
    func onViewChange(model: TimeLogModel) {
        myButton.setTitle(model.buttonType.rawValue, for: .normal)
        startTimeLabel.text = model.passageTime
    }
    

}
