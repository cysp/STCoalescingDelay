//
//  STCoalescingDelay.m
//  STCoalescingDelay
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Scott Talbot. All rights reserved.
//

#import "STCoalescingDelay.h"


uint64_t const kTimerLeeway = 50 * NSEC_PER_MSEC;


@implementation STCoalescingDelay {
@private
	int64_t _delay;
	int64_t _maximumDelay;
	dispatch_source_t _sourceDelay;
	dispatch_source_t _sourceMaximumDelay;
	dispatch_source_t _source;
	dispatch_block_t _block;
	BOOL _armed;
}

- (id)initWithDelay:(NSTimeInterval)delay maximumDelay:(NSTimeInterval)maximumDelay block:(dispatch_block_t)block {
	NSAssert([NSThread isMainThread], @"not on main thread", nil);

	if ((self = [super init])) {
		_delay = (int64_t)(delay * NSEC_PER_SEC);
		_maximumDelay = (int64_t)(maximumDelay * NSEC_PER_SEC);
		_block = [block copy];

		dispatch_queue_t const queue = dispatch_get_main_queue();

		_source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_OR, 0, 0, queue);
		{
			__weak __typeof__(self) wself = self;
			dispatch_source_set_event_handler(_source, ^{
				__strong __typeof__(self) sself = wself;
				if (!sself) {
					return;
				}
				if (!sself->_armed) {
					return;
				}
				sself->_armed = NO;
				dispatch_source_set_timer(sself->_sourceDelay, DISPATCH_TIME_FOREVER, DISPATCH_TIME_FOREVER, kTimerLeeway);
				dispatch_source_set_timer(sself->_sourceMaximumDelay, DISPATCH_TIME_FOREVER, DISPATCH_TIME_FOREVER, kTimerLeeway);
				if (sself->_block) {
					sself->_block();
				}
			});
		}

		_sourceDelay = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
		dispatch_source_set_timer(_sourceDelay, DISPATCH_TIME_FOREVER, DISPATCH_TIME_FOREVER, kTimerLeeway);

		_sourceMaximumDelay = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
		dispatch_source_set_timer(_sourceMaximumDelay, DISPATCH_TIME_FOREVER, DISPATCH_TIME_FOREVER, kTimerLeeway);

		{
			__weak __typeof__(self) wself = self;
			dispatch_block_t timerEventHandler = ^{
				__strong __typeof__(self) sself = wself;
				if (!sself) {
					return;
				}
				dispatch_source_merge_data(sself->_source, 1);
			};

			dispatch_source_set_event_handler(_sourceDelay, timerEventHandler);
			dispatch_source_set_event_handler(_sourceMaximumDelay, timerEventHandler);
		}

		dispatch_resume(_sourceDelay);
		dispatch_resume(_sourceMaximumDelay);
		dispatch_resume(_source);
	}
	return self;
}

- (void)dealloc {
	dispatch_source_cancel(_source);
	dispatch_source_cancel(_sourceDelay);
	dispatch_source_cancel(_sourceMaximumDelay);
#if !OS_OBJECT_USE_OBJC_RETAIN_RELEASE
	dispatch_release(_source);
	dispatch_release(_sourceDelay);
	dispatch_release(_sourceMaximumDelay);
#endif
}

- (void)trigger {
	NSAssert([NSThread isMainThread], @"not on main thread", nil);

	if (!_armed) {
		dispatch_source_set_timer(_sourceMaximumDelay, dispatch_time(DISPATCH_TIME_NOW, _maximumDelay), DISPATCH_TIME_FOREVER, kTimerLeeway);
	}
	dispatch_source_set_timer(_sourceDelay, dispatch_time(DISPATCH_TIME_NOW, _delay), DISPATCH_TIME_FOREVER, kTimerLeeway);
	_armed = YES;
}

@end
