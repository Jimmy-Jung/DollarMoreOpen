//
//  FontTableViewController.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/06/15.
//

import Foundation

import UIKit

final class FontTableViewController: UITableViewController {
    // MARK: - Properties
    private lazy var headerView = FontExampleHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 120))
    
    private var selectedIndex = UserFont.customFont
    
    private var fontNames = ["시스템",
                             "작은 글씨",
                             "중간 글씨",
                             "큰 글씨"]

    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        tableView.register(FontTableViewCell.self, forCellReuseIdentifier: FontTableViewCell.identifier)
        tableView.tableHeaderView = headerView
        tableView.allowsMultipleSelection = false
        setNavigationBarAppearance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    func applyFontToExampleText(index: Int) {
        if index == 0 {
            headerView.changeTextFont(font: .systemFont(ofSize: 20))
        } else {
            headerView.changeTextFont(font: UIFont(name: fontNames[index], size: 20)!)
        }
    }
    
    func saveFontIndex(index: Int) {
        UserFont.customFont = index // 인덱스 저장
    }

    // MARK: - Table view data source

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
        
        if indexPath.row == 0 {
            cell.fontNameLabel.font = .systemFont(ofSize: 17)
        } else {
            cell.fontNameLabel.font = UIFont(name: fontNames[indexPath.row], size: 17)
        }

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
