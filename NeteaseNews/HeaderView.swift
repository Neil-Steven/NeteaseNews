//
//  HeaderView.swift
//  NeteaseNews
//
//  Created by Neil Steven on 2017/8/20.
//  Copyright © 2017年 Neil Steven. All rights reserved.
//

import UIKit
import SDWebImage

class HeaderView: UIView, UIScrollViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var adsArray = Array<Dictionary<String, String>>()
    
    var timer : Timer?
    
    
    
    func config(adsArray: Array<Dictionary<String, String>>) {
        self.adsArray = adsArray
        if adsArray.count == 0 {
            return
        }
        
        titleLabel.text = self.adsArray[0]["title"]

        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: frame.size.width * CGFloat(adsArray.count + 2) , height: frame.size.height)
        scrollView.setContentOffset(CGPoint(x: frame.size.width, y: 0), animated: true)
        
        pageControl.numberOfPages = adsArray.count
        pageControl.currentPage = 0
        
        for i in -1 ..< adsArray.count + 1 {
            var index = i
            if i == -1 { index = adsArray.count - 1 }      // scrollView的第一张图是dataArray的最后一张图
            else if i == adsArray.count { index = 0 }      // scrollView的最后一张图是dataArray的第一张图
            
            let contentImageView = UIImageView(frame: CGRect(x: frame.size.width * CGFloat(i + 1), y: 0, width: frame.size.width, height: frame.size.height))
            let url = URL(string: adsArray[index]["imgsrc"]!)
            contentImageView.sd_setImage(with: url)
            scrollView.addSubview(contentImageView)
        }
        
        startScroll()
    }
    

    func startScroll() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(changeOffset), userInfo: nil, repeats: true)
    }
    
    
    @objc func changeOffset() {
        let currentPage = scrollView.contentOffset.x / frame.size.width
        let rect = CGRect(x: (currentPage+1)*frame.size.width, y: 0, width: frame.size.width, height: frame.size.height)
        scrollView.scrollRectToVisible(rect, animated: true)
    }
    
    
    // MARK: - Scroll view delegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startScroll()
    }
    
    var newX : CGFloat = CGFloat()
    var oldX : CGFloat = CGFloat()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = Float(scrollView.contentOffset.x / frame.size.width)
        let page: Int = lroundf(offset)     // 四舍五入算出目前处在第几页
        
        // 如果滑动到了倒数第1页（也就是过渡的第一条新闻）
        if page == adsArray.count + 1 {
            pageControl.currentPage = 0
            // 如果正好滑动到了第1页，则直接跳到第2页（即第一条新闻），人眼不会察觉
            if offset == Float(adsArray.count + 1) {
                scrollView.setContentOffset(CGPoint(x: frame.size.width, y: 0), animated: false)
            }
        }
        // 如果滑动到了第1页（也就是过渡的最后一条新闻）
        else if page == 0 {
            pageControl.currentPage = adsArray.count
            // 如果正好滑动到了第1页，则直接跳到倒数第2页（即最后一条新闻），人眼不会察觉
            if offset == 0 {
                scrollView.setContentOffset(CGPoint(x: frame.size.width * CGFloat(adsArray.count), y: 0), animated: false)
            }
        }
        // 一般情况下，通过四舍五入的方式计算滑动到第几页
        else {
            pageControl.currentPage = page - 1
        }

        // 改变标题Label
        titleLabel.text = adsArray[pageControl.currentPage]["title"]
    }
}
