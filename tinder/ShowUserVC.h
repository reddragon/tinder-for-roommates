//
//  ShowUserVC.h
//  tinder
//
//  Created by Gaurav Menghani on 11/15/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowUserDelegate <NSObject>
- (void)onDoneWithUserList;

@end

@interface ShowUserVC : UIViewController
@property (strong, nonatomic) id<ShowUserDelegate> delegate;
- (void)addNewUsersToShow:(NSMutableArray*) users;
@end
