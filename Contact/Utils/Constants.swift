import Foundation

class Constants {
	
	struct Common {
		static let APP_ID = "1101260252"
		static let APPNAME = "Contact"
		
		static let LINK_APP_REVIEW = "itms-apps://itunes.apple.com/app/apple-store/id" + Common.APP_ID + "?action=write-review"
		static let LINK_FACEBOOK = "https://www.facebook.com/getlearnable"
		static let LINK_INSTAGRAM = "https://www.instagram.com/learnableapp"
		static let LINK_IOS_STORE = "https://itunes.apple.com/gb/app/contact-remember-your-friends/id1101260252?mt=8"
		static let LINK_LEARNABLE_IOS_STORE = "https://itunes.apple.com/gb/app/learnable-learn-to-code-from-scratch-level-up/id1254862243?mt=8"
		static let LINK_TWITTER = "https://twitter.com/getlearnable"
		
		static let CELL = "cell"
		static let MAIN_STORYBOARD = "Main"
		static let SUBMIT = "Create"
		static let CLOSE = "Close"
	}
	
	
    struct CoreData {
        static let CATCHUP = "CatchUp"
        static let PERSON = "Person"
        static let NAME = "name"
        static let REASON = "reason"
        static let THUMBNAIL = "thumbnail"
        static let TYPE = "type"
        static let WHEN = "when"
        static let UUID = "uuid"
    }
	
	
	struct Design {
		static let LOGO = "AppIcon"
	}
	
	
    struct LocalData {
        static let SELECTED_PERSON = "selectedPerson"
		static let SELECTED_PERSON_INDEX = "selectedPersonIndex"
        static let SELECTED_CATCHUP_INDEX = "selectedCatchupIndex"
        static let DATE_FORMAT = "h:mm a, d MMM, yyyy" // e.g. 4:30 PM, 28 March
    }
	
	
	struct LocalNotifications {
		static let ACTION_CATEGORY_IDENTIFIER = "ActionCategory"
		static let DONE_ACTION_IDENTIFIER = "DoneAction"
		static let DONE_ACTION_TITLE = "Complete"
		static let REMIND_ACTION_IDENTIFIER = "RemindAction"
		static let REMIND_ACTION_TITLE = "Remind in 30 minutes"
	}
	
	
	struct Purchases {
		static let PURCHASED_PRODUCTS = "PurchasedProducts"
		static let CURRENT_THEME = "CurrentTheme"
		static let PRODUCT_ID_PREFIX = "com.joeyt.contact.iap.theme."
		
		static let GRASSY_THEME = "grassy"
		static let SUNRISE_THEME = "sunrise"
		static let NIGHTLIGHT_THEME = "nightlight"
		static let SALVATION_THEME = "salvation"
		static let RIPE_THEME = "ripe"
		static let MALIBU_THEME = "malibu"
		static let LIFE_THEME = "life"
		static let FIRE_THEME = "fire"
		
		static let Colors: [String : [String]] = [
			GRASSY_THEME: ["009efd", "2af598"],
			SUNRISE_THEME: ["f6d365", "fda085"],
			NIGHTLIGHT_THEME: ["a18cd1", "fbc2eb"],
			SALVATION_THEME: ["f43b47", "453a94"],
			RIPE_THEME: ["f093fb", "f5576c"],
			MALIBU_THEME: ["4facfe", "00f2fe"],
			LIFE_THEME: ["43e97b", "38f9d7"],
			FIRE_THEME: ["fa709a", "fee140"]
		]
	}
	
	
	struct Strings {
		static let SHARE = "Check out " + Constants.Common.APPNAME + " on the App Store, where you can easily create reminders to contact your loved ones! #Contact #iOS \n\nDownload for free now: " + Constants.Common.LINK_IOS_STORE
		
		// Purchases
		static let PURCHASE_ERROR_CONTACT_US = " Please contact us."
		static let PURCHASE_ERROR_NOT_AVAILABLE = "The product is not available in the current storefront." + PURCHASE_ERROR_CONTACT_US
		static let PURCHASE_ERROR_IDENTIFIER_INVALID = "The purchase identifier was invalid." + PURCHASE_ERROR_CONTACT_US
		static let PURCHASE_ERROR_CANCELLED = "Your payment was cancelled." + PURCHASE_ERROR_CONTACT_US
		static let PURCHASE_ERROR_NOT_ALLOWED = "You are not allowed to make payments." + PURCHASE_ERROR_CONTACT_US
		static let PURCHASE_ERROR_UNKNOWN = "Unknown error." + PURCHASE_ERROR_CONTACT_US
		static let PURCHASE_RESTORE_ERROR = "Restore error." + PURCHASE_ERROR_CONTACT_US
		static let PURCHASE_RESTORE_NOTHING = "You have no purchases to restore!"
		static let PURCHASE_RESTORE_SUCCESS = "You have restored your previous purchase and now have access to the entire app!"
		
		// Send Feedback
		static let EMAIL = "joeytawadrous@gmail.com"
		static let SEND_FEEDBACK_SUBJECT = "Contact Feedback!"
		static let SEND_FEEDBACK_BODY = "I want to make Contact better. Here are my ideas... \n\n What I like about Contact: \n 1. \n 2. \n 3. \n\n What I don't like about Contact: \n 1. \n 2. \n 3. \n\n"
	}
	
	
	struct Views {
		static let CATCH_UPS = "CatchUps"
		static let CATCH_UP = "CatchUp"
		static let ADD_CATCH_UP = "AddCatchUp"
		static let SETTINGS = "Settings"
		static let THEMES = "Themes"
	}
}
