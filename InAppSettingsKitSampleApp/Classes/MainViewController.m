//
//  MainViewController.m
//  InAppSettingsKitSampleApp
//  http://www.inappsettingskit.com
//
//  Copyright (c) 2009-2010:
//  Luc Vandal, Edovia Inc., http://www.edovia.com
//  Ortwin Gentz, FutureTap GmbH, http://www.futuretap.com
//  All rights reserved.
// 
//  It is appreciated but not required that you give credit to Luc Vandal and Ortwin Gentz, 
//  as the original authors of this code. You can give credit in a blog post, a tweet or on 
//  a info page of your app. Also, the original authors appreciate letting them know if you use this code.
//
//  This code is licensed under the BSD license that is available at: http://www.opensource.org/licenses/bsd-license.php
//

#import "MainViewController.h"

#import <MessageUI/MessageUI.h>

#ifdef USES_IASK_STATIC_LIBRARY
  #import "InAppSettingsKit/IASKSettingsReader.h"
#else
  #import "IASKSettingsReader.h"
#endif

#import "CustomViewCell.h"

@interface MainViewController() 
- (void)settingDidChange:(NSNotification*)notification;
@end

@implementation MainViewController

@synthesize appSettingsPopoverController;
@synthesize appSettingsViewController, tabAppSettingsViewController;

- (IASKAppSettingsViewController*)appSettingsViewController {
	if (!appSettingsViewController) {
		appSettingsViewController = [[IASKAppSettingsViewController alloc] init];
		appSettingsViewController.delegate = self;
		BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoConnect"];
		appSettingsViewController.hiddenKeys = enabled ? nil : [NSSet setWithObjects:@"AutoConnectLogin", @"AutoConnectPassword", @"version", @"copyright", @"customCell2", @"customCellHeader", nil];
	}
	return appSettingsViewController;
}

- (IBAction)showSettingsPush:(id)sender {
	//[viewController setShowCreditsFooter:NO];   // Uncomment to not display InAppSettingsKit credits for creators.
	// But we encourage you no to uncomment. Thank you!
	self.appSettingsViewController.showDoneButton = NO;
	[self.navigationController pushViewController:self.appSettingsViewController animated:YES];
}

- (IBAction)showSettingsModal:(id)sender {
    UINavigationController *aNavController = [[UINavigationController alloc] initWithRootViewController:self.appSettingsViewController];
    //[viewController setShowCreditsFooter:NO];   // Uncomment to not display InAppSettingsKit credits for creators.
    // But we encourage you not to uncomment. Thank you!
    self.appSettingsViewController.showDoneButton = YES;
    [self presentModalViewController:aNavController animated:YES];
    [aNavController release];
}

- (IBAction)showSettingsPopover:(id)sender
{
    self.appSettingsViewController.showDoneButton = YES;
    UINavigationController *aNavController = [[UINavigationController alloc] initWithRootViewController:self.appSettingsViewController];
    //[viewController setShowCreditsFooter:NO];   // Uncomment to not display InAppSettingsKit credits for creators.
    // But we encourage you not to uncomment. Thank you!

    self.appSettingsPopoverController = [[[UIPopoverController alloc] initWithContentViewController:aNavController] autorelease];
    appSettingsPopoverController.delegate = self;

    [self.appSettingsPopoverController presentPopoverFromBarButtonItem:sender 
                                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                                              animated:YES];
}

- (void)awakeFromNib {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingDidChange:) name:kIASKAppSettingChanged object:nil];
	BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoConnect"];
	self.tabAppSettingsViewController.hiddenKeys = enabled ? nil : [NSSet setWithObjects:@"AutoConnectLogin", @"AutoConnectPassword", @"version", @"copyright", @"customCell2", @"customCellHeader", nil];

	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showSettingsPopover:)] autorelease];
	}
}

#pragma mark -
#pragma mark UIPopoverControllerDelegate protocol
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    // This gets called whenever someone taps anywhere outside the popover

	// your code here to reconfigure the app for changed settings
}

#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    [self dismissModalViewControllerAnimated:YES];

    [self.appSettingsPopoverController dismissPopoverAnimated:YES];
    // Since we dismissed it, we need to manually call the popoverControllerDidDismissPopover, since it won't get called automatically
    [self popoverControllerDidDismissPopover:nil];

	// your code here to reconfigure the app for changed settings
}

