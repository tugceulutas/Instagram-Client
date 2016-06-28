//
//  Constants.swift
//  Instagram Client
//
//  Created by yusuf_kildan on 07/05/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import Foundation

let ACCES_TOKEN = "1283628897.1677ed0.abdcdc02b9604c1984f2f095d8194e37"
let RECENT_POST_URL = "https://api.instagram.com/v1/tags/nofilter/media/recent?access_token=\(ACCES_TOKEN)"
let INSTANCE = ApiManager.Instance
var SEARCH_TEXT : String!
typealias DownloadComplete = () -> ()
