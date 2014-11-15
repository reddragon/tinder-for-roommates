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

@property (strong, nonatomic) NSString *senderFBID;
@property (strong, nonatomic) NSString *recipientFBID;
@property (strong, nonatomic) NSString *senderDisplayName;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate* date;

- (id)initWithPFObject:(PFObject *)object;
- (id)initWithSender:(NSString *)senderFBID recipient:(NSString *)recipientFBID senderDisplayName:(NSString *)displayName text:(NSString *)text date:(NSDate *)date;

- (void)saveInBackgroundWithCompletion:(void(^)(BOOL succeeded, NSError *error))completion;

@end
