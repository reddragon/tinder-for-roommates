//
//  ProfileViewController.h
//  tinder
//
//  Created by Chia-Chi Lin on 11/17/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "User.h"

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

- (instancetype)init;
- (instancetype)initWithUser:(User *)user;

@end
