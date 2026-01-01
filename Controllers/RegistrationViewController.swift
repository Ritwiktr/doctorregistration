import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - UI Components
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
        button.tintColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        button.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0.5
        progressView.progressTintColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)
        progressView.trackTintColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private let stepLabel: UILabel = {
        let label = UILabel()
        label.text = "2/4"
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Basic Details"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Feel free to fill your details"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var genderButtons: [UIButton] = []
    private var selectedGender: String = "M"
    
    private let practiceFromLabel: UILabel = {
        let label = UILabel()
        label.text = "Practicing From"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let practiceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let monthsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Months"
        textField.keyboardType = .numberPad
        textField.borderStyle = .none
        textField.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        textField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 14
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let yearsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Years"
        textField.keyboardType = .numberPad
        textField.borderStyle = .none
        textField.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        textField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 14
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        textField.placeholder = "Phone Number"
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
        textField.placeholder = "WhatsApp Number"
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
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 0.6, alpha: 1.0)
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor(red: 0.0, green: 0.3, blue: 0.6, alpha: 0.4).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.0)
        
        view.addSubview(backButton)
        view.addSubview(progressBar)
        view.addSubview(stepLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(genderLabel)
        contentView.addSubview(genderStackView)
        contentView.addSubview(practiceFromLabel)
        contentView.addSubview(practiceStackView)
        contentView.addSubview(nextButton)
        contentView.addSubview(activityIndicator)
        
        practiceStackView.addArrangedSubview(monthsTextField)
        practiceStackView.addArrangedSubview(yearsTextField)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            progressBar.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            stepLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 12),
            stepLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            scrollView.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            genderLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 36),
            genderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            genderStackView.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 14),
            genderStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genderStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            genderStackView.heightAnchor.constraint(equalToConstant: 52),
            
            practiceFromLabel.topAnchor.constraint(equalTo: genderStackView.bottomAnchor, constant: 28),
            practiceFromLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            practiceFromLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            practiceStackView.topAnchor.constraint(equalTo: practiceFromLabel.bottomAnchor, constant: 14),
            practiceStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            practiceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            practiceStackView.heightAnchor.constraint(equalToConstant: 56),
            
            nextButton.topAnchor.constraint(equalTo: practiceStackView.bottomAnchor, constant: 48),
            nextButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 60),
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            nextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Add animations
        animateViewsOnAppear()
    }
    
    private func setupGenderButtons() {
        let genders = [("Male", "M"), ("Female", "F"), ("Others", "O")]
        
        for (index, (title, value)) in genders.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.layer.cornerRadius = 14
            button.tag = index
            button.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
            genderButtons.append(button)
            genderStackView.addArrangedSubview(button)
            
            if value == "M" {
                button.backgroundColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)
                button.setTitleColor(.white, for: .normal)
                button.layer.shadowColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 0.3).cgColor
                button.layer.shadowOffset = CGSize(width: 0, height: 2)
                button.layer.shadowOpacity = 1.0
                button.layer.shadowRadius = 8
            } else {
                button.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
                button.setTitleColor(UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0), for: .normal)
                button.layer.borderWidth = 1.0
                button.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
            }
        }
    }
    
    @objc private func genderButtonTapped(_ sender: UIButton) {
        let genders = ["M", "F", "O"]
        selectedGender = genders[sender.tag]
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            for (index, button) in self.genderButtons.enumerated() {
                if index == sender.tag {
                    button.backgroundColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)
                    button.setTitleColor(.white, for: .normal)
                    button.layer.borderWidth = 0
                    button.layer.shadowColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 0.3).cgColor
                    button.layer.shadowOffset = CGSize(width: 0, height: 2)
                    button.layer.shadowOpacity = 1.0
                    button.layer.shadowRadius = 8
                    button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                } else {
                    button.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
                    button.setTitleColor(UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0), for: .normal)
                    button.layer.borderWidth = 1.0
                    button.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
                    button.layer.shadowOpacity = 0
                    button.transform = .identity
                }
            }
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.genderButtons[sender.tag].transform = .identity
            }
        }
    }
    
    private func animateViewsOnAppear() {
        titleLabel.alpha = 0
        subtitleLabel.alpha = 0
        genderLabel.alpha = 0
        genderStackView.alpha = 0
        practiceFromLabel.alpha = 0
        practiceStackView.alpha = 0
        nextButton.alpha = 0
        
        titleLabel.transform = CGAffineTransform(translationX: 0, y: 10)
        subtitleLabel.transform = CGAffineTransform(translationX: 0, y: 10)
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut) {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut) {
            self.subtitleLabel.alpha = 1
            self.subtitleLabel.transform = .identity
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut) {
            self.genderLabel.alpha = 1
            self.genderStackView.alpha = 1
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseOut) {
            self.practiceFromLabel.alpha = 1
            self.practiceStackView.alpha = 1
        }
        
        nextButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.nextButton.alpha = 1
            self.nextButton.transform = .identity
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🚀 RegistrationViewController: viewDidLoad - Starting Step 2/4")
        setupUI()
        setupGenderButtons()
        loadSavedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("👀 RegistrationViewController: viewWillAppear - Step 2/4 is now visible")
        print("📊 Navigation stack count: \(navigationController?.viewControllers.count ?? 0)")
        if let navController = navigationController {
            print("📋 Navigation stack: \(navController.viewControllers.map { String(describing: type(of: $0)) })")
        } else {
            print("❌ Navigation controller is nil!")
        }
    }
    
    private func loadSavedData() {
        selectedGender = RegistrationData.shared.gender
        monthsTextField.text = RegistrationData.shared.practiceFromMonths
        yearsTextField.text = RegistrationData.shared.practiceFromYears
        
        // Update gender button selection
        let genders = ["M", "F", "O"]
        if let index = genders.firstIndex(of: selectedGender) {
            genderButtonTapped(genderButtons[index])
        }
    }
    
    @objc private func nextButtonTapped() {
        print("🔵 ===== Next button tapped on Step 2/4 =====")
        print("📍 Current view controller: \(String(describing: type(of: self)))")
        print("📍 Navigation controller: \(navigationController != nil ? "EXISTS" : "NIL")")
        
        guard let months = monthsTextField.text, !months.isEmpty,
              let years = yearsTextField.text, !years.isEmpty else {
            print("❌ Validation failed - missing months or years")
            showAlert(title: "Error", message: "Please fill all fields")
            return
        }
        
        print("✅ Validation passed - Months: \(months), Years: \(years), Gender: \(selectedGender)")
        
        // Save data
        RegistrationData.shared.gender = selectedGender
        RegistrationData.shared.practiceFromMonths = months
        RegistrationData.shared.practiceFromYears = years
        
        print("💾 Data saved to RegistrationData.shared")
        print("🚀 Creating Step3ViewController...")
        
        // Navigate to next step
        let step3VC = Step3ViewController()
        print("✅ Step3ViewController created")
        
        guard let navController = navigationController else {
            print("❌ CRITICAL: Navigation controller is nil!")
            print("❌ Cannot navigate to Step 3")
            showAlert(title: "Navigation Error", message: "Navigation controller not available. Please restart the app.")
            return
        }
        
        print("✅ Navigation controller found")
        print("📊 Current stack count: \(navController.viewControllers.count)")
        print("🚀 Pushing Step3ViewController...")
        
        DispatchQueue.main.async {
            navController.pushViewController(step3VC, animated: true)
            print("✅ Navigation command executed")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

