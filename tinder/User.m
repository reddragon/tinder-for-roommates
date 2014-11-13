//
//  User.m
//  tinder
//
//  Created by Gaurav Menghani on 11/10/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "User.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@implementation User

static User* _currentUser;
+ (User*)user {
    return _currentUser;
}

+ (void)logout {
    User* user = [User user];
    if (user != nil) {
        // TODO
    }
}

- (NSArray *)messagesFromUser:(NSUInteger)fromUser {
    return @[];

+ (void)populateFromPFUser {
    PFUser* user = [PFUser currentUser];
    _currentUser = [[User alloc] init];
    _currentUser.fbid = user[@"fbid"];
    _currentUser.name = user[@"name"];
    _currentUser.first_name = user[@"first_name"];
    _currentUser.last_name = user[@"last_name"];
    _currentUser.location = user[@"location"];
    if (user[@"preferences_set"] != nil) {
        _currentUser.preferences_set = [user[@"preferences_set"] boolValue];
    } else {
        _currentUser.preferences_set = NO;
    }
}

// This method tries to fill up the PFUser model
+ (void)setUpWithCompletion:(void(^)(void))completion {
    PFUser* user = [PFUser currentUser];
    if (user != nil) {
        if (user[@"populated"] == nil) {
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSDictionary *userData = (NSDictionary *)result;
                    // NSLog(@"Dict: %@", userData);
                    
                    NSString *location = userData[@"location"][@"name"];
                    if (location != nil) {
                        user[@"location"] = location;
                    }
                    
                    user[@"fbid"] = userData[@"id"];
                    user[@"name"] = userData[@"name"];
                    user[@"first_name"] = userData[@"first_name"];
                    user[@"last_name"] = userData[@"last_name"];
                    user[@"gender"] = userData[@"gender"];
                    // NSString *birthday = userData[@"birthday"];
                    // NSString *relationship = userData[@"relationship_status"];
                    
                    user[@"populated"] = @(YES);
                    [user saveInBackground];
                    /*
                    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                    */
                    [User populateFromPFUser];
                    NSLog(@"User: %@", [[User user] name]);
                    
                } else {
                    NSLog(@"Seems to be an error: %@", error);
                }
                completion();
            }];
        } else {
            NSLog(@"Not making the request");
            [User populateFromPFUser];
            NSLog(@"User: %@", [[User user] name]);
            completion();
        }
    }
}

@end
