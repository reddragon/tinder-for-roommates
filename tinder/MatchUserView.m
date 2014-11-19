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

@property (strong, nonatomic) MatchUserCardView *transitionCard;

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

        self.paddingCard = [[MatchUserCardView alloc] initWithFrame:CGRectMake(4, 10, self.frame.size.width - 8, self.frame.size.height - 5)];
        self.transitionCard = [[MatchUserCardView alloc] initWithFrame:CGRectMake(4, 10, self.frame.size.width - 8, self.frame.size.height - 5)];
    }
    
    [self setNeedsLayout];
}

- (void)didLike:(BOOL)like user:(User *)user {
    [self.topCard removeFromSuperview];
    self.topCard = nil;
    
    [self.bottomCard removeFromSuperview];
    self.bottomCard = nil;
    
    [self.paddingCard removeFromSuperview];
    self.paddingCard = nil;
    
    [self.transitionCard removeFromSuperview];
    self.transitionCard = nil;
    
    [self.delegate didLike:like user:user];
    
    [self setNeedsLayout];
}

- (void)didStartPanning {
    
}

- (void)didTapOnImageOfUser:(User *)user {
    if (self.delegate) {
        [self.delegate didTapOnImageOfUser:user];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.bottomCard != nil) {
        [self addSubview:self.transitionCard];
        [self addSubview:self.paddingCard];
        [self addSubview:self.bottomCard];
    }

    [self addSubview:self.topCard];
}

@end
