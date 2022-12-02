//
//  ViewController.swift
//  GitHubDemo
//
//  Created by 诺诺诺诺诺 on 2022/12/1.
//

import UIKit
import SafariServices

class ViewController: UITabBarController {
    
    //homeViewController and Navigation
    var homeController: HomeViewController = {
        let home = HomeViewController()
        return home
    }()
    var homeNav: UINavigationController!
    
    //messageController
    
    var messageController: MessageViewController = {
        let message = MessageViewController()
        return message
    }()
    
    //exploreController
    var exploreController: ExploreViewController = {
        let explore = ExploreViewController()
        return explore
    }()
    
    //personalController
    var personalController: PersonalViewController = {
        let personal = PersonalViewController()
        return personal
    }()
    var personalNav: UINavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //config views
        configHomeView()
        messageController.title = "Message"
        exploreController.title = "Explore"
        configPersonalView()
        //personalController.title = "Personal data"
        
        
        //config tabbar
        
        self.setViewControllers([homeNav, messageController, exploreController, personalNav], animated: false)
        
        guard let items = self.tabBar.items else {
            return
        }
        
        let images = ["house", "message", "cloud","person"]
        
        self.tabBar.backgroundColor = .white
        
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: images[i])
        }
    }
    
    private func configHomeView(){
        
        homeNav = UINavigationController(rootViewController: homeController)
        homeNav.navigationBar.backgroundColor = .systemGray6
        
        //config something
        homeController.title = "Home"
        
        //searchbar
        let searchController = UISearchController(searchResultsController: nil)
        homeController.navigationItem.searchController = searchController
        let plusItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(didTapAddButton))
        homeController.navigationItem.rightBarButtonItem = plusItem
    }
    
    private func configPersonalView() {
        personalNav = UINavigationController(rootViewController: personalController)
        personalNav.navigationBar.backgroundColor = .systemGray6
        //personalController.navigationController?.navigationBar.backgroundColor = .white
        personalNav.title = "Personal data"
        
        
        
        let actionItem = UIBarButtonItem(systemItem: .action, primaryAction: nil, menu: nil)
        personalController.navigationItem.rightBarButtonItems = [actionItem, editButtonItem]
        
    }
    
}

extension ViewController {
    
    //HomeViewController
    
    @objc func didTapAddButton() {
        configWeb(url: "https://github.com/issues")
    }
}

extension ViewController {
    func configWeb(url: String) {
        guard let webURL = URL(string: url) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: webURL)
        
        present(safariVC, animated: true, completion:  nil)
    }
}

