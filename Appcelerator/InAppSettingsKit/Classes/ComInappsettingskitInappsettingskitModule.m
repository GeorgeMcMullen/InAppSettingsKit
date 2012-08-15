/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComInappsettingskitInappsettingskitModule.h"
#import "TiApp.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

#import "IASKSpecifier.h"
#import "IASKSettingsReader.h"

#import "CustomViewCell.h"

@implementation ComInappsettingskitInappsettingskitModule

@synthesize appSettingsViewController;

-(UIView*)createView
{
    if (view==nil)
    {
        view = self.appSettingsViewController.view;
//        [TiUtils setView:view positionRect:CGRectMake(0,0,320,480)];
    }
    return view;
}

#pragma mark InAppSettingsKit

- (IASKAppSettingsViewController*)appSettingsViewController {
	if (!appSettingsViewController) {
		appSettingsViewController = [[IASKAppSettingsViewController alloc] initWithNibName:@"IASKAppSettingsView" bundle:nil];
		appSettingsViewController.delegate = self;
	}
	return appSettingsViewController;
}

- (void)showSettingsPush:(id)args
{
    // Not implemented yet
/*
	//[viewController setShowCreditsFooter:NO];   // Uncomment to not display InAppSettingsKit credits for creators.
	// But we encourage you no to uncomment. Thank you!
	self.appSettingsViewController.showDoneButton = NO;
	[self.navigationController pushViewController:self.appSettingsViewController animated:YES];
 */
}

- (void)showSettingsModal:(id)args
{
    ENSURE_UI_THREAD(showSettingsModal, nil);
    UINavigationController *aNavController = [[UINavigationController alloc] initWithRootViewController:self.appSettingsViewController];
    //[viewController setShowCreditsFooter:NO];   // Uncomment to not display InAppSettingsKit credits for creators.
    // But we encourage you not to uncomment. Thank you!
    self.appSettingsViewController.showDoneButton = YES;
    [[TiApp app] showModalController: aNavController animated: YES];
    [aNavController release];
}

- (void)showSettingsPopover:(id)args
{
    // Not implemented yet
    /*
    UINavigationController *aNavController = [[UINavigationController alloc] initWithRootViewController:self.appSettingsViewController];
    //[viewController setShowCreditsFooter:NO];   // Uncomment to not display InAppSettingsKit credits for creators.
    // But we encourage you not to uncomment. Thank you!
    self.appSettingsViewController.showDoneButton = YES;

    self.appSettingsPopoverController = [[[UIPopoverController alloc] initWithContentViewController:aNavController] autorelease];
    appSettingsPopoverController.delegate = self;

    [self.appSettingsPopoverController presentPopoverFromBarButtonItem:sender
                                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                                              animated:YES];
     */
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
    // We propably should perform a test on sender to see if it came from a modal view or popover

    // For some reason, hideModalController requires the view controller to hide, even though it should only be one because it's a MODAL!
    // It seems to work if we pass nil for now, which is easier.
    [[TiApp app] hideModalController:nil animated:YES];

    // Fire an event back to the main app so that the modals can be dismissed and settings can be reloaded
    //NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:nil,nil];
    [super fireEvent:@"settingsViewControllerDidEnd"];
}

// optional delegate method for handling mail sending result
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    // Not implemented yet
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderForKey:(NSString*)key {
	if ([key isEqualToString:@"IASKLogo"]) {
		return [UIImage imageNamed:@"Icon.png"].size.height + 25;
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderForKey:(NSString*)key {
	if ([key isEqualToString:@"IASKLogo"]) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon.png"]];
		imageView.contentMode = UIViewContentModeCenter;
		return [imageView autorelease];
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

#pragma mark UITextViewDelegate (for CustomViewCell)
- (void)textViewDidChange:(UITextView *)textView {
// Not implemented yet
//    [[NSUserDefaults standardUserDefaults] setObject:textView.text forKey:@"customCell"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:@"customCell"];
}

#pragma mark -
- (void)settingsViewController:(IASKAppSettingsViewController*)sender buttonTappedForKey:(NSString*)key {
    // We just fire an event saying we hit a button and let the app decide what to do
    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:key, @"key", nil];
    [self fireEvent:@"buttonTappedForKey" withObject:event];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"0e715eb6-95fc-4096-b545-38b2f29f1479";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.inappsettingskit.inappsettingskit";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
    
	[IASKSettingsReader setApplicationDefaultPreferences];
    
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
//    [appSettingsPopoverController release];
//    appSettingsPopoverController = nil;

	[appSettingsViewController release];
	appSettingsViewController = nil;

	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];

    // Release any cached data, images, etc that aren't in use.
    [appSettingsViewController release];
	self.appSettingsViewController = nil;
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

/*
#pragma Public APIs

-(id)example:(id)args
{
	// example method
	return @"hello world";
}

-(id)exampleProp
{
	// example property getter
	return @"hello world";
}

-(void)setExampleProp:(id)value
{
	// example property setter
}
*/
@end
