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

+ (void)logout {
    User* user = [User user];
    if (user != nil) {
        // TODO
    }
}

+ (void)populateFromPFUser {
    PFUser* user = [PFUser currentUser];
    _currentUser = [[User alloc] init];
    _currentUser.fbid = user[@"fbid"];
    _currentUser.name = user[@"name"];
    _currentUser.first_name = user[@"first_name"];
    _currentUser.last_name = user[@"last_name"];
    _currentUser.location = user[@"location"];
    _currentUser.profileImageURL =  [NSURL URLWithString:user[@"profileImgUrl"]];

    if (user[@"preferences_set"] != nil) {
        _currentUser.preferences_set = [user[@"preferences_set"] boolValue];
    } else {
        _currentUser.preferences_set = NO;
    }
    // _currentUser.image = [UIImage imageWithData:[user[@"image"] getData]];
    _currentUser.age = [(NSNumber *)user[@"age"] integerValue];
    _currentUser.budget = [(NSNumber *)user[@"budget"] integerValue];
    _currentUser.desc = user[@"desc"];
}

// Populate User from PFUser object
- (id)initFromPFUser:(PFUser *)user {
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
    }
    return self;
}

// This method tries to fill up the PFUser model
+ (void)setUpWithCompletion:(void(^)(void))completion {
    PFUser* user = [PFUser currentUser];
    if (user != nil) {
        if (user[@"populated"] == nil) {
            NSLog(@"Setting up the FBR");
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                NSLog(@"FBR got completed");
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
                        NSLog(@"Img Req done");
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
    [fromQuery includeKey:@"from"];
    [fromQuery orderByDescending:@"createdAt"];
    
    [fromQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *matches = [NSMutableArray array];
        for (PFObject *object in objects) {
            User *match;
            if (object[@"to"][@"fbid"] == [User user].fbid) {
                match = [[User alloc] initFromPFUser:object[@"from"]];
            } else {
                match = [[User alloc] initFromPFUser:object[@"to"]];
            }
            [matches addObject:[[Match alloc] initWithMatch:match
                                                       date:object.createdAt
                                                    matchID:object.objectId
                                                lastMessage:object[@"last_message"]]];
        }
        completion(matches);
    }];
}

@end
