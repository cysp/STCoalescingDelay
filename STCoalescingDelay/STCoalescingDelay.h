//
//  STCoalescingDelay.h
//  STCoalescingDelay
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Scott Talbot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STCoalescingDelay : NSObject

- (id)initWithDelay:(NSTimeInterval)delay maximumDelay:(NSTimeInterval)maximumDelay block:(dispatch_block_t)block;

- (void)trigger;

@end
