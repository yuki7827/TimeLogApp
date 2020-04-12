//
//  CountPresenter.swift
//  SwiftMVPSample
//
//  Created by Hayashi Tsubasa on 2017/01/09.
//  Copyright © 2017年 Tsubasa Hayashi. All rights reserved.
//

import Foundation
// Not import UIKit

final class TimeLogPresenter {

    private let view: TimeLogDelegate
    private var model: TimeLogModel
    private var timer: Timer?
        
    required init(view: TimeLogDelegate, model: TimeLogModel) {
        self.view = view
        self.model = model
        self.timer = nil
    }

    func onTapButton(buttonType: TimeLogConst.ButtonType) {
        // 計測開始時
        switch buttonType {
        case .MEASURE_START:
            model.startTime = Date()
            model.buttonType = .MEASURE_END
            view.onViewChange(model: model)
            startCountUp()
        case .MEASURE_END:
            model.endTime = Date()
            stopCountUp()
            saveModelData(model: model)
            model.buttonType = .MEASURE_START
            view.onViewChange(model: model)
        }
    }
    
    private func startCountUp() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.model.timerCount = Int(Date().timeIntervalSince(self.model.startTime!))

            let sec = String(format: "%02d", self.model.timerCount % 60)
            let min = String(format: "%02d", Int(floor(Double(self.model.timerCount) / 60)))
            let hour = String(format: "%02d", Int(floor(Double(self.model.timerCount) / 3600)))
            self.model.passageTime = "\(hour):\(min):\(sec)"
            self.view.onViewChange(model: self.model)
        })
    }
    
    private func stopCountUp() {
        self.timer?.invalidate()
    }
    func saveModelData(model: TimeLogModel) {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy年M月d日H:m:s", options: 0, locale: Locale(identifier: "ja_JP"))
        print(formatter.string(from: Date())) // 2017年8月12日
        var dict: Dictionary<String, String> =  [:]
            dict["startTime"] = formatter.string(from: model.startTime ?? Date())
            dict["endTime"] = formatter.string(from: model.endTime ?? Date ())
        dict["passageTime"] = model.passageTime
            dict["taskName"] = model.taskName
        var timeLoglist = getModelData()
        timeLoglist.append(dict)
        UserDefaults.standard.set(timeLoglist, forKey: "timeLogList")
        
    }
    
    func getModelData() -> Array<Dictionary<String, String>> {
        if let timeLogList = UserDefaults.standard.object(forKey: "timeLogList") as? Array<Dictionary<String, String>> {
            print(timeLogList)
            return timeLogList
        }
        return []
    }
    
}