// optional delegate method for handling mail sending result
- (void)settingsViewController:(id<IASKViewController>)settingsViewController mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
       
    if ( error != nil ) {
        // handle error here
    }
    
    if ( result == MFMailComposeResultSent ) {
        // your code here to handle this result
    }
    else if ( result == MFMailComposeResultCancelled ) {
        // ...
    }
    else if ( result == MFMailComposeResultSaved ) {
        // ...
    }
    else if ( result == MFMailComposeResultFailed ) {
        // ...
    }
}
- (CGFloat)settingsViewController:(id<IASKViewController>)settingsViewController
                        tableView:(UITableView *)tableView 
        heightForHeaderForSection:(NSInteger)section {
  NSString* key = [settingsViewController.settingsReader keyForSection:section];
	if ([key isEqualToString:@"IASKLogo"]) {
		return [UIImage imageNamed:@"Icon.png"].size.height + 25;
	} else if ([key isEqualToString:@"IASKCustomHeaderStyle"]) {
		return 55.f;    
  }
	return 0;
}

- (UIView *)settingsViewController:(id<IASKViewController>)settingsViewController
                         tableView:(UITableView *)tableView 
               viewForHeaderForSection:(NSInteger)section {
  NSString* key = [settingsViewController.settingsReader keyForSection:section];
	if ([key isEqualToString:@"IASKLogo"]) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon.png"]];
		imageView.contentMode = UIViewContentModeCenter;
		return [imageView autorelease];
	} else if ([key isEqualToString:@"IASKCustomHeaderStyle"]) {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor redColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:16.f];
    
    //figure out the title from settingsbundle
    label.text = [settingsViewController.settingsReader titleForSection:section];
    
    return [label autorelease];
  }
	return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForSpecifier:(IASKSpecifier*)specifier {
	if ([specifier.key isEqualToString:@"customCell"]) {
		return 44*3;
	}
	return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForSpecifier:(IASKSpecifier*)specifier {
	CustomViewCell *cell = (CustomViewCell*)[tableView dequeueReusableCellWithIdentifier:specifier.key];
	
	if (!cell) {
		cell = (CustomViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"CustomViewCell" 
															   owner:self 
															 options:nil] objectAtIndex:0];
	}
	cell.textView.text= [[NSUserDefaults standardUserDefaults] objectForKey:specifier.key] != nil ? 
	 [[NSUserDefaults standardUserDefaults] objectForKey:specifier.key] : [specifier defaultStringValue];
	cell.textView.delegate = self;
	[cell setNeedsLayout];
	return cell;
}

#pragma mark kIASKAppSettingChanged notification
- (void)settingDidChange:(NSNotification*)notification {
	if ([notification.object isEqual:@"AutoConnect"]) {
		IASKAppSettingsViewController *activeController = self.tabBarController.selectedIndex ? self.tabAppSettingsViewController : self.appSettingsViewController;
		BOOL enabled = (BOOL)[[notification.userInfo objectForKey:@"AutoConnect"] intValue];
		[activeController setHiddenKeys:enabled ? nil : [NSSet setWithObjects:@"AutoConnectLogin", @"AutoConnectPassword", @"version", @"copyright", @"customCell2", @"customCellHeader", nil] animated:YES];
	}
}

#pragma mark UITextViewDelegate (for CustomViewCell)
- (void)textViewDidChange:(UITextView *)textView {
    [[NSUserDefaults standardUserDefaults] setObject:textView.text forKey:@"customCell"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:@"customCell"];
}

#pragma mark -
- (void)settingsViewController:(IASKAppSettingsViewController*)sender buttonTappedForSpecifier:(IASKSpecifier*)specifier {
	if ([specifier.key isEqualToString:@"ButtonDemoAction1"]) {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Demo Action 1 called" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alert show];
	} else if ([specifier.key isEqualToString:@"ButtonDemoAction2"]) {
		NSString *newTitle = [[[NSUserDefaults standardUserDefaults] objectForKey:specifier.key] isEqualToString:@"Logout"] ? @"Login" : @"Logout";
		[[NSUserDefaults standardUserDefaults] setObject:newTitle forKey:specifier.key];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidLoad {
    // This will add the settings button to the toolbar for the popover
    [[self navigationItem] setRightBarButtonItem:[[[UIBarButtonItem alloc] 
                                                   initWithTitle:@"Settings" 
                                                   style:UIBarButtonItemStyleBordered 
                                                   target:self
                                                   action:@selector(showSettingsPopover:)] autorelease]];
    
    // This should really go into the App Delegate, but since the main view controller loads the IASKAppSettingsViewController already
    // it is easier to implement here instead. This should only loaded once an app launch, and additional code to check whether or not
    // the app has already set defaults can be done prior to running this as well.
    [IASKSettingsReader setApplicationDefaultPreferences];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	self.appSettingsViewController = nil;
}

- (void)dealloc {
    [appSettingsPopoverController release];
    appSettingsPopoverController = nil;
    
	[appSettingsViewController release];
	appSettingsViewController = nil;
	[tabAppSettingsViewController release];
	tabAppSettingsViewController = nil;
	
    [super dealloc];
}


@end
