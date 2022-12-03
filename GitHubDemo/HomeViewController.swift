

import UIKit
import SafariServices

struct SFSymbolItem: Hashable {
    let name: String
    let image: UIImage
    
    init(name: String, imageName: String) {
        self.name = name
        self.image = UIImage(systemName: imageName)!
    }
}

struct HeaderItem: Hashable {
    let title: String
    var symbols: [SFSymbolItem]
}


class HomeViewController: UIViewController,UICollectionViewDelegate {
    
    let window = UIApplication.shared.windows.filter{ $0.isKeyWindow }.first
    
    //datas
    var modelObjects = [HeaderItem(title: "Work", symbols:
                                    []),
                       HeaderItem(title: "Star", symbols: [SFSymbolItem(name: "sun", imageName: "sun.min"),
                                                          SFSymbolItem(name: "sunset", imageName: "sunset.fill")]),
                       HeaderItem(title: "FastWay", symbols: [SFSymbolItem(name: "sad", imageName: "pencil"),SFSymbolItem(name: "pc", imageName: "pc")]),
                       HeaderItem(title: "Latest", symbols: [SFSymbolItem(name: "happy", imageName: "figure.walk"),SFSymbolItem(name: "pc", imageName: "figure.wave")])
    ]
    
    
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<HeaderItem, SFSymbolItem>!
    var ellipsisButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "ellipsis")
        button.setImage(image, for: .normal)
        button.backgroundColor = .systemGray6
       
            
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        configCell()
        configHeader()
        configSnapshot()
        configEditButton()
        
    }
    
    private func configView() {
        //list layout configuration
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.headerMode = .supplementary
        layoutConfig.footerMode = .supplementary
        
        //layoutway
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        //config collectionView
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        view.addSubview(collectionView)
        collectionView.delegate = self
        
    }
    
    
}


//config datas
extension HomeViewController {
    private func configCell() {
        //cell registration
        
        let symbolCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SFSymbolItem> {
            (cell, indexPath, symbolItem) in
            
            //config content
            var configuration = cell.defaultContentConfiguration()
            configuration.image = symbolItem.image
            configuration.text = symbolItem.name
            cell.contentConfiguration = configuration
        }
        
        //initialize data source
        dataSource = UICollectionViewDiffableDataSource<HeaderItem, SFSymbolItem>(collectionView: collectionView){
            (collectionView, indexPath, symbolItem) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: symbolCellRegistration, for: indexPath, item: symbolItem)
            
            return cell
        }
    }
    
    private func configHeader() {
        //perform supplementary view registration
        //UiCollectionViewCell is supplementary view subclass
        //UICollectionViewListCell usage is not only limited to cell creation, it can be used as a subclass of header and footer view as well.
        

        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) {
            [unowned self] (headerView, elementKind, indexPath) in
            
            //obtain header item through indexPath
            let headerItem = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            //config header view content
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = headerItem.title
            
            //customize header appearence
            configuration.textProperties.font = .boldSystemFont(ofSize: 20)
            configuration.textProperties.color = .black
            configuration.directionalLayoutMargins = .init(top: 10.0, leading: 5.0, bottom: 10.0, trailing: 0.0)
            
            var rect: CGRect!
            //config button
            if indexPath.section == 0 {
                 rect = headerView.convert(CGRect(x: headerView.frame.minX,y: 25.0,width: 10,height: 20), to: window)
                
                ellipsisButton.frame = CGRect(x: 350, y: rect.minY - 3, width: rect.height, height: rect.height)
                //print(rect)
            }
            if indexPath.section == 1 {
                 rect = headerView.convert(CGRect(x: headerView.frame.minX,y: 45.0,width: 10.0,height: 10.0), to: window)
                //print(rect)

            }
            
            
            
            //apply configuration
            headerView.contentConfiguration = configuration
        }
        
        //footer registration
        
        let footerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionFooter) {
                [unowned self] (footerView, elementKind, indexPath) in
            
//            let headerItem = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            //let symbolCount = headerItem.symbols.count
            
            //config footer view
            //var configuration = footerView.defaultContentConfiguration()
            //configuration.text = "Symbol Count: \(symbolCount)"
            //footerView.contentConfiguration = configuration
        }
        
        //define supplementary view provider
        
        dataSource.supplementaryViewProvider = { [unowned self]
            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            
            if elementKind == UICollectionView.elementKindSectionHeader {
                
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
                
            } else {
                
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
            }
        }
    }
    
    private func configSnapshot() {
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<HeaderItem, SFSymbolItem>()
        
        //append sections
        dataSourceSnapshot.appendSections(modelObjects)
        
        for headerItem in modelObjects {
            dataSourceSnapshot.appendItems(headerItem.symbols,toSection: headerItem)
        }
        
        dataSource.apply(dataSourceSnapshot, animatingDifferences:  false)
    }
    
    private func configEditButton() {
        ellipsisButton.addTarget(ViewController.shared, action: #selector(ViewController.shared.TapEditButton), for: .touchUpInside)
        view.addSubview(ellipsisButton)
    }
    
    
    
}

//point

extension HomeViewController {
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        print(modelObjects[indexPath.section].symbols[indexPath.row].name)
        
        switch(modelObjects[indexPath.section].symbols[indexPath.row].name) {
        case "Meeting":
            print("hh")
            configWeb(url: "https://github.com/issues")
        default:
            print("ee")
        }
        
    }
    
    func configWeb(url: String) {
        guard let webURL = URL(string: url) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: webURL)
        
        present(safariVC, animated: true, completion:  nil)
    }
    
    
}

extension HomeViewController {
    
    public func configModels() {
        
        print("hhhh")
        self.modelObjects[0].symbols = []
        for item in ViewController.shared.models {
            self.modelObjects[0].symbols.append(SFSymbolItem(name: item.title!, imageName: item.imageName!))
        }
        
        print(self.modelObjects[0].symbols.count)
        
        configSnapshot()
    }
}




