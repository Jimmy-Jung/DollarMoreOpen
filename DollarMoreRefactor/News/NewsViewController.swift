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
    
    @IBOutlet weak var newsTableView: UITableView!
    let newsViewModel = NewsViewModel()
    var newsItems: [NewsItem] = []
    lazy var newsCancellable = newsViewModel.$newsItems.sink {
        self.newsItems = $0 ?? []
        self.newsTableView.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "채권/외환 뉴스"
        setupTableView()
        Task{ await fetchNews() }
    }
       // 테이블뷰 셋팅
    private func setupTableView() {
        newsTableView.dataSource = self
        newsTableView.delegate = self
    }
    
    private func fetchNews() async {
        await newsViewModel.updateNews()
        print(newsItems)
    }
    
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        cell.accessoryType = .disclosureIndicator
        cell.newsTitleLabel.text = newsItems[indexPath.row].title
        cell.descriptionLabel.text = newsItems[indexPath.row].description
        cell.releaseDateLabel.text = newsItems[indexPath.row].pubDate
        cell.newsLink = newsItems[indexPath.row].link
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = "https://www.apple.com"
                if let url = URL(string: urlString) {
                    let safariViewController = SFSafariViewController(url: url)
                    present(safariViewController, animated: true, completion: nil)
                }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
