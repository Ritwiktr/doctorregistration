import UIKit

class Step4ViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 1.0
        progressView.progressTintColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)
        progressView.trackTintColor = UIColor.lightGray
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private let stepLabel: UILabel = {
        let label = UILabel()
        label.text = "4/4"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Final Details"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Almost there! Just a few more details"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Age"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your age (e.g., 25)"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let ageUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "Age Unit"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageUnitSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Years", "Months"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 0.6, alpha: 1.0)
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
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
        
        view.addSubview(backButton)
        view.addSubview(progressBar)
        view.addSubview(stepLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(ageLabel)
        contentView.addSubview(ageTextField)
        contentView.addSubview(ageUnitLabel)
        contentView.addSubview(ageUnitSegmentedControl)
        contentView.addSubview(submitButton)
        view.addSubview(activityIndicator)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            progressBar.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            stepLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8),
            stepLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            scrollView.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ageLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            ageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ageTextField.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 8),
            ageTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ageTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ageTextField.heightAnchor.constraint(equalToConstant: 50),
            
            ageUnitLabel.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 24),
            ageUnitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ageUnitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ageUnitSegmentedControl.topAnchor.constraint(equalTo: ageUnitLabel.bottomAnchor, constant: 8),
            ageUnitSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ageUnitSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ageUnitSegmentedControl.heightAnchor.constraint(equalToConstant: 44),
            
            submitButton.topAnchor.constraint(equalTo: ageUnitSegmentedControl.bottomAnchor, constant: 40),
            submitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            submitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadSavedData() {
        ageTextField.text = RegistrationData.shared.age
        ageUnitSegmentedControl.selectedSegmentIndex = RegistrationData.shared.ageUnit == "Y" ? 0 : 1
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func submitButtonTapped() {
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
                    // Navigate to list screen after successful registration
                    let listVC = DoctorListViewController()
                    // Pass the newly registered doctor ID so it can be added to the list
                    if let doctorId = doctorData.id {
                        listVC.newlyRegisteredDoctorId = doctorId
                    }
                    self?.navigationController?.pushViewController(listVC, animated: true)
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
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

