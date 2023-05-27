//
//  NewsViewController.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/24.
//

import UIKit
import SafariServices
import Combine

final class NewsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: - Properties
    let newsViewModel = NewsViewModel()
    var newsItems: [NewsItem] = []
    var newsCancellable: AnyCancellable?
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "채권/외환 뉴스"
        makeIndicator()
        setupTableView()
        fetchRSS()
        fetchNews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNews()
    }
    
    deinit {
        newsCancellable?.cancel()
    }
    
    // 테이블뷰 셋팅
    private func setupTableView() {
        newsTableView.dataSource = self
        newsTableView.delegate = self
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.estimatedRowHeight = 140
    }
    // MARK: - PrivateMethods
    
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
        let cell =
        newsTableView
            .dequeueReusableCell(
                withIdentifier: "NewsCell", for: indexPath
            ) as! NewsCell
        cell.accessoryType = .disclosureIndicator
        cell.newsTitleLabel.text = newsItems[indexPath.row].title
        cell.descriptionLabel.text = newsItems[indexPath.row].description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        let data = newsItems[indexPath.row].pubDate
        let newsDate = dateFormatter.date(from: data)!
        let currentDate = Date()
        let components = Calendar
            .current
            .dateComponents(
                [.hour],
                from: newsDate,
                to: currentDate
            )
        if components.hour! < 2 {
            let components = Calendar
                .current
                .dateComponents([.minute], from: newsDate, to: currentDate)
            cell.releaseDateLabel.text = "\(String(describing: components.minute))분 전"

        }
        cell.releaseDateLabel.text = newsItems[indexPath.row].pubDate
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
