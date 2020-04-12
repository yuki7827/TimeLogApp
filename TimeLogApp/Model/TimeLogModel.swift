//
//  File.swift
//  SwiftMVPSample
//
//  Created by Hayashi Tsubasa on 2017/01/09.
//  Copyright © 2017年 Tsubasa Hayashi. All rights reserved.
//

import Foundation
// Not import UIKit

final class TimeLogModel {
    var buttonType: TimeLogConst.ButtonType
    var startTime: Date?
    var endTime: Date?
    var passageTime: String
    var timerCount: Int
    var taskName: String
    
    init() {
        self.buttonType = .MEASURE_START
        self.startTime = nil
        self.endTime = nil
        self.passageTime = ""
        self.timerCount = 0
        self.taskName = ""
    }
    

}
