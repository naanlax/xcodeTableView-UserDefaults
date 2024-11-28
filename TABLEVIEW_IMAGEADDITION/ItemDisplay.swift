import UIKit

protocol ItemDisplayDelegate{
    func didUpdateItem(itemname: String, itemdesc: String, itemrate: String, itemsku: String, itemimage: UIImage) -> Void
    func didDeleteItem(itemname:String, itemdesc: String, itemrate: String, itemsku: String, itemimage: UIImage) -> Void
}

class ItemDisplay: UIViewController, ItemCreationDelegate {

    func didCreateItem(itemName: String, itemDesc: String, itemRate: String, itemSKU: String, itemImage: UIImage) {
        
    }
    
    func didEditItem(itemName: String, itemDesc: String, itemRate: String, itemSKU: String, itemImage : UIImage) {
        self.itemname = itemName
        self.itemdesc = itemDesc
        self.itemrate = itemRate
        self.itemsku = itemSKU
        self.itemimage = itemImage

        nameLabel.text = "Item Name : \(itemname)"
        descLabel.text = "Description : \(itemdesc)"
        rateLabel.text = "Price : \(itemrate)"
        skuLabel.text = "SKU : \(itemsku)"
    }
    
    var itemname : String = ""
    var itemsku : String = ""
    var itemrate : String = ""
    var itemdesc : String = ""
    var itemimage : UIImage?
    
    var delegate: ItemDisplayDelegate?
    
    init(itemname: String,itemsku: String,itemrate: String,itemdesc: String, itemimage: UIImage){
        
        self.itemname = itemname
        self.itemsku = itemsku
        self.itemrate = itemrate
        self.itemdesc = itemdesc
        self.itemimage = itemimage
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBlue
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemRed
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = label.font.withSize(25)
        return label
    }()
    
    let skuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = label.font.withSize(25)
        return label
    }()
    
    let rateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = label.font.withSize(25)
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = label.font.withSize(25)
        return label
    }()
    
    let imageLabel: UIImageView = {
        let label = UIImageView()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        nameLabel.text = "Item Name : \(itemname)"
        descLabel.text = "Description: \(itemdesc)"
        rateLabel.text = "Price : \(itemrate)"
        skuLabel.text = "SKU : \(itemsku)"
        
        setupUI()
        
    }
    
    func setupUI() {
        view.addSubview(nameLabel)
        view.addSubview(skuLabel)
        view.addSubview(rateLabel)
        view.addSubview(descLabel)
        view.addSubview(imageLabel)
        view.addSubview(editButton)
        view.addSubview(backButton)
        view.addSubview(deleteButton)
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, skuLabel, rateLabel, descLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.layer.masksToBounds = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            deleteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -20),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        
        editButton.addTarget(self, action: #selector(edit_tapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(back_tapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(delete_tapped), for: .touchUpInside)
    }
    
    @objc func edit_tapped() {
        let itemCreationVC = ItemCreation()
        itemCreationVC.delegate = self
        itemCreationVC.itemName = itemname
        itemCreationVC.itemDesc = itemdesc
        itemCreationVC.itemRate = itemrate
        itemCreationVC.itemSKU = itemsku
        itemCreationVC.itemImage = itemimage
        itemCreationVC.modalPresentationStyle = .fullScreen
        present(itemCreationVC, animated: true, completion: nil)
    }
        
    @objc func back_tapped() {
        delegate?.didUpdateItem(itemname: itemname, itemdesc: itemdesc, itemrate: itemrate, itemsku: itemsku, itemimage: itemimage!)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func delete_tapped() {
        let alertController = UIAlertController(
            title: "Confirm Deletion",
            message: "Are you sure you want to delete this item?",
            preferredStyle: .alert
        )
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
            
        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { _ in
            self.confirmDeletion()
        }
        
        alertController.addAction(confirmAction)
            
        present(alertController, animated: true, completion: nil)
    }
    
    func confirmDeletion() {
        delegate?.didDeleteItem(itemname: itemname, itemdesc: itemdesc, itemrate: itemrate, itemsku: itemsku, itemimage: itemimage!)
        dismiss(animated: true, completion: nil)
    }
}
