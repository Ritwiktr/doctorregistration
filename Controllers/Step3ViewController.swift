import UIKit

class Step3ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var whatsappNumberLabel: UILabel!
    @IBOutlet weak var whatsappNumberTextField: UITextField!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🚀 Step3ViewController: viewDidLoad - Starting Step 3/4")
        setupUI()
        loadSavedData()
        print("✅ Step3ViewController: Button target-action set in setupUI")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("👀 Step3ViewController: viewWillAppear - Step 3/4 is now visible")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Configure progress bar
        progressBar.progress = 0.75
        progressBar.progressTintColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)
        progressBar.trackTintColor = UIColor.lightGray
        
        // Configure step label
        stepLabel.text = "3/4"
        
        // Configure title
        titleLabel.text = "Contact Details"
        
        // Configure subtitle
        subtitleLabel.text = "Provide your contact information"
        
        // Configure labels
        phoneNumberLabel.text = "Phone Number"
        whatsappNumberLabel.text = "WhatsApp Number"
        countryCodeLabel.text = "Country Code"
        
        // Configure text fields
        phoneNumberTextField.placeholder = "Enter phone number"
        phoneNumberTextField.keyboardType = .phonePad
        phoneNumberTextField.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberTextField.layer.borderWidth = 1.0
        phoneNumberTextField.layer.cornerRadius = 8
        
        whatsappNumberTextField.placeholder = "Enter WhatsApp number"
        whatsappNumberTextField.keyboardType = .phonePad
        whatsappNumberTextField.layer.borderColor = UIColor.lightGray.cgColor
        whatsappNumberTextField.layer.borderWidth = 1.0
        whatsappNumberTextField.layer.cornerRadius = 8
        
        countryCodeTextField.placeholder = "Country Code (e.g., IN)"
        countryCodeTextField.text = "IN"
        countryCodeTextField.layer.borderColor = UIColor.lightGray.cgColor
        countryCodeTextField.layer.borderWidth = 1.0
        countryCodeTextField.layer.cornerRadius = 8
        
        // Configure next button
        nextButton.backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 0.6, alpha: 1.0)
        nextButton.tintColor = .white
        nextButton.layer.cornerRadius = 12
        nextButton.layer.shadowColor = UIColor.black.cgColor
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        nextButton.layer.shadowOpacity = 0.2
        nextButton.layer.shadowRadius = 4
    }
    
    private func loadSavedData() {
        phoneNumberTextField.text = RegistrationData.shared.phoneNo
        whatsappNumberTextField.text = RegistrationData.shared.whatsappNo
        countryCodeTextField.text = RegistrationData.shared.countryCode
    }
    
    // MARK: - IBActions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let phoneNo = phoneNumberTextField.text, !phoneNo.isEmpty,
              let whatsappNo = whatsappNumberTextField.text, !whatsappNo.isEmpty,
              let countryCode = countryCodeTextField.text, !countryCode.isEmpty else {
            showAlert(title: "Error", message: "Please fill all fields")
            return
        }
        
        // Save data
        RegistrationData.shared.phoneNo = phoneNo
        RegistrationData.shared.whatsappNo = whatsappNo
        RegistrationData.shared.countryCode = countryCode
        
        // Navigate to next step using segue
        performSegue(withIdentifier: "showStep4", sender: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
