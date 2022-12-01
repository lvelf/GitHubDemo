//
//  ExploreViewController.swift
//  GitHubDemo
//
//  Created by 诺诺诺诺诺 on 2022/12/1.
//

import UIKit
import SafariServices

class ExploreViewController: UIViewController {
    
    
    private var DidPushWeb:Bool = false
    private var IntoTimes: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
    }
    
    func configExploreWeb() {
        guard let exploreURL = URL(string: "https://github.com/explore") else {
            return
        }
        
        let safariVC = SFSafariViewController(url: exploreURL)
        
        present(safariVC, animated: true, completion:  nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if(!DidPushWeb) {
            configExploreWeb()
            DidPushWeb = true
        }
        
        IntoTimes += 1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        //只有退出了两次之后才能被重新拉起web页面
        if IntoTimes == 2 {
            DidPushWeb = false
            IntoTimes = 0
        }
    }
    
    
}

