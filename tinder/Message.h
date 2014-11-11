//
//  Message.h
//  tinder
//
//  Created by Gaurav Menghani on 11/10/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
// Both 'from' and 'to' are unique id. Possibly we can reuse fb ids.
@property NSUInteger from;
@property NSUInteger to;
@property NSString* text;
@property (strong, nonatomic) NSDate* date;
@end
