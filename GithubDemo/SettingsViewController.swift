//
//  SettingsViewController.swift
//  GithubDemo
//
//  Created by Deepthy on 9/20/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func settingsChanged(settingsViewController: SettingsViewController, didUpdateSettings settings: GithubRepoSearchSettings)
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: SettingsViewControllerDelegate?
    var languageList : [String]?
    var searchSettings: GithubRepoSearchSettings!

    fileprivate var showLanguageList = false
    fileprivate var sliderValue = 0
    fileprivate var switchStates: [Int:Bool] = [:]
    fileprivate var showSortBy = false
    fileprivate var selectedSortIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        showLanguageList = searchSettings.switchStates.values.contains(true)
        selectedSortIndex = searchSettings.sortIndex
        
        if searchSettings == nil {
            searchSettings = GithubRepoSearchSettings()
        }
        tableView.tableFooterView = UIView()
    }

    fileprivate func repoSortBy() -> [[String : String]] {
        return [["name" : "Stars", "code": "stars"],
                ["name" : "Forks", "code": "forks"],
                ["name" : "Updated", "code": "updated"]]
    }
    
    @IBAction func onSaveClick(_ sender: Any) {
        let settings = sliderSetting()

        delegate?.settingsChanged(settingsViewController: self, didUpdateSettings: settings)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        if searchSettings.switchStates.contains(where: { (key: Int, value: Bool) -> Bool in
            if searchSettings.switchStates[key] == switchStates[key] {
                searchSettings.switchStates.removeValue(forKey: key)
            }
            return false
        }) {}
        dismiss(animated: true, completion: nil)
    }
    
    func sliderSetting() -> GithubRepoSearchSettings {

        let miniStars = sliderValue == 0 ? searchSettings.minStars : sliderValue
        searchSettings.minStars = miniStars
        var languageSelected: [String] = []
        if !showLanguageList {
            searchSettings.switchStates.removeAll()
            searchSettings.languages.removeAll()
        }
        for (key, isSelected) in searchSettings.switchStates {
            if isSelected {
                languageSelected.append(languageList![key])
            }
        }
        searchSettings.languages = languageSelected.isEmpty ? searchSettings.languages : languageSelected
        searchSettings.sortIndex = selectedSortIndex
        searchSettings.sortBy = repoSortBy()[selectedSortIndex]["code"]!
        
        return searchSettings
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Sort By" : ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showSortBy && section == 1 {
           return repoSortBy().count
        }
        
        return (section == 2 && showLanguageList) ? 1 + (languageList?.count)! : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "slidercell", for: indexPath) as! SliderCell
                cell.selectionStyle = .none
                cell.starSliderMaxLabel.text = "\(Int(searchSettings.minStars))"
                cell.starSlider.value = Float(searchSettings.minStars)
                cell.delegate = self

                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as! DropDownCell
                cell.dropDownLabel.text = repoSortBy()[indexPath.row]["name"]
                if !showSortBy {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Dropdown"))
                }
                else {
                    cell.accessoryView = indexPath.row == selectedSortIndex ? UIImageView(image: UIImage(named: "Check")) : UIImageView(image: UIImage(named: "Uncheck"))
                }
                cell.selectionStyle = .none
            
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "switchcell", for: indexPath) as! SwitchCell
                cell.delegate = self
                if indexPath.row == 0 {
                    cell.onSwitch.isOn = showLanguageList
                }
                else {
                    cell.switchLabel.text = languageList?[indexPath.row-1]
                    cell.onSwitch.isOn = searchSettings.switchStates[indexPath.row-1] ?? false
                }
                cell.selectionStyle = .none
                
                return cell
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            let cell = tableView.cellForRow(at: indexPath)!
            cell.accessoryView = UIImageView(image: UIImage(named: "Check"))

            showSortBy = !showSortBy
            if !showSortBy {
                selectedSortIndex = indexPath.row
            }
            self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.fade)
        }
    }
}

extension SettingsViewController: SliderCellDelegate {
    func sliderCell(sliderCell: SliderCell, didChangeValue value:  Int) {
        sliderValue = value
    }
}

extension SettingsViewController: SwitchCellDelegate {
    func switchCell(switchCell: SwitchCell, didChangeValue value:  Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        
        if indexPath.section == 2 && indexPath.row == 0 {
            showLanguageList = switchCell.onSwitch.isOn
            self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.fade)
        }
        else {
            switchStates.updateValue(value, forKey: indexPath.row-1)
            searchSettings.switchStates.updateValue(value, forKey: indexPath.row-1)
        }
    }
}
