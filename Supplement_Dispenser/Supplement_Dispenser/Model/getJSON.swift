//
//  getJSON.swift
//  Supplement_Dispenser
//
//  Created by ROLF J. on 2022/07/19.
//

import Foundation

struct didDone: Codable {
    var m2m: jsonToData
    
    enum CodingKeys: String, CodingKey {
        case m2m = "m2m:cin"
    }
}

struct jsonToData: Codable {
    var pi: String
    var ri: String
    var ty: Int
    var ct: String
    var st: Int
    var rn: String
    var lt: String
    var et: String
    var cs: Int
    var cr: String
    var con: String
}
