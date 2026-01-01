import UIKit

class DoctorListViewController: UIViewController {
    
    var newlyRegisteredDoctorId: String? // ID of doctor just registered
    
    // Header container with gradient
    private let headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let headerGradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.3, green: 0.5, blue: 0.95, alpha: 1.0).cgColor,
            UIColor(red: 0.5, green: 0.4, blue: 0.9, alpha: 1.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "All Doctors"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Browse registered doctors"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countBadge: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let emptyStateContainer: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyStateIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.3.fill"))
        imageView.tintColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No doctors found"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptyStateSubtitle: UILabel = {
        let label = UILabel()
        label.text = "Doctors will appear here once registered"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var doctors: [Doctor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadDoctors()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerGradientLayer.frame = headerContainerView.bounds
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.0)
        
        // Hide default navigation bar title
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = ""
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        // Configure tableView
        tableView.register(DoctorTableViewCell.self, forCellReuseIdentifier: "DoctorCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.0)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        
        // Configure activity indicator
        activityIndicator.color = UIColor(red: 0.3, green: 0.5, blue: 0.95, alpha: 1.0)
        
        // Setup header (programmatically since it's complex)
        headerContainerView.layer.insertSublayer(headerGradientLayer, at: 0)
        headerContainerView.addSubview(titleLabel)
        headerContainerView.addSubview(subtitleLabel)
        headerContainerView.addSubview(countBadge)
        countBadge.addSubview(countLabel)
        
        view.addSubview(headerContainerView)
        
        // Empty state
        emptyStateContainer.addSubview(emptyStateIcon)
        emptyStateContainer.addSubview(emptyStateLabel)
        emptyStateContainer.addSubview(emptyStateSubtitle)
        view.addSubview(emptyStateContainer)
        
        NSLayoutConstraint.activate([
            // Header
            headerContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainerView.heightAnchor.constraint(equalToConstant: 180),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -20),
            
            countBadge.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            countBadge.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 20),
            countBadge.heightAnchor.constraint(equalToConstant: 24),
            countBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            countLabel.centerXAnchor.constraint(equalTo: countBadge.centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: countBadge.centerYAnchor),
            countLabel.leadingAnchor.constraint(equalTo: countBadge.leadingAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: countBadge.trailingAnchor, constant: -12),
            
            // Table view
            tableView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Activity indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Empty state
            emptyStateContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            emptyStateIcon.topAnchor.constraint(equalTo: emptyStateContainer.topAnchor),
            emptyStateIcon.centerXAnchor.constraint(equalTo: emptyStateContainer.centerXAnchor),
            emptyStateIcon.widthAnchor.constraint(equalToConstant: 80),
            emptyStateIcon.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateIcon.bottomAnchor, constant: 20),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateContainer.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateContainer.trailingAnchor),
            
            emptyStateSubtitle.topAnchor.constraint(equalTo: emptyStateLabel.bottomAnchor, constant: 8),
            emptyStateSubtitle.leadingAnchor.constraint(equalTo: emptyStateContainer.leadingAnchor),
            emptyStateSubtitle.trailingAnchor.constraint(equalTo: emptyStateContainer.trailingAnchor),
            emptyStateSubtitle.bottomAnchor.constraint(equalTo: emptyStateContainer.bottomAnchor)
        ])
        
        // Animate header on appear
        animateHeaderOnAppear()
    }
    
    private func animateHeaderOnAppear() {
        titleLabel.alpha = 0
        subtitleLabel.alpha = 0
        countBadge.alpha = 0
        
        titleLabel.transform = CGAffineTransform(translationX: 0, y: -10)
        subtitleLabel.transform = CGAffineTransform(translationX: 0, y: -10)
        countBadge.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.6, delay: 0.1, options: .curveEaseOut) {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.2, options: .curveEaseOut) {
            self.subtitleLabel.alpha = 1
            self.subtitleLabel.transform = .identity
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.countBadge.alpha = 1
            self.countBadge.transform = .identity
        }
    }
    
    private func loadDoctors() {
        activityIndicator.startAnimating()
        
        // If we have a newly registered doctor ID, fetch that doctor first
        if let doctorId = newlyRegisteredDoctorId {
            APIService.shared.getDoctorById(doctorId: doctorId) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let doctor):
                    self?.doctors.append(doctor)
                    self?.updateCountBadge()
                    self?.tableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                    self?.emptyStateContainer.isHidden = !(self?.doctors.isEmpty ?? true)
                    self?.animateCellsOnAppear()
                    case .failure(let error):
                        print("⚠️ Could not fetch newly registered doctor: \(error.localizedDescription)")
                        // Continue to try loading all doctors
                    }
                    
                    // Now try to load all doctors
                    self?.loadAllDoctors()
                }
            }
        } else {
            loadAllDoctors()
        }
    }
    
    private func loadAllDoctors() {
        APIService.shared.getAllDoctors { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let doctors):
                    // Merge with existing doctors (avoid duplicates)
                    let existingIds = Set(self?.doctors.map { $0.id } ?? [])
                    let newDoctors = doctors.filter { !existingIds.contains($0.id) }
                    self?.doctors.append(contentsOf: newDoctors)
                    self?.updateCountBadge()
                    self?.tableView.reloadData()
                    self?.emptyStateContainer.isHidden = !(self?.doctors.isEmpty ?? true)
                    self?.animateCellsOnAppear()
                case .failure(let error):
                    var errorMessage = error.localizedDescription
                    if errorMessage.contains("401") || errorMessage.contains("Unauthorized") || errorMessage.contains("Authentication failed") {
                        // If list fails but we have at least one doctor, just show a message
                        if !(self?.doctors.isEmpty ?? true) {
                            // Already showing the doctor we registered, no need for error
                            self?.emptyStateLabel.isHidden = true
                            return
                        }
                        errorMessage = "Unable to fetch full doctor list. Showing registered doctor only."
                    }
                    // Only show error if we have no doctors at all
                    if self?.doctors.isEmpty ?? true {
                        self?.showAlert(title: "Note", message: errorMessage)
                    }
                    self?.updateCountBadge()
                    self?.emptyStateContainer.isHidden = !(self?.doctors.isEmpty ?? true)
                }
            }
        }
    }
    
    private func updateCountBadge() {
        let count = doctors.count
        countLabel.text = "\(count) \(count == 1 ? "Doctor" : "Doctors")"
        
        // Animate badge update
        UIView.animate(withDuration: 0.2, animations: {
            self.countBadge.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.countBadge.transform = .identity
            }
        }
    }
    
    private func animateCellsOnAppear() {
        let cells = tableView.visibleCells
        for (index, cell) in cells.enumerated() {
            cell.alpha = 0
            cell.transform = CGAffineTransform(translationX: 0, y: 20)
            
            UIView.animate(withDuration: 0.5, delay: Double(index) * 0.05, options: .curveEaseOut) {
                cell.alpha = 1
                cell.transform = .identity
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDashboard",
           let dashboardVC = segue.destination as? DashboardViewController,
           let doctorId = sender as? String {
            dashboardVC.doctorId = doctorId
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension DoctorListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorCell", for: indexPath) as! DoctorTableViewCell
        cell.configure(with: doctors[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DoctorListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let doctor = doctors[indexPath.row]
        
        // Navigate to dashboard with doctor details using segue
        performSegue(withIdentifier: "showDashboard", sender: doctor.id)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Add subtle animation when scrolling
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 10)
        
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
            cell.transform = .identity
        }
    }
}

// MARK: - DoctorTableViewCell
class DoctorTableViewCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.08
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Profile icon container
    private let profileIconContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 28
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        imageView.tintColor = UIColor(red: 0.3, green: 0.5, blue: 0.95, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let idBadge: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.3, green: 0.5, blue: 0.95, alpha: 0.1)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = UIColor(red: 0.3, green: 0.5, blue: 0.95, alpha: 1.0)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "envelope.fill"))
        imageView.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let infoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.0)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let genderContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let genderIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.fill"))
        imageView.tintColor = UIColor(red: 0.3, green: 0.5, blue: 0.95, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let practiceContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let practiceIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.tintColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let practiceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let chevronIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        // Setup containers
        profileIconContainer.addSubview(profileIcon)
        idBadge.addSubview(idLabel)
        
        genderContainer.addSubview(genderIcon)
        genderContainer.addSubview(genderLabel)
        
        practiceContainer.addSubview(practiceIcon)
        practiceContainer.addSubview(practiceLabel)
        
        infoStackView.addArrangedSubview(genderContainer)
        // Practice container removed since API doesn't return practice years
        
        infoContainerView.addSubview(infoStackView)
        
        emailStackView.addArrangedSubview(emailIcon)
        emailStackView.addArrangedSubview(emailLabel)
        
        // Set content priorities to avoid constraint conflicts
        emailIcon.setContentHuggingPriority(.required, for: .horizontal)
        emailIcon.setContentCompressionResistancePriority(.required, for: .horizontal)
        emailLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        emailLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        contentView.addSubview(containerView)
        containerView.addSubview(profileIconContainer)
        containerView.addSubview(idBadge)
        containerView.addSubview(nameLabel)
        containerView.addSubview(emailStackView)
        containerView.addSubview(infoContainerView)
        containerView.addSubview(chevronIcon)
        
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // Profile icon
            profileIconContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            profileIconContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            profileIconContainer.widthAnchor.constraint(equalToConstant: 56),
            profileIconContainer.heightAnchor.constraint(equalToConstant: 56),
            
            profileIcon.centerXAnchor.constraint(equalTo: profileIconContainer.centerXAnchor),
            profileIcon.centerYAnchor.constraint(equalTo: profileIconContainer.centerYAnchor),
            profileIcon.widthAnchor.constraint(equalToConstant: 32),
            profileIcon.heightAnchor.constraint(equalToConstant: 32),
            
            // ID Badge (hidden but kept for potential future use)
            idBadge.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            idBadge.leadingAnchor.constraint(equalTo: profileIconContainer.trailingAnchor, constant: 16),
            idBadge.heightAnchor.constraint(equalToConstant: 0),
            idBadge.widthAnchor.constraint(equalToConstant: 0),
            
            idLabel.centerXAnchor.constraint(equalTo: idBadge.centerXAnchor),
            idLabel.centerYAnchor.constraint(equalTo: idBadge.centerYAnchor),
            idLabel.leadingAnchor.constraint(equalTo: idBadge.leadingAnchor, constant: 8),
            idLabel.trailingAnchor.constraint(equalTo: idBadge.trailingAnchor, constant: -8),
            
            // Name - positioned directly below profile icon
            nameLabel.topAnchor.constraint(equalTo: profileIconContainer.topAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: profileIconContainer.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: chevronIcon.leadingAnchor, constant: -12),
            
            // Email
            emailStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailStackView.leadingAnchor.constraint(equalTo: profileIconContainer.trailingAnchor, constant: 16),
            emailStackView.trailingAnchor.constraint(equalTo: chevronIcon.leadingAnchor, constant: -12),
            
            emailIcon.widthAnchor.constraint(equalToConstant: 14),
            emailIcon.heightAnchor.constraint(equalToConstant: 14),
            
            // Info container
            infoContainerView.topAnchor.constraint(equalTo: emailStackView.bottomAnchor, constant: 14),
            infoContainerView.leadingAnchor.constraint(equalTo: profileIconContainer.trailingAnchor, constant: 16),
            infoContainerView.trailingAnchor.constraint(equalTo: chevronIcon.leadingAnchor, constant: -12),
            infoContainerView.heightAnchor.constraint(equalToConstant: 36),
            infoContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            infoStackView.centerYAnchor.constraint(equalTo: infoContainerView.centerYAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 12),
            infoStackView.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -12),
            
            // Gender container
            genderIcon.leadingAnchor.constraint(equalTo: genderContainer.leadingAnchor),
            genderIcon.centerYAnchor.constraint(equalTo: genderContainer.centerYAnchor),
            genderIcon.widthAnchor.constraint(equalToConstant: 14),
            genderIcon.heightAnchor.constraint(equalToConstant: 14),
            
            genderLabel.leadingAnchor.constraint(equalTo: genderIcon.trailingAnchor, constant: 6),
            genderLabel.centerYAnchor.constraint(equalTo: genderContainer.centerYAnchor),
            genderLabel.trailingAnchor.constraint(equalTo: genderContainer.trailingAnchor),
            
            // Practice container removed - not showing practice years
            
            // Chevron
            chevronIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            chevronIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronIcon.widthAnchor.constraint(equalToConstant: 16),
            chevronIcon.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func configure(with doctor: Doctor) {
        // Name - ensure it's visible and set
        nameLabel.text = doctor.name.isEmpty ? "N/A" : doctor.name
        nameLabel.isHidden = false
        
        // Email
        emailLabel.text = doctor.email.isEmpty ? "N/A" : doctor.email
        
        // Gender
        let genderText = doctor.gender.isEmpty ? "N/A" : (doctor.gender == "M" ? "Male" : doctor.gender == "F" ? "Female" : "Other")
        genderLabel.text = genderText
        
        // Practice years not shown - API doesn't return this data
        
        // Hide ID badge completely
        idBadge.isHidden = true
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        UIView.animate(withDuration: 0.2) {
            if highlighted {
                self.containerView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                self.containerView.alpha = 0.9
            } else {
                self.containerView.transform = .identity
                self.containerView.alpha = 1.0
            }
        }
    }
}

