//
//  STCoalescingDelayDemoAppDelegate.m
//  STCoalescingDelayDemo-ios
//
//  Copyright (c) 2013 Scott Talbot. All rights reserved.
//

#import "STCoalescingDelayDemoAppDelegate.h"

#import "STCoalescingDelayDemoViewController.h"


@implementation STCoalescingDelayDemoAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	window.rootViewController = [STCoalescingDelayDemoViewController viewController];

	self.window = window;

	return YES;
}

- (void)setWindow:(UIWindow *)window {
	_window = window;
	[_window makeKeyAndVisible];
}

@end
