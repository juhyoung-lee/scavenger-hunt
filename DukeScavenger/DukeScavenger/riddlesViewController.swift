//
//  riddlesViewController.swift
//  DukeScavenger
//
//  Created by codeplus on 4/6/21.
//

import UIKit

class riddlesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    let vc = ViewController()
    var gCampus: Int = 0
    var rID: Int = 0
    var menuShowing = true
    var nums: [String] = (1...21).map{"Riddle \($0)"}
    var count = 0
    private var tapGesture: UITapGestureRecognizer? = nil
    
    @IBOutlet weak var tab: UIButton!

    @IBAction func mapSegue(_ sender: Any) {
        performSegue(withIdentifier: "mapSegue", sender: self)
    }
    @IBOutlet weak var riddleName: UILabel!
    
    @IBOutlet weak var LeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var riddleTable: UITableView!
    
    @IBOutlet weak var answerButton: UIButton!
    
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var riddleText: UILabel!
    
    @IBOutlet var blurView: UIView!
    
    @IBAction func showHint(_ sender: Any) {
        performSegue(withIdentifier: "showHintSegue", sender: self)
    }
    
    @IBOutlet weak var passed: UIImageView!
    
    @IBAction func openMenu(_ sender: Any) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        if(menuShowing){
            LeadingConstraint.constant = -262
            self.navigationItem.setHidesBackButton(true, animated: true)
            for subview in blurView.subviews{
                if subview is UIVisualEffectView{
                    subview.removeFromSuperview()
                }
            }
        }
        else{
            LeadingConstraint.constant = 0
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(blurEffectView)
            self.view.addSubview(riddleTable)
            self.view.addSubview(tab)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                self.navigationItem.setHidesBackButton(false, animated: true)
            }
            
            
        }
        menuShowing = !menuShowing
    }
    
    //var progress : Int64 = 101
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vc.printDatabase(db: vc.database)
        
        let row = indexPath.row + 1
        rID = getRiddleID(hID: gCampus, row: row)
        
        if rID != 0 || vc.returnProgressData(hId: gCampus, select: "riddleId") != 0 {
            answerButton.isEnabled = true
        }
        
        
        let riddleTxt = vc.returnRiddleData(idnum: rID, select: "message")

        var max = vc.returnProgressData(hId: gCampus, select: "riddleId")
        if (max == 0) {
            max += Int64(gCampus * 100 + 1)
        } else {
            max += 1
        }
        //ie, the last completed riddle is 104, and you're currently on 105
        if  rID <= max{
            riddleName.text = "Riddle \(row)"
            riddleText.text = "\(riddleTxt)"
            
            if rID == max {
                hintButton.isHidden = false
                passed.isHidden = true
                answerButton.isHidden = false
            }
            else if rID < max {
                answerButton.isHidden = true
                hintButton.isHidden = true
                passed.isHidden = false
            }
            openMenu((Any).self)
            menuShowing = !menuShowing
        }
    }
    
    //doesn't work if you scroll through the table view
    @IBAction func touchWasDetected(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: view)
        if (!riddleTable.frame.contains(touchPoint)){
            if(menuShowing){
                openMenu((Any).self)
            }
        }
        else{
            let row = riddleTable.indexPathForRow(at: touchPoint)![1]
            rID = getRiddleID(hID: gCampus, row: row)
            if row > 0 && rID <= 105{
                let riddleTxt = vc.returnRiddleData(idnum: rID, select: "message")
                riddleName.text = "Riddle \(row)"
                riddleText.text = "\(riddleTxt)"
                if row == 105 {
                    hintButton.isHidden = false
                    passed.isHidden = true
                }
                else if row <= 105 {
                    answerButton.isHidden = true
                    hintButton.isHidden = true
                    passed.isHidden = false
                }
            
            menuShowing = !menuShowing
        }
    }
}
    
    override func viewWillAppear(_ animated: Bool) {

        riddleTable.reloadData()
        let temp: Int64 = vc.returnProgressData(hId: gCampus, select: "riddleId")
        
        if temp == rID {
            if String(temp % 100) == vc.returnHuntData(idnum: Int64(gCampus), select: "total") as! String {
                answerButton.isHidden = true
                hintButton.isHidden = true
                passed.isHidden = true
            }
            else {
                let iPath = IndexPath(row: Int(temp % 100), section: 0)
                let prevIPath = IndexPath(row: Int(temp % 100)-1, section: 0)
                
                if rID != 0 {
                    tableView(riddleTable, didSelectRowAt: iPath)
                    self.rID = Int(temp + 1)
                    riddleTable.deselectRow(at: prevIPath, animated: false)
                    riddleTable.reloadData()
                    self.navigationItem.setHidesBackButton(true, animated: true)
                }
                
            }
            
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addBackground(imageName: "RiddleView")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        passed.isHidden = true
        if rID == 0 && vc.returnProgressData(hId: gCampus, select: "riddleId") == 0 {
            answerButton.isEnabled = false
        }
        
        //loading total and converting data types not working; fix later
        
        if getRiddleID(hID: gCampus, row: 21) == vc.returnProgressData(hId: gCampus, select: "riddleId"){
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(blurEffectView)
        }
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
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
        header.contentView.backgroundColor = .init(red: 94/255, green: 178/255, blue: 222/255, alpha:1.0)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (vc.returnHuntData(idnum: Int64(gCampus), select: "total") as? Int ?? 21)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "riddleCell", for: indexPath)
            as! riddleTableViewCell
        let max = vc.returnProgressData(hId: gCampus, select: "riddleId") + 1
        // Configure the cell...
        cell.riddleNum.text = nums[indexPath.row]
        cell.riddleNum.font = UIFont.systemFont(ofSize: 22.0)
        cell.riddleNum.textColor = .white
        cell.riddleNum.textAlignment = .center
        
        if vc.returnProgressData(hId: gCampus, select: "riddleId") == 0{
            if indexPath.row == 0{
                cell.backgroundColor = UIColor(red: 0/255, green: 83/255, blue: 139/255, alpha:0.8)
            }
            else{
                cell.backgroundColor = .gray
            }
        }
        else if getRiddleID(hID: gCampus, row: indexPath.row+1) > max{
            cell.backgroundColor = .gray
        }
        else{
            cell.backgroundColor = UIColor(red: 0/255, green: 83/255, blue: 139/255, alpha:0.8)
        }
            return cell
        }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 10
        
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    func getRiddleID(hID: Int, row: Int) -> Int{
        return row + 100*hID
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "showHintSegue":
            let destVC = segue.destination as! hintViewController
            destVC.rID = rID
        case "mapSegue":
            let destVC = segue.destination as! locationViewController
            destVC.rID = rID
        default: break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controlleletsing segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
