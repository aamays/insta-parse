//
//  HomeViewController.swift
//  InstaParse
//
//  Created by Amay Singhal on 1/23/16.
//  Copyright © 2016 CodePath. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var gramsTableView: UITableView!

    var refreshControl: UIRefreshControl!
    var postedGrams: [UserMedia]? {
        didSet {
            gramsTableView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Home"
        gramsTableView.delegate = self
        gramsTableView.dataSource = self

        // initialize refresh control view
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

        // add refresh control to the table view
        gramsTableView.addSubview(refreshControl)

        // update table
        updateGramsTable()
    }

    // MARK: - Table View Delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postedGrams?.count ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GramTableViewCell", forIndexPath: indexPath) as! GramTableViewCell
        cell.gramMedia = postedGrams![indexPath.row]
        return cell
    }

    // MARK: - Actions
    @IBAction func logoutUser(sender: UIButton) {
        NSLog("Logging out user")
        PFUser.logOut()
        view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
    }

    // MARK: - Helper functions
    private func updateGramsTable() {
        UserMedia.fetchRecentMedia { (success: Bool, media: [UserMedia]?, error: NSError?) -> () in
            if success {
                for m in media! {
                    print(m.likesCount)
                }
                self.postedGrams = media
                self.refreshControl.endRefreshing()
            } else {
                print(error?.localizedDescription)
            }
        }
    }

    func refresh(refControl: AnyObject?) {
        updateGramsTable()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
