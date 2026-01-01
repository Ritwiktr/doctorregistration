import UIKit

class Step4ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var ageUnitLabel: UILabel!
    @IBOutlet weak var ageUnitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🚀 Step4ViewController: viewDidLoad - Starting Step 4/4")
        setupUI()
        loadSavedData()
        print("✅ Step4ViewController: Button target-action set in setupUI")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("👀 Step4ViewController: viewWillAppear - Step 4/4 is now visible")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Configure progress bar
        progressBar.progress = 1.0
        progressBar.progressTintColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)
        progressBar.trackTintColor = UIColor.lightGray
        
        // Configure step label
        stepLabel.text = "4/4"
        
        // Configure title
        titleLabel.text = "Final Details"
        
        // Configure subtitle
        subtitleLabel.text = "Almost there! Just a few more details"
        
        // Configure age label
        ageLabel.text = "Age"
        
        // Configure age text field
        ageTextField.placeholder = "Enter your age (e.g., 25)"
        ageTextField.keyboardType = .numberPad
        ageTextField.layer.borderColor = UIColor.lightGray.cgColor
        ageTextField.layer.borderWidth = 1.0
        ageTextField.layer.cornerRadius = 8
        
        // Configure age unit label
        ageUnitLabel.text = "Age Unit"
        
        // Configure segmented control
        ageUnitSegmentedControl.selectedSegmentIndex = 0
        
        // Configure submit button
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 0.6, alpha: 1.0)
        submitButton.tintColor = .white
        submitButton.layer.cornerRadius = 12
        submitButton.layer.shadowColor = UIColor.black.cgColor
        submitButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        submitButton.layer.shadowOpacity = 0.2
        submitButton.layer.shadowRadius = 4
    }
    
    private func loadSavedData() {
        ageTextField.text = RegistrationData.shared.age
        ageUnitSegmentedControl.selectedSegmentIndex = RegistrationData.shared.ageUnit == "Y" ? 0 : 1
    }
    
    // MARK: - IBActions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        // Validate Step 4 fields
        guard let ageText = ageTextField.text, !ageText.isEmpty else {
            showAlert(title: "Error", message: "Please enter your age")
            return
        }
        
        // Validate age - should be a reasonable number (not a year like 2021)
        guard let ageInt = Int(ageText) else {
            showAlert(title: "Invalid Age", message: "Please enter a valid number for your age")
            return
        }
        
        // Reject 4-digit numbers (likely birth years like 2021, 1990, etc.)
        if ageText.count >= 4 {
            showAlert(title: "Invalid Age", message: "Please enter your age in years (e.g., 25), not your birth year (e.g., 2021)")
            return
        }
        
        // Validate age range (1-150 years)
        guard ageInt > 0 && ageInt <= 150 else {
            showAlert(title: "Invalid Age", message: "Please enter a valid age between 1 and 150 years")
            return
        }
        
        let ageUnit = ageUnitSegmentedControl.selectedSegmentIndex == 0 ? "Y" : "M"
        
        // Save Step 4 data
        RegistrationData.shared.age = ageText
        RegistrationData.shared.ageUnit = ageUnit
        
        // Comprehensive validation of all fields from all steps
        let data = RegistrationData.shared
        
        // Validate Step 1 fields
        guard !data.name.isEmpty else {
            showAlert(title: "Validation Error", message: "Name is required. Please go back to Step 1 and enter your name.")
            return
        }
        
        guard !data.email.isEmpty else {
            showAlert(title: "Validation Error", message: "Email is required. Please go back to Step 1 and enter your email.")
            return
        }
        
        // Validate email format
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: data.email) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }
        
        // Validate Step 2 fields
        guard !data.gender.isEmpty else {
            showAlert(title: "Validation Error", message: "Gender is required. Please go back to Step 2 and select your gender.")
            return
        }
        
        guard !data.practiceFromMonths.isEmpty else {
            showAlert(title: "Validation Error", message: "Practice from (months) is required. Please go back to Step 2 and enter the months.")
            return
        }
        
        guard !data.practiceFromYears.isEmpty else {
            showAlert(title: "Validation Error", message: "Practice from (years) is required. Please go back to Step 2 and enter the years.")
            return
        }
        
        // Validate Step 3 fields
        guard !data.phoneNo.isEmpty else {
            showAlert(title: "Validation Error", message: "Phone number is required. Please go back to Step 3 and enter your phone number.")
            return
        }
        
        guard !data.whatsappNo.isEmpty else {
            showAlert(title: "Validation Error", message: "WhatsApp number is required. Please go back to Step 3 and enter your WhatsApp number.")
            return
        }
        
        guard !data.countryCode.isEmpty else {
            showAlert(title: "Validation Error", message: "Country code is required. Please go back to Step 3 and enter the country code.")
            return
        }
        
        // Validate phone numbers (basic validation - should be numeric and reasonable length)
        let phoneRegex = "^[0-9]{10,15}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let cleanedPhoneNo = data.phoneNo.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        guard phonePredicate.evaluate(with: cleanedPhoneNo) else {
            showAlert(title: "Invalid Phone Number", message: "Please enter a valid phone number (10-15 digits).")
            return
        }
        
        let cleanedWhatsappNo = data.whatsappNo.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        guard phonePredicate.evaluate(with: cleanedWhatsappNo) else {
            showAlert(title: "Invalid WhatsApp Number", message: "Please enter a valid WhatsApp number (10-15 digits).")
            return
        }
        
        // Prepare request with validated and cleaned data
        let cleanedName = data.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedNameUpper = cleanedName.uppercased()
        let cleanedCountryCode = data.countryCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let cleanedEmail = data.email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        let request = RegistrationRequest(
            name: cleanedName,
            nameUpper: cleanedNameUpper,
            phoneNo: cleanedPhoneNo,
            whatsappNo: cleanedWhatsappNo,
            countryCode: cleanedCountryCode,
            email: cleanedEmail,
            gender: data.gender,
            age: data.age,
            ageUnit: data.ageUnit
        )
        
        // Debug: Print all values being sent (actual values in request)
        print("=== Registration Data (Actual Values Being Sent) ===")
        print("Name: \(cleanedName)")
        print("NameUpper: \(cleanedNameUpper)")
        print("PhoneNo: \(cleanedPhoneNo)")
        print("WhatsappNo: \(cleanedWhatsappNo)")
        print("CountryCode: \(cleanedCountryCode)")
        print("Email: \(cleanedEmail)")
        print("Gender: \(data.gender)")
        print("Age: \(data.age)")
        print("AgeUnit: \(data.ageUnit)")
        print("===================================================")
        
        activityIndicator.startAnimating()
        submitButton.isEnabled = false
        
        APIService.shared.registerDoctor(request: request) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.submitButton.isEnabled = true
                
                switch result {
                case .success(let doctorData):
                    // Navigate to list screen after successful registration using segue
                    self?.performSegue(withIdentifier: "showDoctorList", sender: doctorData.id)
                case .failure(let error):
                    // Display the actual error message from the API
                    let errorMessage = error.localizedDescription
                    print("❌ Registration failed: \(errorMessage)")
                    
                    // Provide more helpful error messages based on common issues
                    var userFriendlyMessage = errorMessage
                    if errorMessage.contains("Network error") {
                        userFriendlyMessage = "Unable to connect to the server. Please check your internet connection and try again."
                    } else if errorMessage.contains("401") || errorMessage.contains("Unauthorized") || errorMessage.contains("Authentication failed") {
                        userFriendlyMessage = "Authentication Error (401): The server rejected the request. Please verify:\n\n1. The API endpoint is correct\n2. No authentication is required (as per assignment)\n3. The server is accessible\n\nTry testing the API in Postman first to verify it works."
                    } else if errorMessage.contains("400") || errorMessage.contains("Bad Request") {
                        userFriendlyMessage = "Invalid data submitted. Please check all fields and try again.\n\n\(errorMessage)"
                    } else if errorMessage.contains("500") || errorMessage.contains("Internal Server Error") {
                        userFriendlyMessage = "Server error occurred. Please try again later.\n\n\(errorMessage)"
                    } else if errorMessage.contains("403") || errorMessage.contains("Forbidden") {
                        userFriendlyMessage = "Access denied. Please check your credentials.\n\n\(errorMessage)"
                    } else if errorMessage.contains("couldn't be read") || errorMessage.contains("correct format") {
                        userFriendlyMessage = "Server returned an unexpected response format. This usually means:\n\n1. The server returned HTML instead of JSON (check for 401/403 errors)\n2. The API endpoint might be incorrect\n3. The server might require authentication\n\nCheck the Xcode console logs for the raw response."
                    }
                    
                    self?.showAlert(title: "Registration Failed", message: userFriendlyMessage)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDoctorList",
           let listVC = segue.destination as? DoctorListViewController,
           let doctorId = sender as? String {
            listVC.newlyRegisteredDoctorId = doctorId
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

