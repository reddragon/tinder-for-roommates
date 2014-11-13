//
//  Message.m
//  tinder
//
//  Created by Gaurav Menghani on 11/10/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "Message.h"

@implementation Message

- (NSString *)senderId {
    return @"1";
    return [NSString stringWithFormat:@"%ld", (long)self.sender.fbid];
}

- (NSString *)senderDisplayName {
    return @"Alan";
    return self.sender.name;
}

- (NSDate *)date {
    return self.date;
}

- (BOOL)isMediaMessage {
    return NO;
}

@end
