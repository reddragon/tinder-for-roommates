//
//  MatchUserView.h
//  tinder
//
//  Created by Alan McConnell on 11/18/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "MatchUserCardView.h"

@protocol MatchUserViewDelegate <NSObject>

- (void)didLike:(BOOL)like user:(User *)user;
- (void)didTapOnImageOfUser:(User*)user;

@end

@interface MatchUserView : UIView <MatchUserCardViewDelegate>

@property (strong, nonatomic) NSArray *users;

@property (strong, nonatomic) MatchUserCardView *topCard;
@property (strong, nonatomic) MatchUserCardView *bottomCard;
@property (strong, nonatomic) MatchUserCardView *paddingCard;

@property (weak, nonatomic) id<MatchUserViewDelegate> delegate;

@end
