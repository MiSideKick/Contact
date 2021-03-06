import UIKit
import CoreData


class CatchUps: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct ClassConstants {
        static let REASON = "Reason: "
    }
	
	@IBOutlet var tableView: UITableView!
	@IBOutlet var addButton: UIBarButtonItem!
    
    var catchUps = [AnyObject]()
    var selectedPerson = String()
    var cameFromArchived = false
    
	
	
	/* MARK: Init
	/////////////////////////////////////////// */
	override func viewWillAppear(_ animated: Bool) {
//        tableView.delegate = self
//        tableView.dataSource = self
		refresh();
		
		// Styling
		Utils.insertGradientIntoView(viewController: self)
		Utils.createFontAwesomeBarButton(button: addButton, icon: .plus, style: .solid)
		tableView.separatorStyle = UITableViewCellSeparatorStyle.none
		
		// Observer for every notification received
		NotificationCenter.default.addObserver(self, selector: #selector(CatchUps.backgoundNofification(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil);
        
        if cameFromArchived {
            self.navigationItem.rightBarButtonItems = []
        }
    }
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	@objc func backgoundNofification(_ noftification:Notification){
		refresh()
	}
	
	func refresh() {
		selectedPerson = UserDefaults.standard.string(forKey: Constants.LocalData.SELECTED_PERSON)!
		self.title = selectedPerson
		
		catchUps = Utils.fetchCoreDataObject(Constants.CoreData.CATCHUP, predicate: selectedPerson)
		catchUps = catchUps.reversed() // newest first
        for catchUp in catchUps {
            catchUp.setValue(false, forKey: Constants.CoreData.ARCHIVED)
        }
        if UserDefaults.standard.bool(forKey: Constants.LocalData.SHOW_COMPLETED_CATCHUPS) {
            let archivedCAtchUps = Utils.fetchCoreDataObject(Constants.CoreData.ARCHIVECATCHUP, predicate: selectedPerson)
            for catchUp in archivedCAtchUps {
                catchUp.setValue(true, forKey: Constants.CoreData.ARCHIVED)
            }
            catchUps.append(contentsOf: archivedCAtchUps)
        }
		
		self.tableView.reloadData()
	}
	
	
	
	/* MARK: Core Functionality
	/////////////////////////////////////////// */
	class func deleteCatchUp(_ catchUp: NSManagedObject) {
		let catchUpUUID = catchUp.value(forKey: Constants.CoreData.UUID) as! String
		
		// Remove notification for catchUp object & update app icon badge notification count
		for notification in UIApplication.shared.scheduledLocalNotifications!{
			let notificationUUID = notification.userInfo!["UUID"] as! String
			
			if (notificationUUID == catchUpUUID) {
				UIApplication.shared.cancelLocalNotification(notification)
				break
			}
		}
		CatchUps.setBadgeNumbers()
		
		// Remove catchUp object
		let managedObjectContect = Utils.fetchManagedObjectContext()
		managedObjectContect.delete(catchUp)
		
		do {
			try managedObjectContect.save()
		} catch {
			print(error)
		}
	}
	
	class func setBadgeNumbers() {
		let notifications = UIApplication.shared.scheduledLocalNotifications // all scheduled notifications
		let catchUps = Utils.fetchCoreDataObject(Constants.CoreData.CATCHUP, predicate: "")
		
		UIApplication.shared.cancelAllLocalNotifications()
		
		// for every notification
		for notification in notifications! {
			for catchUp in catchUps {
				let catchUpUUID = catchUp.value(forKey: Constants.CoreData.UUID) as! String
				let notificationUUID = notification.userInfo!["UUID"] as! String
				
				if (notificationUUID == catchUpUUID) {
					let overdueCatchUps = catchUps.filter({ (catchUp) -> Bool in
						let when = catchUp.value(forKey: Constants.CoreData.WHEN) as! Date
						let dateComparisionResult: ComparisonResult = notification.fireDate!.compare(when)
						return dateComparisionResult == ComparisonResult.orderedAscending
					})
					
					notification.repeatInterval = NSCalendar.Unit.day
					notification.applicationIconBadgeNumber = overdueCatchUps.count                // set new badge number
					UIApplication.shared.scheduleLocalNotification(notification)      // reschedule notification
				}
			}
		}
	}
    
    func archieveCatchUp(_ task: NSManagedObject) {
        let contactName = task.value(forKey: Constants.CoreData.NAME) as! String? ?? ""
        let type = task.value(forKey: Constants.CoreData.TYPE)
        let date = task.value(forKey: Constants.CoreData.WHEN) as! Date? ?? Date()
        let reason = task.value(forKey: Constants.CoreData.REASON)
        Utils.createArchiveCatchUp(personName: contactName, type: type as AnyObject, when: date, reason: reason as AnyObject)
    }

	
	
	/* MARK: Table Functionality
	/////////////////////////////////////////// */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: CatchUpsTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell") as? CatchUpsTableViewCell
		if cell == nil {
			cell = CatchUpsTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
		}
		let tasks = self.catchUps[indexPath.row]
		let type = tasks.value(forKey: Constants.CoreData.TYPE) as! String?
        let archived = tasks.value(forKey: Constants.CoreData.ARCHIVED) as! Bool? ?? false
		
		// Style
		cell!.selectionStyle = .none
		
		cell.reasonLabel!.text = tasks.value(forKey: Constants.CoreData.REASON) as! String?
		cell.thumbnailImageView!.image = UIImage(named: type!)
		cell.thumbnailImageView!.image = cell.thumbnailImageView!.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        if !archived {
            cell.thumbnailImageView!.tintColor = UIColor.white
        } else {
            cell.thumbnailImageView!.tintColor = UIColor(white: 1.0, alpha: 0.5)
            cell.reasonLabel?.textColor =  UIColor(white: 1.0, alpha: 0.5)
            let strikethroughLine = UIView(frame: CGRect(x: 20.0, y: cell.frame.height/2 - 1, width: self.tableView.frame.width - 40, height: 2))
            strikethroughLine.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            strikethroughLine.tag = 44
            cell.addSubview(strikethroughLine)
        }
		
		cell.updateConstraints()
		
		return cell
    }
	
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if !cameFromArchived && !(self.catchUps[indexPath.row].value(forKey: Constants.CoreData.ARCHIVED) as! Bool? ?? false) {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let deleteAction = UITableViewRowAction(style: .default, title: "Mark Done") {_,_ in
            let catchUp = self.catchUps[indexPath.row] as! NSManagedObject
            self.archieveCatchUp(catchUp)
            CatchUps.deleteCatchUp(catchUp)
			
            // Refresh table
//            self.catchUps = Utils.fetchCoreDataObject(Constants.CoreData.CATCHUP, predicate: self.selectedPerson)
//            self.catchUps = self.catchUps.reversed() // newest first
//
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.reloadData()
            self.refresh()
			
			// Achievements
			CatchUp.updateCatchupCompleted(view: self)
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
		
        // Set catchup in NSUserDefaults (so we can get catchup details it later)
        let defaults = UserDefaults.standard
        defaults.set(NSInteger(indexPath.row), forKey: Constants.LocalData.SELECTED_CATCHUP_INDEX)
		
        // Show CatchUp view
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let catchUpView = storyBoard.instantiateViewController(withIdentifier: Constants.Views.CATCH_UP) as! CatchUp
        catchUpView.cameFromArchive = cameFromArchived
        self.show(catchUpView as UIViewController, sender: catchUpView)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let emptyView = UIView(frame: CGRect(x:0, y:0, width:self.view.bounds.size.width, height:self.view.bounds.size.height))
        
		if catchUps.count == 0 {
			
			let emptyImageView = UIImageView(frame: CGRect(x:0, y:0, width:150, height:150))
			emptyImageView.center = CGPoint(x:self.view.frame.width / 2, y: self.view.bounds.size.height * 0.30)
			let emptyImage = Utils.imageResize(UIImage(named: "Phone Call")!, sizeChange: CGSize(width: 150, height: 150)).withRenderingMode(UIImageRenderingMode.alwaysTemplate)
			emptyImageView.image = emptyImage
			emptyImageView.tintColor = UIColor.white
			emptyView.addSubview(emptyImageView)
			
			let emptyLabel = UILabel(frame: CGRect(x:0, y:0, width:self.view.bounds.size.width - 100, height:self.view.bounds.size.height))
			emptyLabel.center = CGPoint(x:self.view.frame.width / 2, y: self.view.bounds.size.height * 0.53)
			emptyLabel.text = "Now that you have created a person to keep in contact with, what will it take to make the connection? Create a reminder now!"
			emptyLabel.font = UIFont.GothamProRegular(size: 15.0)
			emptyLabel.textAlignment = NSTextAlignment.center
			emptyLabel.textColor = UIColor.white
			emptyLabel.numberOfLines = 5
			emptyView.addSubview(emptyLabel)
			
			self.tableView.backgroundView = emptyView
			return 0
            
		}else{
            
            self.tableView.backgroundView = emptyView
			return catchUps.count
		}
    }
}


class CatchUpsTableViewCell : UITableViewCell {
    @IBOutlet var reasonLabel: UILabel?
    @IBOutlet var thumbnailImageView: UIImageView?
    
    override func prepareForReuse() {
        for view in self.subviews {
            if reasonLabel?.textColor != UIColor.white {
                reasonLabel?.textColor = UIColor.white
            }
            if view.tag == 44 {
                view.removeFromSuperview()
            }
        }
    }
}
