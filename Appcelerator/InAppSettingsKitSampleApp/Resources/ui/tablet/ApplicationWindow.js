function ApplicationWindow(title) {
	var self = Ti.UI.createWindow({
		title:title,
		backgroundColor:'white'
	});
	
	var button = Ti.UI.createButton({
		height:44,
		width:200,
		title:L('openWindow'),
		top:20
	});
	self.add(button);

	var inAppSettingsKit = require("com.inappsettingskit.inappsettingskit");
	Ti.API.info("module is => "+inAppSettingsKit);
	
	inAppSettingsKit.addEventListener('settingsViewControllerDidEnd', function(data) {
		Ti.API.info("settingsViewControllerDidEnd");
	});
	
	button.addEventListener('click', function() {
		//containingTab attribute must be set by parent tab group on
		//the window for this work
		
		Ti.API.info("in event module is => "+inAppSettingsKit);
		inAppSettingsKit.showSettingsModal();
/*		
		var settingsWin = Ti.UI.createWindow({
			title: L('newWindow'),
			backgroundColor: 'white'
		});
		Ti.API.info("test1");
		
		var inAppSettingsView = inAppSettingsKit.createView();

//		var inAppSettingsViewController=inAppSettingsKit.appSettingsViewController;

		Ti.API.info("test2");
		
		settingsWin.add(inAppSettingsView);
		Ti.API.info("test3");
		
		self.containingTab.open(settingsWin);
		Ti.API.info("test4");
		
//		self.containingTab.open(inAppSettingsKit.appSettingsViewController);
//		self.containingTab.open(Ti.UI.createWindow({
//			title: L('newWindow'),
//			backgroundColor: 'white'
//		}));
*/
	});

	return self;
};

module.exports = ApplicationWindow;
