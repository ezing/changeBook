//
//  HomeViewController.swift
//  changeBook
//
//  Created by Jvaeyhcd on 23/06/2017.
//  Copyright © 2017 Jvaeyhcd. All rights reserved.
//

import UIKit

let kHomeHeadViewHeight = kScreenWidth * (150.0 / 375.0 + 0.25) + scaleFromiPhone6Desgin(x: 30) + kBasePadding

class HomeViewController: BaseViewController, HcdTabBarDelegate, SDCycleScrollViewDelegate {
    
    // tableview的偏移量
    fileprivate var tableViewOffsetY = CGFloat(0)
    private var selectedControllerIndex = -1
    private var canotScrollIndex = -1
    private var viewControllers = [BaseTableViewController]()
    lazy var tabBar: SlippedSegmentView = {
        
        let tabBar = SlippedSegmentView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kSegmentBarHeight))
        tabBar.backgroundColor = UIColor.white
        tabBar.showSelectedBgView(show: false)
        return tabBar
        
    }()
    
    lazy var controllersScrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.backgroundColor = kMainBgColor
        return scrollView
    }()
    
    private var contentViewFrame: CGRect?
    private var contentSwitchAnimated = true
    
    lazy var headView: HomeHeadView = {
        let headView = HomeHeadView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kHomeHeadViewHeight))
        return headView
    }()
    
    private var viewModel: OtherViewModel = OtherViewModel()
    private var bannerList: [Banner] = [Banner]()

    override func viewDidLoad() {
        super.viewDidLoad()

        initSubviews()
        getBanner()
    }
    
    private func initSubviews() {
        
        self.title = "首页"
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tabBar.delegate = self
        self.view.addSubview(self.tabBar)
        
        setupFrameOfTabBarAndContentView()
        
        self.controllersScrollView.delegate = self.tabBar
        self.view.insertSubview(self.controllersScrollView, belowSubview: self.tabBar)
        
        let vc1 = HotDataListViewController()
        vc1.selectedDocumentBlock = {
            [weak self] (document) in
            let vc = DataDetailViewController()
            vc.document = document
            vc.hidesBottomBarWhenPushed = true
            self?.pushViewController(viewContoller: vc, animated: true)
        }
        vc1.parentVC = self
        vc1.title = "热门资料"
        
        let vc2 = HotArticleListViewController()
        vc2.parentVC = self
        vc2.title = "热门文章"
        
        setTabBarFrame(tabBarFrame: CGRect(x: 0, y: kHomeHeadViewHeight, width: kScreenWidth, height: kSegmentBarHeight), contentViewFrame: CGRect(x: 0, y: kSegmentBarHeight, width: kScreenWidth, height: kScreenHeight - kSegmentBarHeight - kTabBarHeight - kNavHeight))
        self.tabBar.setItemWidth(itemWidth: kScreenWidth / 2)
        self.tabBar.setFramePadding(top: 0, left: 0, bottom: 0, right: 0)
        self.tabBar.setItemHorizontalPadding(itemHorizontalPadding: 50)
        self.tabBar.setItemSelectedBgInsets(itemSelectedBgInsets: UIEdgeInsetsMake(kSegmentBarHeight - 2, 50, 0, 50))
        self.tabBar.showSelectedBgView(show: true)
        self.tabBar.setItemTitleSelectedFont(itemTitleSelectedFont: kBaseFont)
        self.tabBar.setItemTitleFont(itemTitleFont: kBaseFont)
        self.tabBar.setItemTitleColor(itemTitleColor: UIColor(hex: 0x555555)!)
        self.tabBar.setItemTitleSelectedColor(itemTitleSelectedColor: kMainColor!)
        self.tabBar.setItemSelectedBgImageViewColor(itemSelectedBgImageViewColor: kMainColor!)
        
        setViewControllers(viewControllers: [vc1, vc2])
        
        self.headView.cycleScrollView.delegate = self
        self.view.addSubview(self.headView)
        self.showBarButtonItem(position: RIGHT, withImage: UIImage(named: "home_btn_shubao")!)
        self.showBarButtonItem(position: LEFT, withImage: UIImage(named: "home_btn_saoyisao")!)
        
        self.headView.selectCollectionIndex = {
            [weak self] (index) in
            switch index {
            case 0:
                let vc = BorrowBookViewController()
                vc.hidesBottomBarWhenPushed = true
                self?.pushViewController(viewContoller: vc, animated: true)
                break
            case 1:
                let vc = FilterDataViewController()
                vc.hidesBottomBarWhenPushed = true
                self?.pushViewController(viewContoller: vc, animated: true)
                break
            case 2:
                
                break
            case 3:
                
                break
            default:
                break
            }
        }
    }
    
    private func updateContentViewsFrame() {
        self.controllersScrollView.frame = self.contentViewFrame!
        
        self.controllersScrollView.contentSize = CGSize.init(width: self.contentViewFrame!.size.width * CGFloat(self.viewControllers.count), height: self.contentViewFrame!.size.height)
        
        var index = 0
        
        self.viewControllers.forEach{ controller in
            
            if controller.isViewLoaded {
                
                controller.view.frame = CGRect.init(x: CGFloat(index) * self.contentViewFrame!.size.width, y: 0, width: self.contentViewFrame!.size.width, height: self.contentViewFrame!.size.height)
            }
            
            index = index + 1
        }
        
        if nil != selectedController() {
            self.controllersScrollView.scrollRectToVisible(selectedController()!.view.frame, animated: false)
        }
    }
    
    private func selectedController() -> UIViewController? {
        if self.selectedControllerIndex >= 0 {
            return self.viewControllers[self.selectedControllerIndex]
        }
        return nil
    }
    
    private func setupFrameOfTabBarAndContentView() {
        // 设置默认的tabBar的frame和contentViewFrame
        let screenSize = UIScreen.main.bounds.size
        
        let contentViewY = kSegmentBarHeight
        let tabBarY = CGFloat(0)
        var contentViewHeight = screenSize.height - kSegmentBarHeight
        
        // 如果parentViewController为UINavigationController及其子类
        
        if nil != self.parent
            && (self.parent?.isKind(of: UINavigationController.self))!
            && nil != self.navigationController
            && !self.navigationController!.isNavigationBarHidden
            && !self.navigationController!.navigationBar.isHidden {
            let navMaxY = self.navigationController!.navigationBar.frame.maxY
            if !self.navigationController!.navigationBar.isTranslucent
                || self.edgesForExtendedLayout == .none
                || self.edgesForExtendedLayout == .top {
                contentViewHeight = screenSize.height - kSegmentBarHeight - navMaxY
            } else {
                
            }
        }
        
        self.setTabBarFrame(tabBarFrame: CGRect.init(x: 0, y: tabBarY, width: screenSize.width, height: kSegmentBarHeight),
                            contentViewFrame: CGRect.init(x: 0,
                                                          y: contentViewY,
                                                          width: screenSize.width,
                                                          height: contentViewHeight))
    }
    
    // MARK: - Setter
    
    func setSelectedControllerIndex(selectedControllerIndex: Int) {
        
        if selectedControllerIndex < 0 || selectedControllerIndex > self.viewControllers.count - 1 {
            return
        }
        
        var oldController: UIViewController?
        if self.selectedControllerIndex >= 0 {
            oldController = self.viewControllers[self.selectedControllerIndex]
        }
        let curController = self.viewControllers[selectedControllerIndex] as BaseTableViewController
        curController.tableViewOffsetY = self.tableViewOffsetY
        var isAppearFirstTime = true
        
        oldController?.viewWillDisappear(false)
        if nil == curController.view.superview {
            // superview为空，表示为第一次加载，设置frame，并添加到scrollView
            curController.view.frame = CGRect.init(x: CGFloat(selectedControllerIndex) * self.controllersScrollView.frame.size.width, y: 0, width: self.controllersScrollView.frame.size.width, height: self.controllersScrollView.frame.size.height)
            self.controllersScrollView.addSubview(curController.view)
        } else {
            // superview不为空，表示为已经加载过了，调用viewWillAppear方法
            isAppearFirstTime = false
            curController.viewWillAppear(false)
        }
        // 切换到curController
        self.controllersScrollView.scrollRectToVisible(curController.view.frame, animated: self.contentSwitchAnimated)
        
        // 当contentView为scrollView及其子类时，设置它支持点击状态栏回到顶部
        if nil != oldController && (oldController?.view.isKind(of: UIScrollView.self))! {
            (oldController!.view as! UIScrollView).scrollsToTop = false
        }
        if curController.view.isKind(of: UIScrollView.self) {
            (curController.view as! UIScrollView).scrollsToTop = true
        }
        
        self.selectedControllerIndex = selectedControllerIndex
        
        // 调用状态切换的回调方法
        
        oldController?.viewDidDisappear(false)
        if !isAppearFirstTime {
            curController.viewDidAppear(false)
        }
    }
    
    /**
     设置ViewControllers
     
     - parameter viewControllers: ViewController数组
     */
    func setViewControllers(viewControllers: [BaseTableViewController]) {
        
        if viewControllers.count == 0 {
            return
        }
        
        self.viewControllers.forEach { controller in
            controller.removeFromParentViewController()
            controller.view.removeFromSuperview()
        }
        
        var titles = [String]()
        var index = 0
        
        self.viewControllers = viewControllers
        self.viewControllers.forEach { controller in
            self.addChildViewController(controller)
            
            controller.tableView.addObserver(self,
                                             forKeyPath: "contentOffset",
                                             options: NSKeyValueObservingOptions.new,
                                             context: nil)
            var title = controller.title
            if nil == title || "" == title {
                title = "Item" + String(index + 1)
            }
            titles.append(title!)
            index = index + 1
        }
        
        self.tabBar.setTitles(titles: titles)
        
        self.tabBar.setSelectedItemIndex(selectedItemIndex: 0)
        
        // 更新scrollView的content size
        self.controllersScrollView.contentSize = CGSize.init(width: self.contentViewFrame!.size.width,
                                                             height: self.contentViewFrame!.size.height)
        
        updateContentViewsFrame()
    }
    
    // MARK: public function
    
    /**
     设置ViewController的Content Frame
     
     - parameter contentViewFrame: viewController的ScrollView的Frame
     */
    func setContentViewFrame(contentViewFrame: CGRect) {
        self.contentViewFrame = contentViewFrame
        updateContentViewsFrame()
    }
    
    /**
     设置TabBar的Frame和ContentView的Frame
     
     - parameter tabBarFrame:      tabBar的Frame
     - parameter contentViewFrame: ContentView的Frame
     */
    func setTabBarFrame(tabBarFrame: CGRect, contentViewFrame: CGRect) {
        
        self.tabBar.updateFrame(frame: tabBarFrame)
        setContentViewFrame(contentViewFrame: contentViewFrame)
    }
    
    // MARK: - HcdTabBarDelegate
    func tabBar(tabBar: SlippedSegmentView, didSelectedItemAtIndex: Int) {
        if didSelectedItemAtIndex == self.selectedControllerIndex {
            return
        }
        if didSelectedItemAtIndex == self.canotScrollIndex {
            self.controllersScrollView.isScrollEnabled = false
        } else {
            self.controllersScrollView.isScrollEnabled = true
        }
        
        self.setSelectedControllerIndex(selectedControllerIndex: didSelectedItemAtIndex)
    }
    
    func tabBar(tabBar: SlippedSegmentView, willSelectItemAtIndex: Int) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func leftNavBarButtonClicked() {
        let vc = ScanViewController()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(viewContoller: vc, animated: true)
    }
    
    override func rightNavBarButtonClicked() {
        let vc = BagViewController()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(viewContoller: vc, animated: true)
    }
    
    // MARK: - Networking
    private func getBanner() {
        self.viewModel.getBanner(cache: { [weak self] (data) in
            self?.bannerList = Banner.fromJSONArray(json: data.arrayObject!)
            self?.updateBannerDatas()
        }, success: { [weak self] (data) in
            self?.bannerList = Banner.fromJSONArray(json: data.arrayObject!)
            self?.updateBannerDatas()
        }, fail: { [weak self] (message) in
            self?.showHudTipStr(message)
        }) { 
            
        }
    }
    
    private func updateBannerDatas() {
        
        var urls = [String]()
        
        for banner in self.bannerList {
            urls.append(banner.cover)
        }
        
        self.headView.cycleScrollView.imageURLStringsGroup = urls
        
    }
    
    // MARK : - SDCycleScrollViewDelegate
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {
        
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

extension HomeViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let tableView = object as! UITableView
        
        if keyPath != "contentOffset" {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        let tableViewoffsetY = tableView.contentOffset.y
        
        BLog(log: "tableViewoffsetY=\(tableViewoffsetY)")
        
        if ( tableViewoffsetY>=0 && tableViewoffsetY<=kHomeHeadViewHeight) {
            
            self.tabBar.frame = CGRect(x: 0, y: kHomeHeadViewHeight-tableViewoffsetY, width: kScreenWidth, height: kSegmentBarHeight)
            self.headView.frame = CGRect(x: 0, y: 0-tableViewoffsetY, width: kScreenWidth, height: kHomeHeadViewHeight)
            self.tableViewOffsetY = tableViewoffsetY
            
        } else if( tableViewoffsetY < 0){
            
            self.tabBar.frame = CGRect(x: 0, y: kHomeHeadViewHeight, width: kScreenWidth, height: kSegmentBarHeight)
            self.headView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kHomeHeadViewHeight)
            self.tableViewOffsetY = CGFloat(0)
            
        } else if (tableViewoffsetY > kHomeHeadViewHeight) {
            
            self.tabBar.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kSegmentBarHeight)
            self.headView.frame = CGRect(x: 0,
                                          y: -kHomeHeadViewHeight,
                                          width: kScreenWidth,
                                          height: kHomeHeadViewHeight)
            self.tableViewOffsetY = kHomeHeadViewHeight
            
        }
    }
}
