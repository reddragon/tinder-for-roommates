//
//  ChatViewController.h
//  tinder
//
//  Created by Alan McConnell on 11/11/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessages.h"
#import "Match.h"

@class JSQMessagesViewController;

@interface ChatViewController : JSQMessagesViewController

@property (strong, nonatomic) Match* match;

@end
