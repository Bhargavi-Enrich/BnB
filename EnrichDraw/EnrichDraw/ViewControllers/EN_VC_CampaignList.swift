//
//  EN_VC_CampaignList.swift
//  EnrichDraw
//
//  Created by Apple on 22/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class EN_VC_CampaignList: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var backGroundImage: UIImageView!
    var tableData = [ModelRunningCampaignListData]()
    var objModelRunningCampaignList = ModelRunningCampaignList()

    var onDoneBlock : ((Bool,ModelRunningCampaignListData) -> Void)?
     var reposStoreSalonServiceCategory: LocalJSONStore<ModelRunningCampaignList> = LocalJSONStore.init(storageType: .cache)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        reposStoreSalonServiceCategory = LocalJSONStore(storageType: .cache, filename:CacheFileNameKeys.k_file_name_Campaign.rawValue, folderName: CacheFolderNameKeys.k_folder_name_Campaign.rawValue)
        
        tblView.register(UINib(nibName: "CampaignTableViewCell", bundle: nil), forCellReuseIdentifier: "CampaignTableViewCell")

        if (self.getCampaignDataFromCache())
        {
        
        }
        
        
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        onDoneBlock!(false, tableData.first ?? ModelRunningCampaignListData())
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension EN_VC_CampaignList : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.tableData.count == 0
        {
            tableView.setEmptyMessage("No Campaign available")
            return 0
        }
        else
        {
            tableView.restore()
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return tableData.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        var returnCell = UITableViewCell()
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "CampaignTableViewCell", for: indexPath) as! CampaignTableViewCell
        
        let model = tableData[indexPath.row]
        cell.lblTitle.textColor = UIColor.black
        cell.lblTitle.text = model.campaign_name ?? "No Campaign available"
        returnCell = cell
         
        return returnCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let model = tableData[indexPath.row]
        let encodedData = try? JSONEncoder().encode(model)
        UserDefaultUtility.shared.saveModelObjectToSharedPreference(data: encodedData!, strKey: UserDefaultKeys.modelRunningCampaingSelected)
        onDoneBlock!(true, model)

    }
}
extension EN_VC_CampaignList
{
    func getCampaignDataFromCache()->Bool
    {
        var havingCachedData:Bool = false
        
        if let repos = reposStoreSalonServiceCategory.storedValue {
            havingCachedData = true
            DispatchQueue.main.async {
                let obj :ModelRunningCampaignList = repos
                if((obj.listOfCampaign ?? []).count > 0)
                {
                    self.tableData = obj.listOfCampaign ?? []
                    self.tableData = self.objModelRunningCampaignList.listOfCampaign ?? []
                    self.tblView.reloadData()
                }
            }
        }
        return havingCachedData
    }
}
