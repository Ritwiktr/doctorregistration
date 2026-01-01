import UIKit

class DashboardViewController: UIViewController {
    
    var doctorId: String?
    
    // Animated gradient background views
    private var animatedGradientLayer: CAGradientLayer?
    private var floatingCircles: [UIView] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            // Configure scrollView when outlet is set
            scrollView.showsVerticalScrollIndicator = false
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Animated header container
    private let headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 32
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello,"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let doctorNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Doctor"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let notificationBadge: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.08
        view.layer.shadowRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search..."
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Banner scroll view for swipeable widgets
    private let bannerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.decelerationRate = .fast
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let bannerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Page control
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 3
        control.currentPage = 0
        control.pageIndicatorTintColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.6)
        control.currentPageIndicatorTintColor = UIColor(red: 0.3, green: 0.5, blue: 0.95, alpha: 1.0)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    // Banner 1: Stay Safe Stay Healthy
    private let bannerView1: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.12
        view.layer.shadowRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bannerGradientLayer1: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.4, green: 0.5, blue: 0.95, alpha: 1.0).cgColor,
            UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 1.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 20
        return gradient
    }()
    
    private let bannerTitleLabel1: UILabel = {
        let label = UILabel()
        label.text = "Stay Safe\nStay Healthy!"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bannerSubtitleLabel1: UILabel = {
        let label = UILabel()
        label.text = "An apple a day keeps the doctor away."
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.9)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Banner 2: Health Tips
    private let bannerView2: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.12
        view.layer.shadowRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bannerGradientLayer2: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0).cgColor,
            UIColor(red: 1.0, green: 0.4, blue: 0.3, alpha: 1.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 20
        return gradient
    }()
    
    private let bannerTitleLabel2: UILabel = {
        let label = UILabel()
        label.text = "Prevention is\nBetter Than Cure"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bannerSubtitleLabel2: UILabel = {
        let label = UILabel()
        label.text = "Regular check-ups and vaccinations keep you protected."
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.9)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Banner 3: Medical Care
    private let bannerView3: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.12
        view.layer.shadowRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bannerGradientLayer3: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.2, green: 0.7, blue: 0.5, alpha: 1.0).cgColor,
            UIColor(red: 0.3, green: 0.6, blue: 0.8, alpha: 1.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 20
        return gradient
    }()
    
    private let bannerTitleLabel3: UILabel = {
        let label = UILabel()
        label.text = "Stay Hydrated\nStay Active"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bannerSubtitleLabel3: UILabel = {
        let label = UILabel()
        label.text = "Drink plenty of water and exercise daily for optimal health."
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.9)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var bannerWidth: CGFloat = 0
    
    private let servicesLabel: UILabel = {
        let label = UILabel()
        label.text = "At your Fingertip"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let servicesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Extend edges behind status bar
        edgesForExtendedLayout = .top
        
        setupUI()
        setupAnimations()
        loadDoctorDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradientFrames()
        updateBannerScrollView()
    }
    
    private func setupUI() {
        // Background gradient
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 1.0, alpha: 1.0)
        
        // Setup animated header background
        setupAnimatedHeader()
        
        // Add contentView to scrollView (scrollView is connected from storyboard)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerContainerView)
        headerContainerView.addSubview(profileImageView)
        headerContainerView.addSubview(greetingLabel)
        headerContainerView.addSubview(doctorNameLabel)
        headerContainerView.addSubview(notificationButton)
        notificationButton.addSubview(notificationBadge)
        
        contentView.addSubview(searchContainerView)
        searchContainerView.addSubview(searchIconView)
        searchContainerView.addSubview(searchTextField)
        
        // Setup swipeable banners
        contentView.addSubview(bannerScrollView)
        bannerScrollView.addSubview(bannerContainerView)
        
        // Banner 1
        bannerView1.layer.insertSublayer(bannerGradientLayer1, at: 0)
        bannerView1.addSubview(bannerTitleLabel1)
        bannerView1.addSubview(bannerSubtitleLabel1)
        bannerContainerView.addSubview(bannerView1)
        
        // Banner 2
        bannerView2.layer.insertSublayer(bannerGradientLayer2, at: 0)
        bannerView2.addSubview(bannerTitleLabel2)
        bannerView2.addSubview(bannerSubtitleLabel2)
        bannerContainerView.addSubview(bannerView2)
        
        // Banner 3
        bannerView3.layer.insertSublayer(bannerGradientLayer3, at: 0)
        bannerView3.addSubview(bannerTitleLabel3)
        bannerView3.addSubview(bannerSubtitleLabel3)
        bannerContainerView.addSubview(bannerView3)
        
        // Page control
        contentView.addSubview(pageControl)
        
        contentView.addSubview(servicesLabel)
        contentView.addSubview(servicesStackView)
        
        setupServicesGrid()
        setupBannerScrollView()
        
        // Set up constraints for contentView and all subviews
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header container with animated background - extend to top
            headerContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerContainerView.heightAnchor.constraint(equalToConstant: 200),
            
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 64),
            profileImageView.heightAnchor.constraint(equalToConstant: 64),
            
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            greetingLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            
            doctorNameLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 4),
            doctorNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            
            notificationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            notificationButton.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -20),
            notificationButton.widthAnchor.constraint(equalToConstant: 44),
            notificationButton.heightAnchor.constraint(equalToConstant: 44),
            
            notificationBadge.topAnchor.constraint(equalTo: notificationButton.topAnchor, constant: 6),
            notificationBadge.trailingAnchor.constraint(equalTo: notificationButton.trailingAnchor, constant: -6),
            notificationBadge.widthAnchor.constraint(equalToConstant: 10),
            notificationBadge.heightAnchor.constraint(equalToConstant: 10),
            
            searchContainerView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -30),
            searchContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            searchContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            searchContainerView.heightAnchor.constraint(equalToConstant: 56),
            
            searchIconView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 16),
            searchIconView.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchIconView.widthAnchor.constraint(equalToConstant: 20),
            searchIconView.heightAnchor.constraint(equalToConstant: 20),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchIconView.trailingAnchor, constant: 12),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -16),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            
            // Banner scroll view
            bannerScrollView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 24),
            bannerScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerScrollView.heightAnchor.constraint(equalToConstant: 160),
            
            bannerContainerView.topAnchor.constraint(equalTo: bannerScrollView.topAnchor),
            bannerContainerView.leadingAnchor.constraint(equalTo: bannerScrollView.leadingAnchor),
            bannerContainerView.bottomAnchor.constraint(equalTo: bannerScrollView.bottomAnchor),
            bannerContainerView.heightAnchor.constraint(equalTo: bannerScrollView.heightAnchor),
            bannerContainerView.widthAnchor.constraint(equalTo: bannerScrollView.widthAnchor, multiplier: 3),
            
            // Banner 1
            bannerView1.topAnchor.constraint(equalTo: bannerContainerView.topAnchor),
            bannerView1.leadingAnchor.constraint(equalTo: bannerContainerView.leadingAnchor, constant: 20),
            bannerView1.widthAnchor.constraint(equalTo: bannerScrollView.widthAnchor, constant: -40),
            bannerView1.heightAnchor.constraint(equalToConstant: 160),
            
            bannerTitleLabel1.topAnchor.constraint(equalTo: bannerView1.topAnchor, constant: 24),
            bannerTitleLabel1.leadingAnchor.constraint(equalTo: bannerView1.leadingAnchor, constant: 24),
            bannerTitleLabel1.trailingAnchor.constraint(equalTo: bannerView1.trailingAnchor, constant: -24),
            
            bannerSubtitleLabel1.topAnchor.constraint(equalTo: bannerTitleLabel1.bottomAnchor, constant: 8),
            bannerSubtitleLabel1.leadingAnchor.constraint(equalTo: bannerView1.leadingAnchor, constant: 24),
            bannerSubtitleLabel1.trailingAnchor.constraint(equalTo: bannerView1.trailingAnchor, constant: -24),
            
            // Banner 2
            bannerView2.topAnchor.constraint(equalTo: bannerContainerView.topAnchor),
            bannerView2.leadingAnchor.constraint(equalTo: bannerView1.trailingAnchor, constant: 20),
            bannerView2.widthAnchor.constraint(equalTo: bannerScrollView.widthAnchor, constant: -40),
            bannerView2.heightAnchor.constraint(equalToConstant: 160),
            
            bannerTitleLabel2.topAnchor.constraint(equalTo: bannerView2.topAnchor, constant: 24),
            bannerTitleLabel2.leadingAnchor.constraint(equalTo: bannerView2.leadingAnchor, constant: 24),
            bannerTitleLabel2.trailingAnchor.constraint(equalTo: bannerView2.trailingAnchor, constant: -24),
            
            bannerSubtitleLabel2.topAnchor.constraint(equalTo: bannerTitleLabel2.bottomAnchor, constant: 8),
            bannerSubtitleLabel2.leadingAnchor.constraint(equalTo: bannerView2.leadingAnchor, constant: 24),
            bannerSubtitleLabel2.trailingAnchor.constraint(equalTo: bannerView2.trailingAnchor, constant: -24),
            
            // Banner 3
            bannerView3.topAnchor.constraint(equalTo: bannerContainerView.topAnchor),
            bannerView3.leadingAnchor.constraint(equalTo: bannerView2.trailingAnchor, constant: 20),
            bannerView3.widthAnchor.constraint(equalTo: bannerScrollView.widthAnchor, constant: -40),
            bannerView3.heightAnchor.constraint(equalToConstant: 160),
            
            bannerTitleLabel3.topAnchor.constraint(equalTo: bannerView3.topAnchor, constant: 24),
            bannerTitleLabel3.leadingAnchor.constraint(equalTo: bannerView3.leadingAnchor, constant: 24),
            bannerTitleLabel3.trailingAnchor.constraint(equalTo: bannerView3.trailingAnchor, constant: -24),
            
            bannerSubtitleLabel3.topAnchor.constraint(equalTo: bannerTitleLabel3.bottomAnchor, constant: 8),
            bannerSubtitleLabel3.leadingAnchor.constraint(equalTo: bannerView3.leadingAnchor, constant: 24),
            bannerSubtitleLabel3.trailingAnchor.constraint(equalTo: bannerView3.trailingAnchor, constant: -24),
            
            // Page control
            pageControl.topAnchor.constraint(equalTo: bannerScrollView.bottomAnchor, constant: 12),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            servicesLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 24),
            servicesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            servicesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            servicesStackView.topAnchor.constraint(equalTo: servicesLabel.bottomAnchor, constant: 20),
            servicesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            servicesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            servicesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Animate elements on appear
        animateViewsOnAppear()
    }
    
    private func setupAnimatedHeader() {
        // Create animated gradient layer
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.3, green: 0.5, blue: 0.95, alpha: 1.0).cgColor,
            UIColor(red: 0.5, green: 0.4, blue: 0.9, alpha: 1.0).cgColor,
            UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        animatedGradientLayer = gradient
        headerContainerView.layer.insertSublayer(gradient, at: 0)
        
        // Create floating circles
        createFloatingCircles()
    }
    
    private func createFloatingCircles() {
        let circleSizes: [CGFloat] = [80, 60, 100, 70, 50]
        let circleColors: [UIColor] = [
            UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 0.15),
            UIColor(red: 0.5, green: 0.4, blue: 0.95, alpha: 0.12),
            UIColor(red: 0.3, green: 0.5, blue: 0.9, alpha: 0.18),
            UIColor(red: 0.6, green: 0.5, blue: 1.0, alpha: 0.1),
            UIColor(red: 0.4, green: 0.7, blue: 1.0, alpha: 0.14)
        ]
        
        for (index, size) in circleSizes.enumerated() {
            let circle = UIView()
            circle.backgroundColor = circleColors[index]
            circle.layer.cornerRadius = size / 2
            circle.translatesAutoresizingMaskIntoConstraints = false
            headerContainerView.addSubview(circle)
            floatingCircles.append(circle)
            
            // Random positions
            let xPosition = CGFloat.random(in: -50...UIScreen.main.bounds.width + 50)
            let yPosition = CGFloat.random(in: -50...150)
            
            NSLayoutConstraint.activate([
                circle.widthAnchor.constraint(equalToConstant: size),
                circle.heightAnchor.constraint(equalToConstant: size),
                circle.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: xPosition),
                circle.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: yPosition)
            ])
        }
    }
    
    private func setupAnimations() {
        // Animate gradient
        animateGradient()
        
        // Animate floating circles
        animateFloatingCircles()
    }
    
    private func animateGradient() {
        guard let gradient = animatedGradientLayer else { return }
        
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [
            UIColor(red: 0.3, green: 0.5, blue: 0.95, alpha: 1.0).cgColor,
            UIColor(red: 0.5, green: 0.4, blue: 0.9, alpha: 1.0).cgColor,
            UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0).cgColor
        ]
        animation.toValue = [
            UIColor(red: 0.5, green: 0.4, blue: 0.9, alpha: 1.0).cgColor,
            UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0).cgColor,
            UIColor(red: 0.3, green: 0.5, blue: 0.95, alpha: 1.0).cgColor
        ]
        animation.duration = 4.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: "colorAnimation")
    }
    
    private func animateFloatingCircles() {
        for (index, circle) in floatingCircles.enumerated() {
            let delay = Double(index) * 0.3
            
            UIView.animate(withDuration: 3.0 + Double(index) * 0.5,
                         delay: delay,
                         options: [.repeat, .autoreverse, .curveEaseInOut],
                         animations: {
                circle.transform = CGAffineTransform(translationX: CGFloat.random(in: -30...30),
                                                    y: CGFloat.random(in: -20...20))
                circle.alpha = 0.3
            })
        }
    }
    
    private func updateGradientFrames() {
        animatedGradientLayer?.frame = headerContainerView.bounds
        bannerGradientLayer1.frame = bannerView1.bounds
        bannerGradientLayer2.frame = bannerView2.bounds
        bannerGradientLayer3.frame = bannerView3.bounds
    }
    
    private func setupBannerScrollView() {
        bannerScrollView.delegate = self
    }
    
    private func updateBannerScrollView() {
        // Width constraint is already set up with multiplier, no need to update
        // Just ensure scroll view is properly configured
        bannerScrollView.contentSize = CGSize(width: view.bounds.width * 3, height: 160)
    }
    
    private func animateViewsOnAppear() {
        // Animate profile and header elements
        profileImageView.alpha = 0
        greetingLabel.alpha = 0
        doctorNameLabel.alpha = 0
        notificationButton.alpha = 0
        
        UIView.animate(withDuration: 0.6, delay: 0.1, options: .curveEaseOut) {
            self.profileImageView.alpha = 1
            self.profileImageView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.2, options: .curveEaseOut) {
            self.greetingLabel.alpha = 1
            self.doctorNameLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.3, options: .curveEaseOut) {
            self.notificationButton.alpha = 1
        }
        
        // Animate search bar
        searchContainerView.transform = CGAffineTransform(translationX: 0, y: 20)
        searchContainerView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.searchContainerView.transform = .identity
            self.searchContainerView.alpha = 1
        }
        
        // Animate banners
        bannerScrollView.transform = CGAffineTransform(translationX: 0, y: 20)
        bannerScrollView.alpha = 0
        pageControl.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.bannerScrollView.transform = .identity
            self.bannerScrollView.alpha = 1
            self.pageControl.alpha = 1
        }
        
        // Animate services
        servicesLabel.alpha = 0
        servicesStackView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.6, options: .curveEaseOut) {
            self.servicesLabel.alpha = 1
            self.servicesStackView.alpha = 1
        }
    }
    
    private func setupServicesGrid() {
        let services = [
            ("qrcode.viewfinder", "Scan", UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)),
            ("syringe", "Vaccine", .white),
            ("calendar", "My Bookings", .white),
            ("building.2", "Clinic", .white),
            ("cross.case", "Ambulance", .white),
            ("person.2", "Nurse", .white)
        ]
        
        let row1 = UIStackView()
        row1.axis = .horizontal
        row1.distribution = .fillEqually
        row1.spacing = 16
        
        let row2 = UIStackView()
        row2.axis = .horizontal
        row2.distribution = .fillEqually
        row2.spacing = 16
        
        for (index, (iconName, title, backgroundColor)) in services.enumerated() {
            let button = createServiceButton(icon: iconName, title: title, backgroundColor: backgroundColor)
            
            if index < 3 {
                row1.addArrangedSubview(button)
            } else {
                row2.addArrangedSubview(button)
            }
        }
        
        servicesStackView.addArrangedSubview(row1)
        servicesStackView.addArrangedSubview(row2)
    }
    
    private func createServiceButton(icon: String, title: String, backgroundColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Enhanced shadow for white buttons
        if backgroundColor == .white {
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 0.06
            button.layer.shadowRadius = 8
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        } else {
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
            button.layer.shadowOpacity = 0.15
            button.layer.shadowRadius = 12
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(systemName: icon))
        imageView.tintColor = backgroundColor == .white ? UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0) : .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = backgroundColor == .white ? UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0) : .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        button.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 36),
            imageView.heightAnchor.constraint(equalToConstant: 36),
            button.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        // Add press animation
        button.addTarget(self, action: #selector(serviceButtonPressed(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(serviceButtonReleased(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }
    
    @objc private func serviceButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func serviceButtonReleased(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
        }
    }
    
    private func loadDoctorDetails() {
        guard let doctorId = doctorId else {
            showAlert(title: "Error", message: "Doctor ID not available")
            return
        }
        
        activityIndicator.startAnimating()
        
        APIService.shared.getDoctorById(doctorId: doctorId) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let doctor):
                    let name = doctor.name.isEmpty ? "Doctor" : doctor.name
                    UIView.transition(with: self?.doctorNameLabel ?? UILabel(), duration: 0.3, options: .transitionCrossDissolve) {
                        self?.doctorNameLabel.text = "\(name)!"
                    }
                case .failure(let error):
                    print("⚠️ Could not fetch doctor details: \(error.localizedDescription)")
                    // Keep default name if fetch fails
                    self?.doctorNameLabel.text = "Doctor!"
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

// MARK: - UIScrollViewDelegate
extension DashboardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bannerScrollView {
            let pageWidth = view.bounds.width - 40 + 20 // bannerWidth + spacing
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            pageControl.currentPage = min(max(currentPage, 0), 2)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == bannerScrollView {
            let pageWidth = view.bounds.width - 40 + 20
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            let clampedPage = min(max(currentPage, 0), 2)
            let targetX = CGFloat(clampedPage) * pageWidth
            scrollView.setContentOffset(CGPoint(x: targetX, y: 0), animated: true)
        }
    }
}

