import UIKit

class Step3ViewController: UIViewController {
    
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
        progressView.progress = 0.75
        progressView.progressTintColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)
        progressView.trackTintColor = UIColor.lightGray
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private let stepLabel: UILabel = {
        let label = UILabel()
        label.text = "3/4"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Contact Details"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Provide your contact information"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone Number"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter phone number"
        textField.keyboardType = .phonePad
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let whatsappNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "WhatsApp Number"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let whatsappNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter WhatsApp number"
        textField.keyboardType = .phonePad
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let countryCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "Country Code"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countryCodeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Country Code (e.g., IN)"
        textField.text = "IN"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
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
        
        view.addSubview(backButton)
        view.addSubview(progressBar)
        view.addSubview(stepLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(phoneNumberLabel)
        contentView.addSubview(phoneNumberTextField)
        contentView.addSubview(whatsappNumberLabel)
        contentView.addSubview(whatsappNumberTextField)
        contentView.addSubview(countryCodeLabel)
        contentView.addSubview(countryCodeTextField)
        contentView.addSubview(nextButton)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
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
            
            phoneNumberLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            phoneNumberTextField.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 8),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 50),
            
            whatsappNumberLabel.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 24),
            whatsappNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            whatsappNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            whatsappNumberTextField.topAnchor.constraint(equalTo: whatsappNumberLabel.bottomAnchor, constant: 8),
            whatsappNumberTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            whatsappNumberTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            whatsappNumberTextField.heightAnchor.constraint(equalToConstant: 50),
            
            countryCodeLabel.topAnchor.constraint(equalTo: whatsappNumberTextField.bottomAnchor, constant: 24),
            countryCodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            countryCodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            countryCodeTextField.topAnchor.constraint(equalTo: countryCodeLabel.bottomAnchor, constant: 8),
            countryCodeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            countryCodeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            countryCodeTextField.heightAnchor.constraint(equalToConstant: 50),
            
            nextButton.topAnchor.constraint(equalTo: countryCodeTextField.bottomAnchor, constant: 40),
            nextButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 60),
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            nextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func loadSavedData() {
        phoneNumberTextField.text = RegistrationData.shared.phoneNo
        whatsappNumberTextField.text = RegistrationData.shared.whatsappNo
        countryCodeTextField.text = RegistrationData.shared.countryCode
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextButtonTapped() {
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
        
        // Navigate to next step
        let step4VC = Step4ViewController()
        navigationController?.pushViewController(step4VC, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

