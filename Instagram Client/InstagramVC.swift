//
//  InstagramViewController.swift
//  Instagram Client
//
//  Created by yusuf_kildan on 04/05/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import UIKit
import PureLayout
import Kingfisher

class InstagramVC: UIViewController ,UITableViewDataSource ,UITableViewDelegate ,UISearchBarDelegate {
    
    var tableView  :UITableView!
    var inSearchMode = false
    var searchController : UISearchController!
    var refreshContol : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(InstagramVC.refreshData))
        navigationItem.leftBarButtonItem = refreshButton
        self.navigationItem.title = "INSTAGRAM"
        self.navigationItem.leftBarButtonItem = refreshButton
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
        tableView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0)
        tableView.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        tableView.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        tableView.registerClass(InstagramTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter a hastag without #"
        searchController.searchBar.backgroundColor =  UIColor(red: 24/255.0, green: 88/255.0, blue: 135/255.0, alpha: 1.0)
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        
        refreshContol = UIRefreshControl()
        refreshContol.attributedTitle = NSAttributedString(string: "Updating!")
        refreshContol.addTarget(self, action: #selector(InstagramVC.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshContol, atIndex: 0)
        
        INSTANCE.downloadLastPostDatas {
            print("Downloaded")
            self.tableView.reloadData()
        }
    }
    
    func refreshData() {
        KingfisherManager.sharedManager.cache.clearMemoryCache()
        KingfisherManager.sharedManager.cache.clearDiskCache()
        INSTANCE.searchPosts = []
        INSTANCE.posts = []
        
        if inSearchMode {
            
            INSTANCE.downloadSearchPostDatas(SEARCH_TEXT, completion: {
                self.tableView.reloadData()
                self.refreshContol.endRefreshing()
            })
        }else {
            
            INSTANCE.downloadLastPostDatas({
                self.tableView.reloadData()
                self.refreshContol.endRefreshing()
            })
            
        }
        self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
    }
    
   
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let photosDetailsVC = PhotoDetailVC()
        var url : NSURL!
        if inSearchMode && INSTANCE.searchPosts.count > 0 {
            url = NSURL(string : INSTANCE.searchPosts[indexPath.row].mainImageURL)
        }else if inSearchMode == false && INSTANCE.posts.count > 0{
            url = NSURL(string : INSTANCE.posts[indexPath.row].mainImageURL)
        }
        photosDetailsVC.imageURL = url
        self.navigationController?.pushViewController(photosDetailsVC, animated: true)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? InstagramTableViewCell {
            
            if inSearchMode  && INSTANCE.searchPosts.count > 0 {
                cell.configureCell(INSTANCE.searchPosts[indexPath.row])
            }else if INSTANCE.posts.count > 0{
                cell.configureCell(INSTANCE.posts[indexPath.row])
            }
            
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            
            return cell
        }else {
            
            return InstagramTableViewCell()
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            return INSTANCE.searchPosts.count
        }
        return INSTANCE.posts.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 350.0
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == INSTANCE.posts.count - 4 {
            ApiManager.Instance.downloadPaginationDatas({
                tableView.reloadData()
            })
            
        }
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        inSearchMode = false
        
        INSTANCE.searchPosts = []
        INSTANCE.posts = []
        INSTANCE.downloadLastPostDatas {
            self.refreshData()
        }
        
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        inSearchMode = true
        if let searchText = searchBar.text {
            SEARCH_TEXT=searchText
            INSTANCE.searchPosts = []
            INSTANCE.posts = []
            if INSTANCE.downloadSearchPostDatas(searchText, completion: {self.tableView.reloadData()}) {
                tableView.reloadData()
            }else {
                YKEasyAlertController.alert("Error", message: "Please enter VALID search keyword!")
            }
        }
    }
    
    
    
    
}
