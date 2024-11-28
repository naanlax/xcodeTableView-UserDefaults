import UIKit

protocol ItemCreationDelegate {
    func didCreateItem(itemName: String, itemDesc: String, itemRate: String, itemSKU: String, itemImage: UIImage) -> Void
    func didEditItem(itemName: String, itemDesc: String, itemRate: String, itemSKU: String, itemImage: UIImage) -> Void
    
}

class ItemCreation: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var textf1: UITextField!
    var textf2: UITextField!
    var textf3: UITextField!
    var textf4: UITextField!
    var image_displayed: UIImageView?
    var button_select_image: UIButton!
    var button: UIButton!
    var goBackButton: UIButton!
    
    var imagePicker = UIImagePickerController()

    var itemName: String?
    var itemDesc: String?
    var itemRate: String?
    var itemSKU: String?
    var itemImage: UIImage?
    
    var delegate: ItemCreationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCreation()
    }
    
    func setupCreation() {
        
        view.backgroundColor = .systemBackground
        
        textf1 = UITextField()
        textf1.placeholder = "Item Name"
        textf1.text = itemName
        textf1.layer.cornerRadius = 10
        textf1.layer.borderWidth = 0.7
        textf1.layer.borderColor = UIColor.black.cgColor
        textf1.textAlignment = .center
        textf1.textColor = .black
        view.addSubview(textf1)
        textf1.backgroundColor = .white
        
        textf2 = UITextField()
        textf2.placeholder = "Item Description"
        textf2.text = itemDesc
        textf2.layer.cornerRadius = 10
        textf2.layer.borderWidth = 0.7
        textf2.layer.borderColor = UIColor.black.cgColor
        textf2.textAlignment = .center
        textf2.textColor = .black
        view.addSubview(textf2)
        textf2.backgroundColor = .white
        
        textf3 = UITextField()
        textf3.placeholder = "Item Rate"
        textf3.text = itemRate
        textf3.layer.cornerRadius = 10
        textf3.layer.borderWidth = 0.7
        textf3.layer.borderColor = UIColor.black.cgColor
        textf3.textAlignment = .center
        textf3.textColor = .black
        view.addSubview(textf3)
        textf3.backgroundColor = .white
        
        textf4 = UITextField()
        textf4.placeholder = "Item SKU"
        textf4.text = itemSKU
        textf4.layer.cornerRadius = 10
        textf4.layer.borderWidth = 0.7
        textf4.layer.borderColor = UIColor.black.cgColor
        textf4.textAlignment = .center
        textf4.textColor = .black
        view.addSubview(textf4)
        textf4.backgroundColor = .white
        
        image_displayed = UIImageView()
        image_displayed?.translatesAutoresizingMaskIntoConstraints = false
        image_displayed?.contentMode = .scaleAspectFit
        image_displayed?.layer.cornerRadius = 10
        image_displayed?.layer.masksToBounds = true
        view.addSubview(image_displayed!)
        
        
        image_displayed?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        image_displayed?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        image_displayed?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image_displayed?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        
        button_select_image = UIButton()
        button_select_image.setTitle("Select Image", for: .normal)
        button_select_image.backgroundColor = .systemGray3
        button_select_image.layer.cornerRadius = 10
        button_select_image.tintColor = .black
        button_select_image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        button_select_image.translatesAutoresizingMaskIntoConstraints = false
        button_select_image.addTarget(self, action: #selector(button_select_image_pressed), for: .touchUpInside)
        view.addSubview(button_select_image)
        
        button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.tintColor = .magenta
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        view.addSubview(button)
        
        goBackButton = UIButton(type: .system)
        goBackButton.setTitle("Back", for: .normal)
        goBackButton.tintColor = .systemBlue
        goBackButton.translatesAutoresizingMaskIntoConstraints = false
        goBackButton.addTarget(self, action: #selector(goBackButtonPressed), for: .touchUpInside)
        view.addSubview(goBackButton)
        
        
        let stackView = UIStackView(arrangedSubviews: [button_select_image, textf1, textf2, textf4, textf3, button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.layer.masksToBounds = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            goBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func goBackButtonPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func buttonPressed() {
        guard let itemName = textf1.text, !itemName.isEmpty else {
            print("Item Name is required")
            return
        }

        let itemDesc = textf2.text ?? ""

        let itemRate = textf3.text ?? ""

        guard let itemSKU = textf4.text, !itemSKU.isEmpty else {
            print("Item SKU is required")
            return
        }

        guard let itemImage = image_displayed?.image else {
            print("No image selected.")
            return
        }
        
        delegate?.didCreateItem(itemName: itemName, itemDesc: itemDesc, itemRate: itemRate, itemSKU: itemSKU, itemImage: itemImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func button_select_image_pressed()
    {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        itemImage = image
        image_displayed?.image = itemImage
        
        if(itemImage != nil){
            button_select_image.setTitle("Update Image", for: .normal)
        }
        
        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
