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

    @IBOutlet var sceneView: ARSCNView!
    
    struct Hunts {
        let table = Table("hunts")
        let hId = Expression<Int64>("id")
        let name = Expression<String>("name")
        let descript = Expression<String>("description")
    }
    
    struct Riddles {
        let table = Table("riddles")
        let rId = Expression<Int64>("id")
        let huntId = Expression<Int64>("hunt")
        let msg = Expression<String>("message")
        let soln = Expression<String>("solution")
        let loc = Expression<String>("location")
    }
    
    struct Progress {
        let table = Table("progress")
        let pId = Expression<Int64>("id")
        let huntId = Expression<Int64>("hunt")
        let riddleId = Expression<Int64>("riddle")
        let time = Expression<String>("timeCompleted")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addBackground()
        
        // SQLite Database
        // needs more work :)

        // Set the view's delegate
        //sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        //createDatabase()
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
        if let _ = try? db.execute("PRAGMA foreign_keys = ON;") {
            print("foreign key support failed to activate")
        } // turns on foreign keys support for the db connection
        print("\n")
        
        let h = Hunts()
        if let _ = try? db.run(h.table.create(ifNotExists: true) { t in
            t.column(h.hId, primaryKey: true)
            t.column(h.name, unique: true)
            t.column(h.descript)
        }){
            print("hunts db creation failed")
        }
        
        let r = Riddles()
        if let _ = try? db.run(r.table.create(ifNotExists: true) { t in
            t.column(r.rId, primaryKey: true)
            t.column(r.huntId, references: h.table, h.hId)
            t.column(r.msg, unique: true)
            t.column(r.soln, unique: true)
            t.column(r.loc)
            t.foreignKey(r.huntId, references: h.table, h.hId, update: .cascade, delete: .cascade)
        }){
            print("riddles db creation failed")
        }
        

        let p = Progress()
        if let _ = try? db.run(p.table.create(ifNotExists: true) { t in
            t.column(p.pId, primaryKey: .autoincrement)
            t.column(p.huntId)
            t.column(p.riddleId)
            t.column(p.time)
            t.foreignKey(p.huntId, references: h.table, h.hId, update: .cascade, delete: .cascade)
            t.foreignKey(p.riddleId, references: r.table, r.rId, update: .cascade, delete: .cascade)
        }) {
            print("progress db creation failed")
        }
        
        print("db exists!\n")
        return db
    }
    
    func populateDatabase(db: Connection) {
        let h = Hunts()
        let r = Riddles()
        let p = Progress()
        dropDatabaseRows(db: db)
        do {
            try db.run(h.table.insert(
                        h.hId <- 1,
                        h.name <- "OWeek Hunt",
                        h.descript <- "fuck freshmen"))
            try db.run(h.table.insert(
                        h.hId <- 2,
                        h.name <- "LDOC Hunt",
                        h.descript <- "fuck freshmen"))
            
            try db.run(r.table.insert(
                        r.rId <- 101,
                        r.huntId <- 1,
                        r.msg <- "big pointy",
                        r.soln <- "chapel",
                        r.loc <- "long 0, lat 0"))
            try db.run(r.table.insert(
                        r.rId <- 102,
                        r.huntId <- 0,
                        r.msg <- "move your car",
                        r.soln <- "bus stop",
                        r.loc <- "long 10, lat 0"))
            try db.run(r.table.insert(
                        r.rId <- 103,
                        r.huntId <- 0,
                        r.msg <- "move your car",
                        r.soln <- "bus stop",
                        r.loc <- "long 10, lat 0"))
            
            try db.run(p.table.insert(
                        p.pId <- 0,
                        p.huntId <- 1,
                        p.riddleId <- 1,
                        p.time <- "4/2/21-01:21"))
            
            print("\ndb populated!\n")
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("\nconstraint failed: \(message) in \(statement)\n")
        } catch {
            print("\ndb population failed\n")
        }
    }
    
    func dropDatabaseRows(db: Connection) {
        let h = Hunts()
        let r = Riddles()
        let p = Progress()
        
        do {
            try db.run(h.table.delete())
            try db.run(r.table.delete())
            try db.run(p.table.delete())
            print("\ndb rows deleted!\n")
        } catch {
            print("\ndb row deletion failed\n")
        }
    }
    
    func dropDatabase(db: Connection) {
        let h = Hunts()
        let r = Riddles()
        let p = Progress()
        
        do {
            try db.run(h.table.drop())
            try db.run(r.table.drop())
            try db.run(p.table.drop())
            print("\ndb dropped!\n")
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
                print("id: \(row[h.hId]), name: \(row[h.name]), descript: \(row[h.descript])")
            }
            print("riddles table")
            for row in try db.prepare(r.table) {
                print("id: \(row[r.rId]), huntId: \(row[r.huntId]), msg: \(row[r.msg]), soln: \(row[r.soln]), loc: \(row[r.loc])")
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
