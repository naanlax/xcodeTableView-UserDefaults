import UIKit

struct Item {
    var name: String
    var desc: String
    var sku: String
    var rate: String
    var image: UIImage
}

class ViewController: UITableViewController, ItemCreationDelegate, ItemDisplayDelegate, UISearchBarDelegate {
    
    var items: [Item] = []
    
    var fabToAddItems: UIButton!
    
    var searching: Bool = false
    
    var search_display_items: [Item] = []
    
    func didUpdateItem(itemname: String, itemdesc: String, itemrate: String, itemsku: String, itemimage: UIImage)
    {
        if let index = items.firstIndex(where: { $0.sku == itemsku }) {
            items[index] = Item(name: itemname, desc: itemdesc, sku: itemsku, rate: itemrate, image: itemimage)
            tableView.reloadData()
        }
    }

    func didCreateItem(itemName: String, itemDesc: String, itemRate: String, itemSKU: String, itemImage: UIImage)
    {
        items.append(Item(name: itemName, desc: itemDesc, sku: itemSKU, rate: itemRate, image: itemImage))
        tableView.reloadData()
    }
    
    func didDeleteItem(itemname: String, itemdesc: String, itemrate: String, itemsku: String, itemimage: UIImage)
    {
        if let index = items.firstIndex(where: { $0.sku == itemsku }) {
            items.remove(at: index)
            tableView.reloadData()
        }
    }
    
    func didEditItem(itemName: String, itemDesc: String, itemRate: String, itemSKU: String, itemImage: UIImage)
    {
        // Implement edit functionality
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupTableView()
        
        let fabImage = UIImage(
            systemName: "plus",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 30,
                weight: .medium
            )
        )
        
        fabToAddItems = UIButton()
        fabToAddItems.translatesAutoresizingMaskIntoConstraints = false
        fabToAddItems.tintColor = .white
        fabToAddItems.backgroundColor = .systemBlue
        fabToAddItems.layer.masksToBounds = false
        fabToAddItems.layer.cornerRadius = 25
        fabToAddItems.layer.shouldRasterize = true
        fabToAddItems.setImage(fabImage, for: .normal)
        fabToAddItems.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        view.addSubview(fabToAddItems)
        
        
        NSLayoutConstraint.activate([
            fabToAddItems.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            fabToAddItems.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            fabToAddItems.widthAnchor.constraint(equalToConstant: 50),
            fabToAddItems.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupTableView()
    {
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .systemBackground
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        tableView.separatorColor = .clear
        tableView.separatorStyle = .none
        
        let label_for_header = UILabel()
        label_for_header.text = "ITEMS"
        label_for_header.textAlignment = .center
        label_for_header.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        let searchbar_for_header = UISearchBar()
        searchbar_for_header.searchBarStyle = .minimal
        searchbar_for_header.delegate = self
        searchbar_for_header.placeholder = "Search for the item"
        searchbar_for_header.sizeToFit()
        searchbar_for_header.isTranslucent = true
        
        let stackView_horizontal = UIStackView(arrangedSubviews: [label_for_header, searchbar_for_header])
        stackView_horizontal.axis = .vertical
        stackView_horizontal.spacing = 10
        stackView_horizontal.alignment = .fill
        stackView_horizontal.distribution = .fillProportionally
        stackView_horizontal.translatesAutoresizingMaskIntoConstraints = false
        
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        headerView.addSubview(stackView_horizontal)
        
        NSLayoutConstraint.activate([
            stackView_horizontal.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            stackView_horizontal.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            stackView_horizontal.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            stackView_horizontal.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10)
        ])
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if items.count == 0
        {
            self.tableView.setEmptyMessage("Click the 'plus' icon to add items", UIImage.emptyState)
        }
        else
        {
            self.tableView.restore()
        }

        if searching
        {
            return search_display_items.count
        }
        else
        {
            return items.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? CustomTableViewCell else {
                fatalError("Unable to dequeue CustomTableViewCell")
        }
        cell.backgroundColor = .white
        
        let item = searching ? search_display_items[indexPath.row] : items[indexPath.row]
        
        cell.configure(with: item)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = searching ? search_display_items[indexPath.row] : items[indexPath.row]
        let detailVC = ItemDisplay(itemname: selectedItem.name, itemsku: selectedItem.sku, itemrate: selectedItem.rate, itemdesc: selectedItem.desc, itemimage: selectedItem.image)
        detailVC.delegate = self
        detailVC.modalPresentationStyle = .fullScreen
        present(detailVC, animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty
        {
            search_display_items = items
            searching = false
        }
        else
        {
            search_display_items = items.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.sku.lowercased().contains(searchText.lowercased())
            }
            searching = true
        }
        
        tableView.reloadData()
    }

    
    @objc func buttonPressed() {
        let itemCreationVC = ItemCreation()
        itemCreationVC.delegate = self
        itemCreationVC.modalPresentationStyle = .fullScreen
        present(itemCreationVC, animated: true, completion: nil)
    }
}

class CustomTableViewCell: UITableViewCell {
    
    let itemImageView = UIImageView()
    let nameLabel = UILabel()
    let skuLabel = UILabel()
    let descLabel = UILabel()
    let rateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.layer.cornerRadius = 8
        itemImageView.clipsToBounds = true
        
        skuLabel.font = UIFont.systemFont(ofSize: 14)
        skuLabel.textColor = .darkGray

        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black

        descLabel.font = UIFont.systemFont(ofSize: 12)
        descLabel.textColor = .gray

        rateLabel.font = UIFont.boldSystemFont(ofSize: 13)
        rateLabel.textColor = .black

        contentView.addSubview(itemImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(skuLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(rateLabel)

        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        skuLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 60),
            itemImageView.heightAnchor.constraint(equalToConstant: 60),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            skuLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            skuLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            skuLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            descLabel.topAnchor.constraint(equalTo: skuLabel.bottomAnchor, constant: 5),
            descLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            rateLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 5),
            rateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            rateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: Item) {
        itemImageView.image = item.image
        nameLabel.text = item.name
        skuLabel.text = "SKU : \(item.sku)"
        descLabel.text = item.desc
        rateLabel.text = "Rate : \(item.rate)"
    }
}

extension UITableView {
    
    func setEmptyMessage(_ message: String, _ image : UIImage) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Arial", size: 20)
        messageLabel.sizeToFit()
        
        let imageDisplayed = UIImageView()
        imageDisplayed.image = image
        imageDisplayed.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageDisplayed.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageDisplayed.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [imageDisplayed, messageLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.layer.masksToBounds = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerView = UIView()
        headerView.addSubview(stackView)
        
        stackView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        
        self.backgroundView = headerView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


