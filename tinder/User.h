//
//  User.h
//  tinder
//
//  Created by Gaurav Menghani on 11/10/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class User;

@interface User : NSObject
@property (strong, nonatomic) NSString* name;
@property NSUInteger age;
@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) NSString* desc;
// Keeping the budge simple by taking an upper limit (non-float)
@property NSUInteger budget;
@property NSUInteger fbid;

// Currently logged in user
+ (User*)user;
+ (void)logout;

@end
