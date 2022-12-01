

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
    let symbols: [SFSymbolItem]
}


class HomeViewController: UIViewController,UICollectionViewDelegate {
    
    //datas
    let modelObjects = [HeaderItem(title: "Work", symbols:
                                    [SFSymbolItem(name: "Meeting", imageName: "target"),SFSymbolItem(name: "pc", imageName: "pc")]),
                       HeaderItem(title: "Star", symbols: [SFSymbolItem(name: "sun", imageName: "sun.min"),
                                                          SFSymbolItem(name: "sunset", imageName: "sunset.fill")]),
                       HeaderItem(title: "FastWay", symbols: []),
                       HeaderItem(title: "Latest", symbols: [])
    ]
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<HeaderItem, SFSymbolItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        configCell()
        configHeader()
        configSnapshot()
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
}

//point

extension HomeViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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


