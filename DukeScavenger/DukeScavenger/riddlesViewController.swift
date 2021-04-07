//
//  riddlesViewController.swift
//  DukeScavenger
//
//  Created by codeplus on 4/6/21.
//

import UIKit

class riddlesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var menuShowing = false
    var nums = (1...10).map{"Riddle \($0)"}
    
    @IBOutlet weak var LeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var riddleTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    

    @IBAction func openMenu(_ sender: Any) {
        print("send help")
        if(menuShowing){
            LeadingConstraint.constant = -270
        }
        else{
            LeadingConstraint.constant = 0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            })
        }
        menuShowing = !menuShowing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 //number or riddles
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "riddleCell", for: indexPath)
            as! riddleTableViewCell
        
        // Configure the cell...
        cell.riddleNum.text = nums[indexPath.row]
        cell.riddleNum.textAlignment = .center

        
        return cell
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
