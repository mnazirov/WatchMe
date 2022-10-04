//
//  FilmCell.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import UIKit

class FilmCell: UITableViewCell {

    // MARK: Private UI properties
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var nameRuLabel: UILabel!
    @IBOutlet private weak var nameEnLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var countRating: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    
    // MARK: - Private properties
    private var film: Film?
    private let networkManager = NetworkManager()
    private let cache = Cache<String, UIImage>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Configuration
    func configure(_ film: Film, andTag row: Int) {
        clearData()
        
        self.film = film
        
        nameRuLabel.text = film.nameRu
        
        if let nameEn = film.nameEn {
            nameEnLabel.text = film.year.isNotEmpty() ? "\(nameEn) (\(film.year))" : nil
        } else {
            nameEnLabel.text = film.year.isNotEmpty() ? "(\(film.year))" : nil
        }
        
        var genres = [String]()
        film.genres?.forEach({ genres.append(($0 as? Genre)?.genre ?? "") })
        genresLabel.text = genres.joined(separator: ", ")
        
        if let rating = film.rating,
           rating.isNotEmpty() {
            ratingLabel.text = film.rating
            ratingLabel.textColor = colorRatingDefinition(film.rating)
            countRating.text = "\(film.ratingVoteCount)"
        }
        
        var countries = [String]()
        film.countries?.forEach({ countries.append(($0 as? Country)?.country ?? "") })
        countryLabel.text = countries.joined(separator: ", ") + " " + (film.filmLength ?? "")
        
        guard let posterUrl = film.posterUrl else { return }
        
        let activityIndicator = UIActivityIndicatorView()
        coverImageView.addSubview(activityIndicator)
        coverImageView.addInCenter(subview: activityIndicator)
        activityIndicator.startAnimating()
        
        networkManager.getImage(path: posterUrl) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(image):        
                DispatchQueue.main.async {
                    if self.tag == row {
                        self.coverImageView.image = image
                    }
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
            activityIndicator.stopAnimating()
        }
    }
    
    private func setupUI() {
        coverImageView.layer.cornerRadius = Layout.imageCornerRadius
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        coverImageView.backgroundColor = UIColor.systemGray6

        nameRuLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nameRuLabel.textColor = .label
        
        nameEnLabel.font = .systemFont(ofSize: 14, weight: .regular)
        nameEnLabel.textColor = .label
        
        genresLabel.font = .systemFont(ofSize: 12, weight: .light)
        genresLabel.textColor = .secondaryLabel
        
        ratingLabel.font = .systemFont(ofSize: 16, weight: .bold)
        ratingLabel.textColor = .secondaryLabel
        
        countRating.font = .systemFont(ofSize: 12, weight: .regular)
        countRating.textColor = .secondaryLabel
        
        countryLabel.font = .systemFont(ofSize: 12, weight: .light)
        countryLabel.textColor = .label
        countryLabel.textAlignment = .right
    }
    
    private func clearData() {
        film = nil
        coverImageView.image = nil
        nameRuLabel.text = nil
        genresLabel.text = nil
        ratingLabel.text = nil
        countRating.text = nil
        countryLabel.text = nil
        countRating.textColor = nil
    }
    
    private func colorRatingDefinition(_ value: String?) -> UIColor? {
        guard let value = value,
              let number = Double(value) else {
            return nil
        }
        
        switch number {
        case 7...: return UIColor.systemGreen
        case 5...7: return UIColor.secondaryLabel
        default: return UIColor.systemRed
        }
    }
}

private extension FilmCell {
    
    enum Layout {
        static let imageCornerRadius: CGFloat = 5
    }
}
