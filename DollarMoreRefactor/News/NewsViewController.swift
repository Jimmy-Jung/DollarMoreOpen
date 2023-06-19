//
//  NewsViewController.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/24.
//

import UIKit
import SafariServices
import Combine
import GoogleMobileAds

final class NewsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var googleBannerView: GADBannerView!
    @IBOutlet weak var googleBannerWidth: NSLayoutConstraint!
    @IBOutlet weak var googleBannerHeight: NSLayoutConstraint!
    
    private let bannerWidth: Double = 320.0
    private let bannerHeight: Double = 50.0
    private let bannerTestID = "ca-app-pub-3940256099942544/2934735716"
    private let bannerAdsID = "ca-app-pub-8259821332117247/3231681615"
    
    // MARK: - Properties
    let newsViewModel = NewsViewModel()
    var newsItems: [NewsItem] = []
    var newsCancellable: AnyCancellable?
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "채권/외환 뉴스"
        fetchGoogleBanner()
        makeIndicator()
        setupTableView()
        fetchRSS()
        fetchNews()
        setupUIRefreshControl()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNews()
        googleBannerView.load(GADRequest())
        newsTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        newsCancellable?.cancel()
    }
    
    /// 당겨서 새로고침 만들기
    private func setupUIRefreshControl() {
        // UIRefreshControl 생성
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshRSS), for: .valueChanged)
            newsTableView.refreshControl = refreshControl
    }
    // 아래로 당겨서 새로고침 메서드
    @objc private func refreshRSS() {
        newsViewModel.fetchRSS()
        newsTableView.refreshControl?.endRefreshing()
    }
    
    // 테이블뷰 셋팅
    private func setupTableView() {
        newsTableView.dataSource = self
        newsTableView.delegate = self
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.estimatedRowHeight = 140
    }
    // MARK: - PrivateMethods
    /// 구글 광고 배너 만들기
    private func fetchGoogleBanner() {
        googleBannerView.adUnitID = bannerAdsID
        googleBannerView.rootViewController = self
        googleBannerView.load(GADRequest())
        googleBannerWidth.constant = view.frame.width
        googleBannerHeight.constant = GADAdSizeLargeBanner.size.height
        googleBannerView.delegate = self
    }
    
    
    /// RSS데이터 가져오기
    private func fetchRSS() {
        activityIndicator.startAnimating()
        newsViewModel.fetchRSS()
    }
    
    /// 뉴스아이템 가져오기
    private func fetchNews() {
        newsCancellable =
        newsViewModel
            .$newsItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.newsItems = items ?? []
                self?.newsTableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.activityIndicator.stopAnimating()
                }
            }
    }
    /// 인디케이터 만들기
    private func makeIndicator() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    // MARK: - Actions
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        fetchRSS()
    }
    
}
// MARK: - TableViewDelegate
extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return newsItems.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let selectedIndex = UserFont.customFont
        let cell = newsTableView.dequeueReusableCell(
            withIdentifier: "NewsCell",
            for: indexPath) as! NewsCell
        
        cell.accessoryType = .disclosureIndicator
        cell.newsTitleLabel.text = newsItems[indexPath.row].title
        cell.descriptionLabel.text = newsItems[indexPath.row].description
        
        cell.newsTitleLabel.font = .systemFont(ofSize: CGFloat(16 + selectedIndex), weight: .heavy)
        cell.descriptionLabel.font = .systemFont(ofSize: CGFloat(14 + selectedIndex), weight: .medium)
        cell.releaseDateLabel.font = .systemFont(ofSize: CGFloat(12 + selectedIndex), weight: .medium)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let data = newsItems[indexPath.row].pubDate
        let newsDate = dateFormatter.date(from: data)!
        let components = Calendar
            .current
            .dateComponents(
                [.minute, .hour, .day],
                from: newsDate,
                to: Date()
            )
        switch components {
        case let components where components.day != 0:
            cell.releaseDateLabel.text = "\(components.day!)일 전"
        case let components where components.day == 0 && components.hour != 0:
            cell.releaseDateLabel.text = "\(components.hour!)시간 전"
        case let components where components.hour == 0:
            cell.releaseDateLabel.text = "\(components.minute!)분 전"
        default:
            cell.releaseDateLabel.text = newsItems[indexPath.row].pubDate
        }
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let urlString = newsItems[indexPath.row].link
        if let url = URL(string: urlString) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - BannerDelegate
extension NewsViewController: GADBannerViewDelegate {
    
    /// 광고를 받은 다음에 반응
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        googleBannerView.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0.2,
            options: [.curveEaseInOut],
            animations: { [weak self] in
            self?.googleBannerView.alpha = 1
        })
    }
}
