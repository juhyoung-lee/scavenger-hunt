//
//  ViewController.swift
//  DukeScavenger
//
//  Created by codeplus on 4/1/21.
//
import UIKit
import SceneKit
import ARKit
import SQLite

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var back: UINavigationItem!
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBAction func introSegue(_ sender: Any) {
        performSegue(withIdentifier: "introSegue", sender: self)
    }
    @IBOutlet weak var campusToggle: UISegmentedControl!
    
    lazy public var database = createDatabase()
    
    struct Hunts {
        let table = Table("hunts")
        let hId = Expression<Int64>("id")
        let name = Expression<String>("name")
        let descript = Expression<String>("description")
        let diff = Expression<String>("difficulty")
    }
    
    struct Riddles {
        let table = Table("riddles")
        let rId = Expression<Int64>("id")
        let huntId = Expression<Int64>("hunt")
        let msg = Expression<String>("message")
        let hint = Expression<String>("hint")
        let answer = Expression<String>("answer")
        let blurb = Expression<String>("blurb")
        let loc = Expression<String>("location")
        let sprite = Expression<String>("sprite")
    }
    
    struct Progress {
        let table = Table("progress")
        let pId = Expression<Int64>("id")
        let huntId = Expression<Int64>("hunt")
        let riddleId = Expression<Int64>("riddle")
        let time = Expression<String>("timeCompleted")
    }
    
    var huntDict : [String: Expression<String>] = ["name": Hunts().name, "descript": Hunts().descript, "difficulty": Hunts().diff]
    var riddleDict : [String: Expression<String>] = ["message":Riddles().msg, "hint": Riddles().hint, "answer": Riddles().answer, "blurb": Riddles().blurb, "location": Riddles().loc, "sprite": Riddles().sprite]
    var progressDict : [String: Expression<Int64>] = ["huntId": Progress().huntId, "riddleID" : Progress().riddleId]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addBackground(imageName: "mainMenu")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        
        // SQLite Database
        let db = createDatabase()
        populateDatabase(db: db)
        
        // Set the view's delegate
        //sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        
        // Create a session configuration
        //let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        //sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //super.viewWillDisappear(animated)
        
        // Pause the view's session
        //sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func createDatabase() -> Connection {
        // TODO: skip if db exists
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let db = try! Connection("\(dbPath)/db.sqlite3")
        if let error = try? db.execute("PRAGMA foreign_keys = ON;") {
            print("\n\n\nforeign key support status: \(error)")
        } // turns on foreign keys support for the db connection
        print("\n")
        
        var attempt: Statement?
        
        let h = Hunts()
        attempt = try? db.run(h.table.create(ifNotExists: true) { t in
            t.column(h.hId, primaryKey: true)
            t.column(h.name, unique: true)
            t.column(h.descript)
            t.column(h.diff)
        })
        print("\(attempt)")
        
        let r = Riddles()
        attempt = try? db.run(r.table.create(ifNotExists: true) { t in
            t.column(r.rId, primaryKey: true)
            t.column(r.huntId, references: h.table, h.hId)
            t.column(r.msg)
            t.column(r.hint)
            t.column(r.blurb)
            t.column(r.answer)
            t.column(r.loc)
            t.column(r.sprite)
            t.foreignKey(r.huntId, references: h.table, h.hId, update: .cascade, delete: .cascade)
        })
        print("\(attempt)")

        let p = Progress()
        attempt = try? db.run(p.table.create(ifNotExists: true) { t in
            t.column(p.pId, primaryKey: .autoincrement)
            t.column(p.huntId)
            t.column(p.riddleId)
            t.column(p.time)
            t.foreignKey(p.huntId, references: h.table, h.hId, update: .cascade, delete: .cascade)
            t.foreignKey(p.riddleId, references: r.table, r.rId, update: .cascade, delete: .cascade)
        })
        print("\(attempt)")

        return db
    }
    
    func populateDatabase(db: Connection) {
        let h = Hunts()
        let r = Riddles()
        dropDatabaseRows(db: db)
        do {
            let bundle = Bundle.main
            func readtxt(fileName: String) -> String {
                let path = bundle.path(forResource: fileName, ofType: "txt")!
                var string : String = ""
                do {
                    string = try String (contentsOfFile: path)
                } catch {
                    print ("error reading datafile")
                }
                return string
            }
            
            let huntsLines = readtxt(fileName: "hunts").split(separator: "\n")
            let riddlesLines = readtxt(fileName: "riddles").split(separator:"\n")
            
            for line in huntsLines {
                let temp = line.split(separator: "|")
                try db.run(h.table.insert(
                            h.hId <- Int64(temp[0]) ?? 0,
                            h.name <- String(temp[1]),
                            h.descript <- String(temp[2]),
                            h.diff <- String(temp[3])))
            }
            for line in riddlesLines {
                let temp = line.split(separator: "|")
                try db.run(r.table.insert(
                            r.rId <- Int64(temp[0]) ?? 0,
                            r.huntId <- Int64(temp[1]) ?? 0,
                            r.msg <- String(temp[2]),
                            r.hint <- String(temp[3]),
                            r.blurb <- String(temp[4]),
                            r.answer <- String(temp[5]),
                            r.loc <- String(temp[6]),
                            r.sprite <- String(temp[7])))
            }

            
            print("\ndb populated!\n")
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("\nconstraint failed: \(message) in \(String(describing: statement))\n")
        } catch {
            print("\ndb population failed\n")
        }
    }
    
    func dropDatabaseRows(db: Connection) {
        let h = Hunts()
        let r = Riddles()
        
        do {
            try db.run(h.table.delete())
            try db.run(r.table.delete())
            print("\ndb hunts and riddles rows deleted!\n")
        } catch {
            print("\ndb row deletion failed\n")
        }
    }
    
    func dropDatabase(db: Connection) {
        let h = Hunts()
        let r = Riddles()
        let p = Progress()
        
        do {
            try db.run(p.table.drop())
            try db.run(r.table.drop())
            try db.run(h.table.drop())
            print("\ndb dropped!\n")
        } catch let Result.error(message, code, statement) {
            print("\ndb drop failed: \(message) in \(String(describing: statement))\n")
        } catch {
            print("\ndb drop failed\n")
        }
    }
    
    func printDatabase(db: Connection) {
        let h = Hunts()
        let r = Riddles()
        let p = Progress()
        
        do {
            let htable = try db.prepare(h.table)
            print("\nhunts table")
            for row in htable {
                print("id: \(row[h.hId]), name: \(row[h.name]), descript: \(row[h.descript]), difficulty: \(row[h.diff])")
            }
            print("riddles table")
            for row in try db.prepare(r.table) {
                print("id: \(row[r.rId]), huntId: \(row[r.huntId]), msg: \(row[r.msg]), hint: \(row[r.hint]), answer: \(row[r.answer]), blurb: \(row[r.blurb]), loc: \(row[r.loc]), sprite: \(row[r.sprite])")
            }
            print("progress table")
            for row in try db.prepare(p.table) {
                print("id: \(row[p.pId]), huntId: \(row[p.huntId]), riddleId: \(row[p.riddleId]), time: \(row[p.time])")
            }
            print("db printed\n")
        } catch {
            print("\ndb printing failed\n")
        }
    
    }
    func returnHuntData(idnum: Int64, select: String) -> Any {
        let h = Hunts()
        let r = Riddles()
        do {
            let count = try database.scalar(r.table.filter(r.huntId == idnum).count)
            if select == "total" {
                return ("\(count)")
            }
        } catch {
            print("\ndb printing failed\n")
        }
        do {
            for row in try database.prepare(h.table) {
                if row[h.hId] == idnum {
                    return row[huntDict[select]!]
                }
            }
            print("db printed\n")
        } catch {
            print("\ndb printing failed\n")
        }
    return "Data not found"
    }
    
    func returnRiddleData(idnum: Int, select: String) -> String {
        let r = Riddles()
        do {
            for row in try database.prepare(r.table) {
                if row[r.rId] == idnum {
                    return row[riddleDict[select]!]
                }
            }
            print("db printed\n")
        } catch {
            print("\ndb printing failed\n")
        }
    return "Data not found"
    }
    
    func returnProgressData(hId: Int, select: String) -> Int64 {
        let p = Progress()
        do {
            for row in try database.prepare(p.table) {
                if row[p.huntId] == hId {
                    return row[progressDict[select]!]
                }
            }
            print("db printed\n")
        } catch {
            print("\ndb printing failed\n")
        }
    return 0
    }
    
    func getRiddleColumn(hId: Int64, col: String) -> [String] {
        let r = Riddles()
        var ret : [String] = ["Placeholder"]
        do{
            for riddle in try database.prepare(r.table.select(riddleDict[col]!).filter(r.huntId == hId).order(r.rId.asc)) {
                ret.append(riddle[riddleDict[col]!])
            }
        } catch {
            print ("failed")
        }
        return ret
    }
    
    func addProgress(rId: Int64) {
        let r = Riddles()
        var maxRiddle: Int64 = 0
        do {
            for row in try database.prepare(r.table.select(r.rId).filter(r.huntId==rId/100).order(r.rId.asc)) {
                maxRiddle = row[r.rId]
            }
        } catch {
            print("error finding max riddle number")
        }
        
        let p = Progress()
        var pid: Int64 = 0
        do {
            for row in try database.prepare(p.table.select(p.pId).order(p.pId.asc)) {
                pid = row[p.pId] + 1
            }
        } catch {
            print("error counting progress rows")
        }
        let hunt = rId / 100
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        let time = formatter.string(from: today)
        if rId%(hunt*100) > 1 {
            let prev = p.table.filter(p.riddleId == rId - 1)
            do {
                try database.run(prev.delete())
            } catch {
                print("error deleting previous progress entry")
            }
        }
        if (rId < maxRiddle) {
            do {
                try database.run(p.table.insert(p.pId <- pid, p.huntId <- hunt, p.riddleId <- rId, p.time <- time))
            } catch {
                print(pid, hunt, rId)
                print("error adding row to progress")
            }
        }
    }
    
}

extension UIView {
    func addBackground(imageName: String = "menuBackground", contentMode: UIView.ContentMode = .scaleToFill) {
        // setup the UIImageView
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: imageName)
        backgroundImageView.contentMode = contentMode
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView)

        // adding NSLayoutConstraints
        let leadingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)

        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
}
