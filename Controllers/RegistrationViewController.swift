import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderStackView: UIStackView!
    @IBOutlet weak var practiceFromLabel: UILabel!
    @IBOutlet weak var practiceStackView: UIStackView!
    @IBOutlet weak var monthsTextField: UITextField!
    @IBOutlet weak var yearsTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var genderButtons: [UIButton] = []
    private var selectedGender: String = "M"
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.0)
        
        // Configure progress bar
        progressBar.progress = 0.5
        progressBar.progressTintColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)
        progressBar.trackTintColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        
        // Configure step label
        stepLabel.text = "2/4"
        
        // Configure title
        titleLabel.text = "Basic Details"
        
        // Configure subtitle
        subtitleLabel.text = "Feel free to fill your details"
        
        // Configure gender label
        genderLabel.text = "Gender"
        
        // Configure practice from label
        practiceFromLabel.text = "Practicing From"
        
        // Configure text fields
        monthsTextField.placeholder = "Months"
        monthsTextField.keyboardType = .numberPad
        monthsTextField.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        monthsTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        monthsTextField.layer.borderWidth = 1.0
        monthsTextField.layer.cornerRadius = 14
        monthsTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        monthsTextField.leftViewMode = .always
        
        yearsTextField.placeholder = "Years"
        yearsTextField.keyboardType = .numberPad
        yearsTextField.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        yearsTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        yearsTextField.layer.borderWidth = 1.0
        yearsTextField.layer.cornerRadius = 14
        yearsTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        yearsTextField.leftViewMode = .always
        
        // Configure next button
        nextButton.backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 0.6, alpha: 1.0)
        nextButton.tintColor = .white
        nextButton.layer.cornerRadius = 30
        nextButton.layer.shadowColor = UIColor(red: 0.0, green: 0.3, blue: 0.6, alpha: 0.4).cgColor
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        nextButton.layer.shadowOpacity = 1.0
        nextButton.layer.shadowRadius = 12
        
        // Setup gender buttons
        setupGenderButtons()
        
        // Add animations
        animateViewsOnAppear()
    }
    
    private func setupGenderButtons() {
        // Clear any existing buttons to avoid duplicates
        genderButtons.forEach { $0.removeFromSuperview() }
        genderButtons.removeAll()
        
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
    
    // MARK: - IBActions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
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
        print("🚀 Navigating to Step 3...")
        
        // Navigate to next step using segue
        performSegue(withIdentifier: "showStep3", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🚀 RegistrationViewController: viewDidLoad - Starting Step 2/4")
        setupUI()
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
        if let index = genders.firstIndex(of: selectedGender), index < genderButtons.count {
            genderButtonTapped(genderButtons[index])
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

