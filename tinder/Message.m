//
//  Message.m
//  tinder
//
//  Created by Gaurav Menghani on 11/10/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "Message.h"
#import <Parse/Parse.h>

@implementation Message

- (NSString *)senderId {
    return self.senderFBID;
}

- (BOOL)isMediaMessage {
    return NO;
}

- (id)initWithPFObject:(PFObject *)object {
    self = [super init];
    if (self) {
        _senderFBID = object[@"sender_fbid"];
        _recipientFBID = object[@"recipient_fbid"];
        _senderDisplayName = object[@"sender_name"];
        _text = object[@"text"];
        _date = object[@"createdAt"];
    }
    return self;
}

- (id)initWithSender:(NSString *)senderFBID
           recipient:(NSString *)recipientFBID
         senderDisplayName:(NSString *)displayName
                text:(NSString *)text
                date:(NSDate *)date {
    self = [super init];
    if (self) {
        _senderFBID = senderFBID;
        _senderDisplayName = displayName;
        _recipientFBID = recipientFBID;
        _text = text;
        _date = date;
    }
    return self;
}

- (void)saveInBackgroundWithCompletion:(void(^)(BOOL succeeded, NSError *error))completion {
    PFObject *object = [PFObject objectWithClassName:@"messages"];
    object[@"sender_fbid"] = self.senderFBID;
    object[@"recipient_fbid"] = self.recipientFBID;
    object[@"sender_name"] = self.senderDisplayName;
    object[@"text"] = self.text;
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(succeeded, error);
    }];
}

@end
