//
//  riddlesViewController.swift
//  DukeScavenger
//
//  Created by codeplus on 4/6/21.
//

import UIKit

class riddlesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    var menuShowing = false
    var nums = (1...10).map{"Riddle \($0)"}
    
    @IBAction func solvedSegue(_ sender: Any) {
        performSegue(withIdentifier: "solvedSegue", sender: self)
    }
    @IBOutlet weak var riddleName: UILabel!
    
    @IBOutlet weak var LeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var riddleTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addBackground(imageName: "RiddleView")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
    }
    

    @IBAction func openMenu(_ sender: Any) {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "riddleCell", for: indexPath)
            as! riddleTableViewCell
        
        // Configure the cell...
        cell.riddleNum.text = nums[indexPath.row]
        cell.riddleNum.font = UIFont.systemFont(ofSize: 22.0)
        cell.riddleNum.textColor = .white
        cell.riddleNum.textAlignment = .center
        

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section:Int) -> String? {
        return "All Riddles"
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = .init(red: 82/255, green: 163/255, blue: 211/255, alpha:0.8)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 10
        
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
        //tableView.contentInset.bottom = (-verticalPadding/2) + 40
        //tableView.contentInset.top = -verticalPadding/2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        riddleName.text = "Riddle \(indexPath.row + 1)"
        print(indexPath.row)
        openMenu((Any).self)
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

