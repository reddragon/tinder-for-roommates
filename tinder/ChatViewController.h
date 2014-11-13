//
//  ChatViewController.h
//  tinder
//
//  Created by Alan McConnell on 11/11/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessages.h"
#import "User.h"

@class JSQMessagesViewController;

@interface ChatViewController : JSQMessagesViewController

@property (weak, nonatomic) User* match;

@end
