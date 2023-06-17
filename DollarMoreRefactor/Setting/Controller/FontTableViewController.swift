//
//  FontTableViewController.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/06/15.
//

import UIKit

final class FontTableViewController: UITableViewController {
    // MARK: - Properties
    private lazy var headerView = FontExampleHeaderView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: 100))

    private var selectedIndex = UserFont.customFont
    
    private var fontNames = ["기본 크기",
                             "작은 크기",
                             "중간1 크기",
                             "중간2 크기",
                             "큰 크기"]

    // MARK: - Life cycle
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            FontTableViewCell.self,
            forCellReuseIdentifier: FontTableViewCell.identifier
        )
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .secondaryLabel
        tableView.sectionHeaderTopPadding = 20
        tableView.allowsMultipleSelection = false
        
    }
    
    // MARK: - Helpers
    func applyFontToExampleText(index: Int) {
        headerView.changeTextFont(size: CGFloat(index))
    }
    
    func saveFontIndex(index: Int) {
        UserFont.customFont = index // 인덱스 저장
    }

    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // the number of fonts
        return CustomFont.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: FontTableViewCell.identifier, for: indexPath) as! FontTableViewCell
            cell.fontNameLabel.text = fontNames[indexPath.row]
            cell.fontNameLabel.font = .systemFont(ofSize: CGFloat(17 + indexPath.row), weight: .medium)
            return cell
    }

    // MARK: - Table view Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndex != indexPath.row {
            tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0))?.isSelected = false
            selectedIndex = indexPath.row
            applyFontToExampleText(index: indexPath.row)
            saveFontIndex(index: indexPath.row)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == selectedIndex {
            cell.isSelected = true
            applyFontToExampleText(index: indexPath.row)
        }
    }
}
