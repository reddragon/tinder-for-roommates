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
@property NSString* fbid;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* first_name;
@property (strong, nonatomic) NSString* last_name;
@property (strong, nonatomic) NSString* location;
@property BOOL preferences_set;

// TODO Fill age
@property NSUInteger age;
// TODO Fill image
@property (strong, nonatomic) UIImage* image;
// TODO Fill description
@property (strong, nonatomic) NSString* desc;
// Keeping the budge simple by taking an upper limit (non-float)
@property NSUInteger budget;


// Currently logged in user
+ (User*)user;
+ (void)logout;
+ (void)setUpWithCompletion:(void(^)(void))completion;
@end
