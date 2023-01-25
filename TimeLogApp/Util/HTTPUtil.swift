//
//  HTTPUtil.swift
//  TimeLogApp
//
//  Created by 福島友稀 on 2020/04/14.
//  Copyright © 2020 Baminami. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HTTPUtil {
    /// APIを呼び出し
    static func getJsonData(url: String, addParamaters: Dictionary<String, Any> = [:], completion: @escaping (JSON) -> Void) {
        var parameters: Dictionary<String, Any> = [:]
        parameters["username"] = "y-fukushima"
        parameters["password"] = "yukiyuki314"
        parameters.merge(addParamaters) { (_, new) in new }
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            print("in response")
            switch (response).result {
            case .success(let Value):
                print("success")
                completion(JSON(Value))
            case .failure(let Error):
                print(Error)
                completion(JSON(Error))
            }
        }
    }
}
