//
//  User.m
//  tinder
//
//  Created by Gaurav Menghani on 11/10/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "User.h"
#import "Match.h"
#import "Message.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@implementation User

static User* _currentUser;
+ (User*)user {
    return _currentUser;
}

+ (PFUser*)pfUser {
    if (_currentUser == nil) {
        return nil;
    }
    return _currentUser.pfUser;
}

+ (void)logout {
    User* user = [User user];
    if (user != nil) {
        // TODO
    }
}

+ (void)populateFromPFUser {
    PFUser* user = [PFUser currentUser];
    _currentUser = [[User alloc] initFromPFUser:user];
}

// Populate User from PFUser object
- (User*)initFromPFUser:(PFUser *)user {
    self = [super init];
    if (self) {
        _fbid = user[@"fbid"];
        _name = user[@"name"];
        _first_name = user[@"first_name"];
        _last_name = user[@"last_name"];
        _location = user[@"location"];
        _profileImageURL = [NSURL URLWithString:user[@"profileImgUrl"]];
        if (user[@"preferences_set"] != nil) {
            _preferences_set = [user[@"preferences_set"] boolValue];
        } else {
            _preferences_set = NO;
        }
        _age = [(NSNumber *)user[@"age"] integerValue];
        _budget = [(NSNumber *)user[@"budget"] integerValue];
        _desc = user[@"desc"];
        _likesUs = false;
        _pfUser = user;
    }
    return self;
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
                    
                    NSLog(@"Image Req");
                    FBRequest *imgReq = [FBRequest requestForGraphPath:@"/me/picture?redirect=false&height=300&type=normal&width=300"];
                    [imgReq startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                        // NSLog(@"Img Req done");
                        if (error == nil) {
                            NSDictionary* dict = (NSDictionary*)result;
                            NSLog(@"Dict: %@", dict);
                            user[@"profileImgUrl"] = dict[@"data"][@"url"];
                            // user[@"populated"] = @(YES);
                            [user saveInBackground];
                        } else {
                            NSLog(@"Error: %@", error);
                        }
                    }];
                    
                    // user[@"populated"] = @(YES);
                    [user saveInBackground];
                    /*
                    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                    */
                    NSLog(@"Populating from PF User");
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

- (void)messagesWithUser:(User *)fromUser withCompletion:(void(^)(NSArray *messages))completion {
    PFQuery *fromQuery = [PFQuery queryWithClassName:@"messages"];
    [fromQuery whereKey:@"sender_fbid" equalTo:[User user].fbid];
    [fromQuery whereKey:@"recipient_fbid" equalTo:fromUser.fbid];
    
    PFQuery *toQuery = [PFQuery queryWithClassName:@"messages"];
    [fromQuery whereKey:@"sender_fbid" equalTo:fromUser.fbid];
    [fromQuery whereKey:@"recipient_fbid" equalTo:[User user].fbid];

    PFQuery *query = [PFQuery orQueryWithSubqueries:@[fromQuery, toQuery]];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *messages = [NSMutableArray array];
        for (PFObject *object in objects) {
            [messages addObject:[[Message alloc] initWithPFObject:object]];
        }
        completion(messages);
    }];
}

// Get the matches for a user
-(void)matchesWithCompletion:(void(^)(NSArray *matches))completion {
    PFQuery *fromQuery = [PFQuery queryWithClassName:@"matches"];
    [fromQuery whereKey:@"from" equalTo:[PFUser currentUser]];
    [fromQuery whereKey:@"matched" equalTo:@YES];
    [fromQuery includeKey:@"to"];
    [fromQuery orderByDescending:@"createdAt"];

    PFQuery *toQuery = [PFQuery queryWithClassName:@"matches"];
    [toQuery whereKey:@"to" equalTo:[PFUser currentUser]];
    [toQuery whereKey:@"matched" equalTo:@YES];
    [toQuery includeKey:@"from"];
    [toQuery orderByDescending:@"createdAt"];
    
    NSMutableArray *matches = [NSMutableArray array];
    [fromQuery findObjectsInBackgroundWithBlock:^(NSArray *fromObjects, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
            completion(nil);
            return;
        }
        
        [toQuery findObjectsInBackgroundWithBlock:^(NSArray *toObjects, NSError *error) {

            for (PFObject *fromObject in fromObjects) {
                User *match = [[User alloc] initFromPFUser:fromObject[@"to"]];
                [matches addObject:[[Match alloc] initWithMatch:match
                                                           date:fromObject.createdAt
                                                        matchID:fromObject.objectId
                                                    lastMessage:fromObject[@"last_message"]]];
            }
            for (PFObject *toObject in toObjects) {
                User *match = [[User alloc] initFromPFUser:toObject[@"from"]];
                [matches addObject:[[Match alloc] initWithMatch:match
                                                           date:toObject.createdAt
                                                        matchID:toObject.objectId
                                                    lastMessage:toObject[@"last_message"]]];
            }
            completion(matches);
        }];
    }];
}

@end
