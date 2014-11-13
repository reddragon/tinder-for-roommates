//
//  Message.h
//  tinder
//
//  Created by Gaurav Menghani on 11/10/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessages.h"
#import "User.h"

@interface Message : NSObject <JSQMessageData>

@property NSUInteger sendId;
@property NSUInteger to;
@property NSString* text;
@property (strong, nonatomic) NSDate* date;

@property User *sender;


@end
