//
//  InstagramPost.swift
//  Instagram Client
//
//  Created by yusuf_kildan on 07/05/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import Foundation
class InstagramPost {
    
    private var _userName : String!
    private var _publishTime : String!
    private var _mainImageURL : String!
    private var _userImageURL : String!
    
    var userName : String {
        return _userName
    }
    
    var publishTime : String {
        return _publishTime
    }
    
    var mainImageURL : String {
        return _mainImageURL
    }
    var userImageURL : String {
        return _userImageURL
    }
    
    
    init(userName : String , publishTime : String , mainImageURL : String , userImageURL : String) {
        
        self._userName = userName
        self._publishTime = publishTime
        self._mainImageURL = mainImageURL
        self._userImageURL = userImageURL
        
    }
    
}