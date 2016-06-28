//
//  ApiManager.swift
//  Instagram Client
//
//  Created by yusuf_kildan on 07/05/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit


class ApiManager {
    
    static let Instance = ApiManager()
    var posts = [InstagramPost]()
    var searchPosts = [InstagramPost]()
    var nextURL : String!
    
    //---------------------------------------------------
    func downloadLastPostDatas(completion : DownloadComplete){
        let url = NSURL(string: RECENT_POST_URL)!
        Alamofire.request(.GET, url).responseJSON { response in
            if let value = response.result.value {
                let json = JSON(value)
                self.nextURL = json["pagination"]["next_url"].stringValue
                if let datas = json["data"].array {
                    for data in datas {
                        
                        let userName = data["user"]["username"].stringValue
                        let userImageURL = data["user"]["profile_picture"].stringValue
                        let publishTime = data["created_time"].stringValue
                        let mainImageURL = data["images"]["standard_resolution"]["url"].stringValue
                        self.posts.append(InstagramPost(userName: userName, publishTime: publishTime, mainImageURL: mainImageURL, userImageURL: userImageURL))
                    }
                    
                }
            }
            completion()
        }
        
    }
    
    //---------------------------------------------------
    func downloadSearchPostDatas(searchText : String ,completion : DownloadComplete) ->Bool {
        let SEARCH_POST_URL = "https://api.instagram.com/v1/tags/\(searchText)/media/recent?access_token=\(ACCES_TOKEN)"
        if let url = NSURL(string: SEARCH_POST_URL) {
            Alamofire.request(.GET, url).responseJSON { response in
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    if let datas = json["data"].array {
                        for data in datas {
                            
                            let userName = data["user"]["username"].stringValue
                            let userImageURL = data["user"]["profile_picture"].stringValue
                            let publishTime = data["created_time"].stringValue
                            let mainImageURL = data["images"]["standard_resolution"]["url"].stringValue
                            self.searchPosts.append(InstagramPost(userName: userName, publishTime: publishTime, mainImageURL: mainImageURL, userImageURL: userImageURL))
                        }
                        
                    }
                }
                
                
                completion()
            }
        }else {
            
            return false
        }
        
        
        return true
        
    }
    
    //---------------------------------------------------
    func downloadPaginationDatas(completion : DownloadComplete) {
        let url = NSURL(string: nextURL)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            if let value = response.result.value {
                
                let json = JSON(value)
                self.nextURL = json["pagination"]["next_url"].stringValue
                if let datas = json["data"].array {
                    for data in datas {
                        
                        let userName = data["user"]["username"].stringValue
                        let userImageURL = data["user"]["profile_picture"].stringValue
                        let publishTime = data["created_time"].stringValue
                        let mainImageURL = data["images"]["standard_resolution"]["url"].stringValue
                        self.posts.append(InstagramPost(userName: userName, publishTime: publishTime, mainImageURL: mainImageURL, userImageURL: userImageURL))
                    }
                    
                }
            }
            completion()
        }
        
        
    }
    
    
    
}