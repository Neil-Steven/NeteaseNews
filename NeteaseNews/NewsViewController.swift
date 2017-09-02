//
//  NewsViewController.swift
//  NeteaseNews
//
//  Created by Neil Steven on 2017/8/20.
//  Copyright © 2017年 Neil Steven. All rights reserved.
//

import UIKit
import MJRefresh
import AFNetworking
import SVProgressHUD

class NewsViewController: UITableViewController {

    // 定义一个变量
    private var _pageIndex = 0
    var pageIndex: Int {
        get {
            return _pageIndex
        }
        set {
            if newValue < 0 {
                _pageIndex = 0
            } else {
                _pageIndex = newValue
            }
        }
    }

    var adsArray = Array<Dictionary<String, String>>()
    var listArray = Array<Dictionary<String, Any>>()
    
    @IBOutlet weak var headerView: HeaderView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func initTableView() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.pageIndex = 0
            self.loadNews()
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.pageIndex += 1
            self.loadNews()
        })
        
        tableView.mj_header.beginRefreshing()
    }
    
    
    
    
    func loadNews() {
        let url = String(format: "http://c.m.163.com/nc/article/headline/T1348647853363/%d-20.html", pageIndex*20)
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.get(url, parameters: nil, progress: nil, success: { (_, responseObject) in
            
            if (self.pageIndex == 0) {
                self.tableView.mj_header.endRefreshing()
                self.listArray.removeAll()      // 移除所有历史数据
            } else {
                self.tableView.mj_footer.endRefreshing()
            }
            
            // json解析新数据
            let resultDic = try? JSONSerialization.jsonObject(with: responseObject as! Data, options: .mutableLeaves) as! Dictionary<String, Array<Dictionary<String, Any>>>

            if let dataArray = resultDic?["T1348647853363"] {
                self.listArray.append(contentsOf: (dataArray.prefix(upTo: dataArray.count - 1)))
                if (self.pageIndex == 0) {
                    self.adsArray = dataArray[0]["ads"] as! Array<Dictionary<String, String>>
                    self.headerView.config(adsArray: self.adsArray)
                }
            }
            
            self.tableView.reloadData()
            
        }) { (_, error) in
            self.pageIndex -= 1
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            SVProgressHUD.showError(withStatus: "获取新闻列表失败！")
            SVProgressHUD.dismiss(withDelay: 1)
        }
    }
    
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        
        cell.configCellWith(data: listArray[indexPath.row])

        return cell
    }
    

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listArray.count == 0 {
            return
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Scroll view delegate
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 1 {
            UIView.animate(withDuration: 0.5, animations: { 
                self.navigationController?.navigationBar.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: { 
                self.navigationController?.navigationBar.alpha = 1
            })
        }
    }
    
    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.5) { 
            self.navigationController?.navigationBar.alpha = 1
        }
    }

    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            if let newsCell = sender as? NewsCell {
                let detailVC = segue.destination as! DetailViewController
                detailVC.title = newsCell.titleLabel.text!
                detailVC.urlString = newsCell.urlString
            }
        }
    }
    
}
