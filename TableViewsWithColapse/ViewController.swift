//
//  ViewController.swift
//  TableViewsWithColapse
//
//  Created by Chrystian Salgado on 27/04/23.
//

import UIKit

public protocol YViewCodeConfigurator {
    /// Where you add all your subviews.
    func addSubviews()
    /// Where you should place your constraint related functions / setup.
    func constrainSubviews()
    /// Where you setup something other than constraints and view hierarchy
    func configureAdditionalSettings()
}

public extension YViewCodeConfigurator {
    func initLayout() {
        addSubviews()
        constrainSubviews()
        configureAdditionalSettings()
    }
}

open class YCodedView: UIView, YViewCodeConfigurator {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        constrainSubviews()
        configureAdditionalSettings()
    }
    
    @available(*, unavailable)
    required public init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func addSubviews() {}
    open func constrainSubviews() {}
    open func configureAdditionalSettings() {}
}

public protocol YCodeView where Self: UIView {
    func configureView()
    func configureViewHierarchy()
    func configureConstraints()
    func configureAdditionalConfiguration()
}

public extension YCodeView {
    func configureView() {
        configureViewHierarchy()
        configureConstraints()
        configureAdditionalConfiguration()
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.pushViewController(MyViewController(), animated: true)
    }
}

final class MyView: YCodedView {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ahsiohfioahfioshiofahsiofshiohafsioajsafifhiaohfioashiofashiofsioa"
        label.textColor = .blue
        return label
    }()
    
    private lazy var sbSearch: UISearchBar = {
        let sbSearch = UISearchBar()
        sbSearch.translatesAutoresizingMaskIntoConstraints = false
        sbSearch.barStyle = .default
        sbSearch.searchBarStyle = .minimal
        
        if let textField = sbSearch.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            textField.textColor = .black
            textField.tintColor = .orange
            textField.clearButtonMode = .always
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.separator.cgColor
            textField.layer.cornerRadius = 10
            
            let backgroundView = textField.subviews.first
            if #available(iOS 11.0, *) {
                backgroundView?.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                backgroundView?.subviews.forEach({ $0.removeFromSuperview() })
            }
            backgroundView?.layer.cornerRadius = 10.5
            backgroundView?.layer.masksToBounds = true
        }
        
        sbSearch.text = nil
        sbSearch.resignFirstResponder()
        sbSearch.addShadow(shadowColor: UIColor.separator.cgColor, shadowOffset: .init(width: 0.3, height: 2.0))
        return sbSearch
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    typealias TableViewDelAndDTSource = UITableViewDelegate & UITableViewDataSource
    
    init(tableViewDelegateAndDataSource: TableViewDelAndDTSource, sbDelegate: UISearchBarDelegate) {
        super.init(frame: .zero)
        sbSearch.delegate = sbDelegate
        tableView.delegate = tableViewDelegateAndDataSource
        tableView.dataSource = tableViewDelegateAndDataSource
    }
    
    override func addSubviews() {
        addSubview(label)
        addSubview(sbSearch)
        addSubview(tableView)
    }
    
    override func constrainSubviews() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            sbSearch.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            sbSearch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sbSearch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: sbSearch.bottomAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20)
        ])
    }
}

struct ReturnedData {
    struct SocialMedia {
        let id: String
        let name: String
        let socialType: String
        let url: String
    }
    
    let arrayOfData: [SocialMedia]
    
    static func fixture() -> ReturnedData {
        return .init(arrayOfData: [
            .init(id: "1", name: "Facebook", socialType: "social", url: ""),
            .init(id: "2", name: "Twitter", socialType: "social", url: ""),
            .init(id: "3", name: "Telegram", socialType: "social_chat", url: ""),
            .init(id: "3.5", name: "Phone Whats", socialType: "social_chat", url: ""),
            .init(id: "4", name: "Phone", socialType: "phone", url: "tel://32119999966666"),
            .init(id: "5", name: "Phone 2", socialType: "phone", url: "tel://32119999966666"),
        ])
    }
}

struct SocialMediaGrouped {
    var isColapsed: Bool = false
    var cattegoryName: String
    var socialMedia: [ReturnedData.SocialMedia] = []
}

final class MyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var socialMediaByGroup: [SocialMediaGrouped] = []
    var socialMedia: [ReturnedData.SocialMedia] = []
    
    weak var customView: MyView?
    
    override func loadView() {
        super.loadView()
        view = MyView(tableViewDelegateAndDataSource: self, sbDelegate: self)
        customView = view as? MyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.socialMedia = ReturnedData.fixture().arrayOfData
        prepareReturnedData(self.socialMedia)
    }
    
    private func prepareReturnedData(_ bySocialMedias: [ReturnedData.SocialMedia]) {
        socialMediaByGroup.removeAll()
        let dictResult = Dictionary(grouping: bySocialMedias, by: { $0.socialType })
        dictResult.forEach { category, items in
            self.socialMediaByGroup.append(.init(cattegoryName: category, socialMedia: items))
        }
        
        customView?.tableView.reloadData()
    }
    
    private func showHideSection(_ id: Int) {
        socialMediaByGroup[id].isColapsed.toggle()
        customView?.tableView.reloadData()
    }
    
    // MARK: - TableViewDelegate, TableViewDataSource
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let someView = ThatsMeSocialMediasHeaderView(
            id: section,
            title: socialMediaByGroup[section].cattegoryName,
            image: !socialMediaByGroup[section].isColapsed ? .init(named: "ico_dropdown")!.rotate(radians: .pi) : .init(named: "ico_dropdown")!
        )
        someView.didTap = { id in
            self.showHideSection(id)
        }
        return someView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return socialMediaByGroup.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socialMediaByGroup[section].isColapsed ? 0 : socialMediaByGroup[section].socialMedia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = socialMediaByGroup[indexPath.section].socialMedia[indexPath.row].name
        return cell
    }
}

extension MyViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let result = socialMedia.filter { media in
            media.name.hasPrefix(searchText)
        }
        
        prepareReturnedData(result)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        prepareReturnedData(socialMedia)
    }
}


extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}
extension UIView {
    public func addShadow(shadowColor: CGColor,
                          shadowOpacity: Float = 1,
                          shadowRadius: CGFloat = 1,
                          shadowOffset: CGSize,
                          borderCornerRadius: CGFloat = 1){
        
        self.layer.cornerRadius = borderCornerRadius
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = shadowOffset
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
