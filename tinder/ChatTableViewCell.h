//
//  ChatTableViewCell.h
//  tinder
//
//  Created by Alan McConnell on 11/14/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Message.h"

@interface ChatTableViewCell : UITableViewCell

@property (strong, nonatomic) User *user;

@end
