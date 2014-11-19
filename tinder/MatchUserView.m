//
//  MatchUserView.m
//  tinder
//
//  Created by Alan McConnell on 11/18/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "MatchUserView.h"
#import "UIImageView+AFNetworking.h"

@interface MatchUserView()

@property (strong, nonatomic) MatchUserCardView *topCard;

@end

@implementation MatchUserView

- (void)setUsers:(NSArray *)users {
    _users = users;
    
    self.topCard = [[MatchUserCardView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 5)];
    self.topCard.user = self.users[[self.users count] - 1];
    self.topCard.delegate = self;
    
    if ([self.users count] > 1) {
        self.bottomCard = [[MatchUserCardView alloc] initWithFrame:CGRectMake(2, 5, self.frame.size.width - 4, self.frame.size.height - 5)];
        self.bottomCard.user = self.users[[self.users count] - 2];
    }
    
    [self setNeedsLayout];
}

- (void)didLike:(BOOL)like user:(User *)user {
    [self.topCard removeFromSuperview];
    self.topCard = nil;
    
    [self.bottomCard removeFromSuperview];
    self.bottomCard = nil;
    
    [self.delegate didLike:like user:user];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.bottomCard != nil) {
        [self addSubview:self.bottomCard];
    }

    [self addSubview:self.topCard];
}

@end
