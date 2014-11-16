//
//  Match.h
//  tinder
//
//  Created by Alan McConnell on 11/14/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Match : NSObject

@property (strong, nonatomic) User* match;
@property (strong, nonatomic) NSDate* date;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* matchID;
@property (strong, nonatomic) NSString* lastMessage;

- (id)initWithMatch:(User *)match date:(NSDate *)date matchID:(NSString *)matchID lastMessage:(NSString *)lastMessage;

@end
