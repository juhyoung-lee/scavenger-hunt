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
    var menuShowing = false
    var nums: [String] = (1...21).map{"Riddle \($0)"}
    var count = 0
    private var tapGesture: UITapGestureRecognizer? = nil
    
    
    @IBOutlet weak var tab: UIButton!
    @IBOutlet weak var solvedNotification: UIImageView!
    @IBAction func solvedSegue(_ sender: Any) {
        performSegue(withIdentifier: "solvedSegue", sender: self)
    }
    @IBOutlet weak var riddleName: UILabel!
    
    @IBOutlet weak var LeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var riddleTable: UITableView!
    
    @IBOutlet weak var answerButton: UIButton!
    
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var riddleText: UILabel!
    
    @IBOutlet weak var findHuntButton: UIButton!
    @IBAction func findHuntButton(_ sender: Any) {
        performSegue(withIdentifier: "returnHomeSegue", sender: self)
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row + 1
        rID = getRiddleID(hID: gCampus, row: row)
        let riddleTxt = vc.returnRiddleData(idnum: rID, select: "message")
        let max = 105 //vc.returnProgressData(hId: gCampus, select: "riddleId") + 1
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
            print(riddleTable.indexPathForRow(at: touchPoint)![1])
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
            openMenu((Any).self)
            menuShowing = !menuShowing
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
        riddleName.text = "Riddle Number"
        passed.isHidden = true
        
        //fix conversion types as int later
        //print(String(vc.returnProgressData(hId: gCampus, select: "riddleId")) == vc.returnHuntData(idnum: Int64(gCampus), select: "total") as! String)
        //print(vc.returnHuntData(idnum: Int64(gCampus), select: "total"))
        //print(String(vc.returnProgressData(hId: gCampus, select: "riddleId")))
        //var temp = getRiddleID(hID: gCampus, row: vc.returnHuntData(idnum: Int64(gCampus), select: "total") as! Int)
        
        //loading total and converting data types not working; fix later
        
        if getRiddleID(hID: gCampus, row: 21) == vc.returnProgressData(hId: gCampus, select: "riddleId"){
            solvedNotification.isHidden = false
            findHuntButton.isHidden = false
            
            
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(blurEffectView)
            self.view.addSubview(solvedNotification)
            self.view.addSubview(findHuntButton)
        }
        else{
            solvedNotification.isHidden = true
            findHuntButton.isHidden = true
        }
        navigationItem.hidesBackButton = true
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
        let max = 105
        
        // Configure the cell...
        cell.riddleNum.text = nums[indexPath.row]
        cell.riddleNum.font = UIFont.systemFont(ofSize: 22.0)
        cell.riddleNum.textColor = .white
        cell.riddleNum.textAlignment = .center
        
        if getRiddleID(hID: gCampus, row: indexPath.row+1) > max{
            print(getRiddleID(hID: gCampus, row: indexPath.row+1))
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
        //tableView.contentInset.bottom = (-verticalPadding/2) + 40
        //tableView.contentInset.top = -verticalPadding/2
    }
    
    func getRiddleID(hID: Int, row: Int) -> Int{
        return row + 100*hID
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "showHintSegue":
            let destVC = segue.destination as! hintViewController
            destVC.rID = rID
        case "solvedSegue":
            let destVC = segue.destination as! solvedViewController
            destVC.rID = rID
        default: break
        }
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
