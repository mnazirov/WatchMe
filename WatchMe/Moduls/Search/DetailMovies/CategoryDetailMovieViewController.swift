//
//  CategoryDetailMovieViewController.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import UIKit
import SafariServices

final class CategoryDetailMovieViewController: UIViewController {
    
    private lazy var networkManager = NetworkManager()
    private lazy var dataManager: DataManagering = DataBaseManager()
    
    private var film: DetailFilm?
        
    // MARK: - Private propertis
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.layoutMargins = Layout.insets
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = Layout.Container.spacingH1
        return stackView
    }()
    
    private lazy var headStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .horizontal
        stackView.spacing = Layout.Container.spacingH1
        return stackView
    }()
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Layout.CoverImageView.backgroundColor
        imageView.layer.cornerRadius = Layout.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.sizeToFit()
        return imageView
    }()
    
    private lazy var nameRuLabel: UILabel = {
        let label = UILabel()
        label.textColor = Layout.NameLabel.textColor
        label.font = Layout.NameLabel.fontRu
        return label
    }()
    
    private lazy var nameEnLabel: UILabel = {
        let label = UILabel()
        label.textColor = Layout.NameLabel.textColor
        label.font = Layout.NameLabel.fontEn
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.textColor = Layout.SecondaryLabel.textColor
        label.font = Layout.SecondaryLabel.font
        label.numberOfLines = Layout.SecondaryLabel.numberOfLines
        return label
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = Layout.SecondaryLabel.textColor
        label.font = Layout.SecondaryLabel.font
        return label
    }()
    
    private lazy var sloganLabel: UILabel = {
        let label = UILabel()
        label.textColor = Layout.SloganLabel.textColor
        label.font = Layout.SloganLabel.font
        label.numberOfLines = Layout.unlimitedLine
        return label
    }()
    
    private lazy var watchButton: UIButton = {
        let button = GradientButton(colors: [
            UIColor.systemBlue.cgColor,
            UIColor.systemTeal.cgColor])
        button.setTitle(Layout.WatchButton.text, for: .normal)
        button.setImage(UIImage(systemName: Layout.WatchButton.imageName),
                        for: .normal)
        button.tintColor = Layout.WatchButton.imageColor
        button.adjustsImageWhenHighlighted = false
        button.titleEdgeInsets = Layout.WatchButton.insets
        button.layer.cornerRadius = Layout.cornerRadius
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(watchButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Layout.DescriptionLabel.textColor
        label.font = Layout.DescriptionLabel.font
        label.numberOfLines = Layout.unlimitedLine
        return label
    }()
        
    // MARK: - Initialization
    init(id: Int) {
        super.init(nibName: nil, bundle: nil)
        fetchFilm(id: id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()        
        setupUI()
    }
}

// MARK: - Private methods
private extension CategoryDetailMovieViewController {
    
    func updateUI(_ model: DetailFilm) {
        nameRuLabel.text = model.nameRu
        nameEnLabel.text = model.nameEn == nil
        ? "(\(model.year))"
        : "\(model.nameEn ?? "") (\(model.year))"
        
        var genres = [String]()
        model.genres.forEach({ genres.append(($0 as? Genre)?.genre ?? "") })
        genresLabel.text = genres.joined(separator: ", ")
                
        var cities = [String]()
        model.countries.forEach({ cities.append(($0 as? Country)?.country ?? "") })
        cityLabel.text = cities.joined(separator: ", ")
        + (model.filmLength == nil ? "" : ", \(model.filmLength ?? "") мин.")
        
        sloganLabel.text = model.slogan != nil ? "\"" + (model.slogan ?? "") + "\"" : nil
        
        descriptionLabel.text = model.desc
        
        guard let imageUrl = model.posterUrl else { return view.layoutIfNeeded() }
        
        let activityIndicator = UIActivityIndicatorView()
        coverImageView.addSubview(activityIndicator)
        coverImageView.addInCenter(subview: activityIndicator)
        activityIndicator.startAnimating()
        networkManager.getImage(path: imageUrl) { [weak self] result in
            switch result {
            case let .success(image):
                self?.coverImageView.image = image
                self?.view.layoutIfNeeded()
            case let .failure(error):
                print("WARNING: Error on network request \(error)")
            }
            activityIndicator.stopAnimating()
        }
    }
    
    func setupUI() {
        view.backgroundColor = Layout.backgroundColor
        setupScrollView()
        setupStackView()
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func setupStackView() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            mainStackView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            mainStackView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor)
        ])
        
        setupHeadStackView()
        setupButton()
        setupDescriptionLabel()
    }
    
    func setupHeadStackView() {
        mainStackView.addArrangedSubview(headStackView)
        
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coverImageView.widthAnchor.constraint(equalToConstant: Layout.CoverImageView.size.width),
            coverImageView.heightAnchor.constraint(equalToConstant: Layout.CoverImageView.size.height),
        ])
        
        let containerStackView = UIStackView()
        containerStackView.alignment = .fill
        containerStackView.axis = .vertical
        containerStackView.spacing = Layout.Container.spacingH2
        
        containerStackView.addArrangedSubview(nameRuLabel)
        containerStackView.addArrangedSubview(nameEnLabel)
        containerStackView.addArrangedSubview(genresLabel)
        containerStackView.addArrangedSubview(cityLabel)
        containerStackView.addArrangedSubview(sloganLabel)
        
        containerStackView.setCustomSpacing(Layout.Container.spacingH3,
                                            after: nameRuLabel)
        containerStackView.setCustomSpacing(Layout.Container.lackSpacing,
                                            after: genresLabel)
        
        headStackView.addArrangedSubview(coverImageView)
        headStackView.addArrangedSubview(containerStackView)
    }
    
    func setupButton() {
        mainStackView.addArrangedSubview(watchButton)
        NSLayoutConstraint.activate([
            watchButton.heightAnchor.constraint(equalToConstant: Layout.WatchButton.height)
        ])
    }
    
    func setupDescriptionLabel() {
        mainStackView.addArrangedSubview(descriptionLabel)
    }
    
    func fetchFilm(id: Int) {
        
        let model = dataManager.fetch(entity: DetailFilm.self)
        
        if let filterModel = model.first(where: { $0.filmId == id }) {
            film = filterModel
            DispatchQueue.main.async {
                self.updateUI(filterModel)
            }
            
        } else {
            networkManager.getFilm(id: id) { [weak self] result in
                switch result {
                case let .success(film):
                    self?.film = film
                    DispatchQueue.main.async {
                        self?.updateUI(film)
                    }
                case let .failure(error):
                    print(error.rawValue)
                }
            }
        }
    }
    
    // MARK: Actions
    @objc func watchButtonTap() {
        guard let webUrl = film?.webUrl else { return }
        guard let url = URL(string: webUrl) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

// MARK: - Layout
private extension CategoryDetailMovieViewController {
    
    enum Layout {
        static let backgroundColor = UIColor.systemBackground
        static let cornerRadius: CGFloat = 10
        static let unlimitedLine = 0
        static let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        enum Container {
            static let spacingH1: CGFloat = 25
            static let spacingH2: CGFloat = 15
            static let spacingH3: CGFloat = 5
            static let lackSpacing: CGFloat = 0
        }
        
        enum CoverImageView {
            static let backgroundColor = UIColor.systemGray6
            static let size = CGSize(width: 110, height: 150)
        }
        
        enum NameLabel {
            static let textColor = UIColor.label
            static let fontRu = UIFont.systemFont(ofSize: 20, weight: .semibold)
            static let fontEn = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
        
        enum SecondaryLabel {
            static let textColor = UIColor.systemGray
            static let font = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let numberOfLines = 3
        }
        
        enum SloganLabel {
            static let textColor = UIColor.systemGray
            static let font = UIFont.italicSystemFont(ofSize: 16, weight: .regular)
        }
        
        enum WatchButton {
            static let text = "Смотреть по подписке"
            static let imageName = "play.fill"
            static let height: CGFloat = 46
            static let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            static let imageColor: UIColor = .white
        }
        
        enum DescriptionLabel {
            static let textColor = UIColor.label
            static let font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
}
