//
//  PersonalViewController.swift
//  GitHubDemo
//
//  Created by 诺诺诺诺诺 on 2022/12/1.
//

import UIKit
import SafariServices

enum Section: Int,CaseIterable {
    case portrait
    case grid
    case single
    var ColumnHeight: Int {
        switch self {
        case .portrait:
            return 120
        case .grid:
            return 60
        case .single:
            return 120
        }
    }
}


class PersonalViewController: UIViewController,UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>
    
    private var dataSource: DataSource!
    
    private var datas: [[String]] = [["lvelf"],["WareHouese","Star","Organization"],["JumpGame"]]
    private var imagedatas: [[String]] = [["figure.roll"],["mic.fill","sun.min","pencil","pencil.and.outline"],["sunset.fill","sunset.fill"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        configBasicalData()
        configHeaderView()
    }
    
    private func configView() {
        
        //basical configuration
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        view.backgroundColor = .systemGray6
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        
        view.addSubview(collectionView)
        
        //register
        
        collectionView.register(LabelCell.self
                                , forCellWithReuseIdentifier: "LabelCell")
        
        collectionView.register(HeaderView.self
                                , forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "HeaderView")
        
        //basical
        
        collectionView.backgroundColor = .systemGray6
        collectionView.layer.cornerRadius = 5
        collectionView.layer.masksToBounds = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configBasicalData() {
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell"
                                                                , for: indexPath) as? LabelCell
            else {
                fatalError()
            }
            
            
            
            if indexPath.section == 0 {
                cell.backgroundColor = .systemGray6
                cell.textLabelFrameValue(frame: CGRect(x: 80, y: 40, width: 50, height: 30))
                cell.textLabel.font = UIFont(name: "AvenirNext-Bold", size: 18)
                print("byd")
            } else if indexPath.section == 2{
                cell.backgroundColor = .white
                cell.textLabelFrameValue(frame: CGRect(x: 10, y: 25, width:100, height: 60))
                cell.textLabel.font = UIFont(name: "AvenirNext-Bold", size: 15)
            } else {
                cell.backgroundColor = .white
                cell.textLabelContraints()
                cell.textLabel.font = UIFont(name: "AvenirNext-Bold", size: 15)
            }
            
            //text
            
            //cell.textLabel.textColor = indexPath.section == 0 ? .systemGray4 : .systemBlue
            cell.textLabel.textColor = .black
            cell.textLabel.text = self.datas[indexPath.section][indexPath.row]
            
            cell.contentView.layer.cornerRadius = 10;

            cell.layer.cornerRadius = 10;
            
            switch(indexPath.section) {
            case 0:
                cell.configImage(addImage: UIImage(systemName: self.imagedatas[indexPath.section][indexPath.row])!,
                                 frame: CGRect(x: 20, y: 20, width: 60, height: 60))
            case 1:
                cell.configImage(addImage: UIImage(systemName: self.imagedatas[indexPath.section][indexPath.row])!,
                                 frame: CGRect(x: 15, y: 13, width: 20, height: 20))
                    
            case 2:
                cell.configImage(addImage: UIImage(systemName: self.imagedatas[0][0])!,
                                 frame: CGRect(x: 10, y: 10, width: 30, height: 30))
                cell.configNameLabel(frame: CGRect(x: 45, y: 10, width: 60, height: 30))
            default:
                print("hh")
            }
            
            
            return cell
        })
        
        //snapshot for database
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        
        snapshot.appendSections([.portrait,.grid,.single])
        
        snapshot.appendItems([0], toSection: .portrait)
        snapshot.appendItems(Array(1...datas[1].count), toSection: .grid)
        snapshot.appendItems(Array(datas[1].count + 1...datas[1].count + datas[2].count),toSection: .single)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configHeaderView() {
        
        dataSource.supplementaryViewProvider = {
            (collectionView, kind, indexPath) in
                
            guard let headerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else {
                    fatalError()
            }
                print("haha")
                headerView.textLabel.text = indexPath.section == 0 ? "" : "fixed"
                headerView.textLabel.font = UIFont(name: "AvenirNext-Bold", size: 15)
                headerView.textLabel.textColor = .systemGray2
                
               // headerView.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
                return headerView
        }
    }
    
        
    
    
}

extension PersonalViewController {
    // layout Way
    
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionType = Section(rawValue: sectionIndex) else {
                return nil
            }
            
            if sectionType == .grid {
                let layoutConfig = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
                return .list(using: layoutConfig, layoutEnvironment: layoutEnvironment)
            }
            
            let height = sectionType.ColumnHeight
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 15, trailing: 5)
            
            let groupWidth = NSCollectionLayoutDimension.fractionalWidth(1)
            let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: .absolute(CGFloat(height)))

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            
            //section header
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(35))
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            section.boundarySupplementaryItems = [header]
            
            print(sectionType)
            
            return section
        }
        
        return layout
    }
}

extension PersonalViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if indexPath.section == 1 {
            switch(indexPath.row) {
            case 0:
                configWeb(url: "https://github.com/lvelf?tab=repositories")
            case 1:
                configWeb(url: "https://github.com/lvelf?tab=stars")
            case 2:
                configWeb(url: "https://github.com/lvelf?tab=projects")
            default:
                print("hh")
            }
        }
        else if indexPath.section == 2 {
            switch(indexPath.row) {
            case 0:
                configWeb(url: "https://github.com/lvelf/JumpGame")
            default:
                print("")
            }
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


class LabelCell: UICollectionViewCell {
    
    public var textLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        
        return label
    }()
    
    public var nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    public var image = UIImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func config() {
        textLabelContraints()
    }
    
    public func textLabelContraints() {
        textLabel.textAlignment = .center
        addSubview(textLabel)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
          //textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
          textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
          //textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
          //textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    public func configNameLabel(frame: CGRect) {
        
        
        nameLabel.frame = frame
        
        nameLabel.font = UIFont(name: "AvenirNext-Bold", size: 15)
        nameLabel.textColor = .black
        nameLabel.text = "lvelf"
        
        addSubview(nameLabel)
        print("ni zai shuo sm ")
    }
    
    public func textLabelFrameValue(frame: CGRect) {
        addSubview(textLabel)
        
        textLabel.frame = frame
        
//        textLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//          textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//          //textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//          textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
//          //textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
//          //textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
//        ])
    }
    
    public func configImage(addImage: UIImage,frame: CGRect) {
        let imageView: UIImageView = UIImageView(frame: frame)
        
        self.image = addImage
        imageView.image = image
        
        contentView.addSubview(imageView)
    }
}

class HeaderView: UICollectionViewCell {
    
    public var textLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func config() {
        textLabelConstraints()
    }
    
    private func textLabelConstraints() {
        
        addSubview(textLabel)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                
                textLabel.leftAnchor.constraint(equalTo: leftAnchor),
              textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
              //textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
              //textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
              //textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            ])
        
    }
}

