//
//  CommentViewController.swift
//  Outfitter
//
//  Created by Michael Luo on 4/19/15.
//  Copyright (c) 2015 Outfitter Group. All rights reserved.
//

import UIKit

class CommentTableViewCell : UITableViewCell {
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    func loadItem(title: String, comment: String) {
        commentLabel.text = comment
        titleLabel.text = title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}


class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {

    @IBOutlet var tableView: UITableView!
    var items: [String] = ["We", "Heart", "Swift"]
    var items2: [String] = ["I", "am", "poop"]
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CommentCell")
        
    }
    
    override internal func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CommentTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentTableViewCell
        
        cell.commentLabel.text = self.items2[indexPath.row]
        cell.titleLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }
    
    @IBAction func done()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addComment()
    {
        var addCommentView = UIAlertView(title: "Add comment", message: "Type comment here", delegate: self,
            cancelButtonTitle: "Cancel",
            otherButtonTitles: "Add")
        //var addCommentView = UIAlertView(title: "Add comment", message: "Type comment here", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Submit")

        addCommentView.alertViewStyle = UIAlertViewStyle.PlainTextInput

        addCommentView.show()

    }
    
}