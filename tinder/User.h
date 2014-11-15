//
//  User.h
//  tinder
//
//  Created by Gaurav Menghani on 11/10/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "User.h"
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class User;

@interface User : NSObject

@property NSString* fbid;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* first_name;
@property (strong, nonatomic) NSString* last_name;
@property (strong, nonatomic) NSString* location;
@property (strong, nonatomic) UIImage* image;

@property BOOL preferences_set;

@property (strong, nonatomic) NSURL* profileImageURL;

// TODO Fill age
@property NSUInteger age;

// TODO Fill description
@property (strong, nonatomic) NSString* desc;

// Keeping the budge simple by taking an upper limit (non-float)
@property NSUInteger budget;

// Get an array of messages from another user
- (void)messagesWithUser:(User *)fromUser withCompletion:(void(^)(NSArray *messages))completion;

// Get the matches for a user
- (void)matchesWithCompletion:(void(^)(NSArray *matches))completion;

// Populate User from PFUser object
- (id)initFromPFUser:(PFUser *)pfUser;

// Currently logged in user
+ (User*)user;
+ (void)logout;
+ (void)setUpWithCompletion:(void(^)(void))completion;

@end
