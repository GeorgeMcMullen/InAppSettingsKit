/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"
#import "IASKAppSettingsViewController.h"

@interface ComInappsettingskitInappsettingskitModule : TiModule <IASKSettingsDelegate, UITextViewDelegate, UIPopoverControllerDelegate>
{
    IASKAppSettingsViewController *appSettingsViewController;
    UIView *view;
}

@property (nonatomic, retain) IASKAppSettingsViewController *appSettingsViewController;

@end
