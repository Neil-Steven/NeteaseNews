//
//  DetailViewController.swift
//  NeteaseNews
//
//  Created by Neil Steven on 2017/8/20.
//  Copyright © 2017年 Neil Steven. All rights reserved.
//

import UIKit
import SVProgressHUD

class DetailViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var urlString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        
        // 无论在新闻视图中是否显示导航栏，详情页面总是显示的
        navigationController?.navigationBar.alpha = 1
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (_, _, error) in
                if error == nil {
                    SVProgressHUD.show(withStatus: "正在加载中")
                    SVProgressHUD.dismiss(withDelay: 5)
                    self.webView.loadRequest(request)
                } else {
                    SVProgressHUD.show(withStatus: "连接错误")
                    SVProgressHUD.dismiss(withDelay: 2)
                }
            }
            task.resume()
        }
        else {
            SVProgressHUD.show(withStatus: "新闻地址错误")
            SVProgressHUD.dismiss(withDelay: 2)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Web view delegate
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.show(withStatus: "加载失败")
        SVProgressHUD.dismiss(withDelay: 1.5)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
