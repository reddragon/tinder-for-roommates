//
//  Like.h
//  tinder
//
//  Created by Gaurav Menghani on 11/10/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Like : NSObject
// A like can be one-way.
@property NSUInteger from;
@property NSUInteger to;
@end
