//
//  STCoalescingDelayDemoViewController.m
//  STCoalescingDelayDemo-ios
//
//  Copyright (c) 2013 Scott Talbot. All rights reserved.
//

#import "STCoalescingDelayDemoViewController.h"

#import "STCoalescingDelay.h"


@implementation STCoalescingDelayDemoViewController {
	STCoalescingDelay *_delay;
}

+ (instancetype)viewController {
	return [[self alloc] initWithNibName:nil bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		_delay = [[STCoalescingDelay alloc] initWithDelay:5 maximumDelay:22 block:^{
			NSLog(@"fired");
		}];
	}
	return self;
}


- (void)loadView {
	UIView * const view = [[UIView alloc] initWithFrame:(CGRect){ .size = { .width = 768, .height = 1024 } }];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	view.backgroundColor = [UIColor whiteColor];
	self.view = view;
	CGRect const bounds = view.bounds;

	UIButton * const button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
	[button setTitle:@"Kick!" forState:UIControlStateNormal];
	[button sizeToFit];
	button.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetHeight(bounds) * .3);

	[button addTarget:self action:@selector(kickButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

	[view addSubview:button];
}


- (void)kickButtonTapped:(id)sender {
	NSLog(@"kicked");
	[_delay trigger];
}

@end
