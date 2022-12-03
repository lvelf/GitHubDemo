//
//  EditViewController.swift
//  GitHubDemo
//
//  Created by 诺诺诺诺诺 on 2022/12/3.
//

import UIKit



class EditViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //show datas
    
    
    
    var tableView: UITableView = {
        let table = UITableView()
        table.register(MyTableCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        //getAllItems()
    }
    
    func configView() {
        //basical configuration
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        
        title = "Edit My Work"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Complete", style: .plain, target: self, action: #selector(dismissSelf))
        
        //choose
        tableView.allowsMultipleSelection = true
        
    }
    
    
}

extension EditViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ViewController.shared.nodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableCell
        cell.imageView?.image = UIImage(systemName: ViewController.shared.nodes[indexPath.row].imageName)
        cell.imageName = ViewController.shared.nodes[indexPath.row].imageName
        cell.textLabel?.text = ViewController.shared.nodes[indexPath.row].title
        cell.title = cell.textLabel?.text
        var flag = 0
        for model in ViewController.shared.models {
            if model.title == cell.textLabel?.text {
                flag = 1
            }
        }
        if flag == 1 {
            cell.choosed = true
            cell.accessoryType = .checkmark
        }
        else {
            cell.choosed = false
            cell.accessoryType = .none
        }
        return cell
    }
    
}

extension EditViewController {
    
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = self.tableView.cellForRow(at: indexPath) as! MyTableCell
        
        if cell.choosed == false {
            cell.accessoryType = .checkmark
            cell.choosed = true
            //print(cell.title)
            print("ww")
            
            ViewController.shared.createItem(name: cell.title, imageName: cell.imageName)
        }
        else {
            cell.choosed = false
            cell.accessoryType = .none
            
            for item in ViewController.shared.models {
                if item.title == cell.title {
                    print("aa")
                    ViewController.shared.deleteItem(item: item)
                    break
                }
            }
        }
    }
}


extension EditViewController {
    
}

class MyTableCell: UITableViewCell {
    var title: String!
    var imageName: String!
    var choosed = false
}
