//
//  MatchUserCardView.h
//  tinder
//
//  Created by Alan McConnell on 11/18/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class MatchUserCardView;

@protocol MatchUserCardViewDelegate <NSObject>

- (void)didLike:(BOOL)like user:(User *)user;
- (MatchUserCardView *)bottomCard;

@end

@interface MatchUserCardView : UIView

@property (strong, nonatomic) User *user;
@property (weak, nonatomic) id<MatchUserCardViewDelegate> delegate;
@end
