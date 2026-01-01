import UIKit

class Step1ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🚀 Step1ViewController: viewDidLoad - Starting Step 1/4")
        setupUI()
        loadSavedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        print("👀 Step1ViewController: viewWillAppear - Step 1/4 is now visible")
        print("📊 Navigation stack count: \(navigationController?.viewControllers.count ?? 0)")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Configure progress bar
        progressBar.progress = 0.25
        progressBar.progressTintColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)
        progressBar.trackTintColor = UIColor.lightGray
        
        // Configure step label
        stepLabel.text = "1/4"
        
        // Configure title
        titleLabel.text = "Personal Information"
        
        // Configure subtitle
        subtitleLabel.text = "Let's start with your basic information"
        
        // Configure name label
        nameLabel.text = "Full Name"
        
        // Configure name text field
        nameTextField.placeholder = "Enter your full name"
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.cornerRadius = 8
        
        // Configure email label
        emailLabel.text = "Email ID"
        
        // Configure email text field
        emailTextField.placeholder = "Enter your email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.cornerRadius = 8
        
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
        nameTextField.text = RegistrationData.shared.name
        emailTextField.text = RegistrationData.shared.email
    }
    
    // MARK: - IBActions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        // This is the first screen, so back button can dismiss or do nothing
        if navigationController?.viewControllers.count ?? 0 > 1 {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        print("🔵 Step1ViewController: Next button tapped")
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty else {
            print("❌ Validation failed")
            showAlert(title: "Error", message: "Please fill all fields")
            return
        }
        
        print("✅ Step1: Validation passed - Name: \(name), Email: \(email)")
        
        // Save data
        RegistrationData.shared.name = name
        RegistrationData.shared.email = email
        
        print("💾 Step1: Data saved, navigating to Step 2...")
        
        // Navigate to next step using segue
        performSegue(withIdentifier: "showStep2", sender: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

