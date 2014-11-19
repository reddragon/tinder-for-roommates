//
//  MatchUserCardView.m
//  tinder
//
//  Created by Alan McConnell on 11/18/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "MatchUserCardView.h"
#import "UIImageView+AFNetworking.h"

@interface MatchUserCardView()

@property (assign, nonatomic) CGPoint originalCenter;
@property (assign, nonatomic) CGPoint bottomCenter;
@property (assign, nonatomic) CGPoint paddingCenter;

@property (strong, nonatomic) UIImageView *profileImage;
@property (strong, nonatomic) UILabel *profileLabel;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation MatchUserCardView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setup];
    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;
    [_profileImage setImageWithURL:_user.profileImageURL placeholderImage:[UIImage imageNamed:@"Profile"]];
    
    NSString *userString = [NSString stringWithFormat:@"%@, %lu", _user.first_name, (unsigned long)_user.age];
    _profileLabel.text = userString;
    
    [self setNeedsLayout];
}

- (void)setup {
    self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      self.frame.size.width,
                                                                      self.frame.size.height - 40)];
    self.profileLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                  self.profileImage.frame.size.height,
                                                                  self.frame.size.width,
                                                                  self.frame.size.height - self.profileImage.frame.size.height)];
    
    self.profileLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height + 40)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    self.clipsToBounds = YES;
    
    // border radius
    [self.layer setCornerRadius:5.0f];
    
    // border
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.layer setBorderWidth:1.0f];
    
    [self.containerView addSubview:self.profileImage];
    [self.containerView addSubview:self.profileLabel];
    
    [self addSubview:self.containerView];
}

- (void)onPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    CGFloat xDistance = [panGestureRecognizer translationInView:self].x;
    CGFloat yDistance = [panGestureRecognizer translationInView:self].y;
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.originalCenter = self.center;
            self.bottomCenter = [self.delegate bottomCard].center;
            self.paddingCenter = [self.delegate paddingCard].center;
            break;
        };
        case UIGestureRecognizerStateChanged:{
            CGFloat rotationStrength = MIN(xDistance / [[UIScreen mainScreen] bounds].size.width, 1);
            CGFloat rotationAngel = (CGFloat) (2*M_PI * rotationStrength / 16);
            CGFloat scaleStrength = 1 - fabsf(rotationStrength) / 4;
            CGFloat scale = MAX(scaleStrength, 0.93);
            self.center = CGPointMake(self.originalCenter.x + xDistance, self.originalCenter.y + yDistance);

            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.transform = scaleTransform;

            CGFloat growScale = 1 + fabsf(xDistance / [[UIScreen mainScreen] bounds].size.width / 18);
            MatchUserCardView * bottomCard = [self.delegate bottomCard];
            bottomCard.center = CGPointMake(bottomCard.center.x, (self.originalCenter.y + 5) - (fabsf(xDistance) / 12));
            bottomCard.transform = CGAffineTransformMakeScale(growScale, growScale);

            MatchUserCardView * paddingCard = [self.delegate paddingCard];
            paddingCard.center = CGPointMake(paddingCard.center.x, (self.originalCenter.y + 10) - (fabsf(xDistance) / 15));
            paddingCard.transform = CGAffineTransformMakeScale(growScale, growScale);
            
            [self setNeedsLayout];
            break;
        };
        case UIGestureRecognizerStateEnded: {
            if (xDistance > 100.0) {
                [self nextCardWithLike:YES];
            } else if (xDistance < -100.0) {
                [self nextCardWithLike:NO];
            } else {
                [self reset];
            }
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

- (void)reset {
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:20 options:0 animations:^{
        self.center = self.originalCenter;
        self.transform = CGAffineTransformIdentity;
        
        MatchUserCardView *bottomCard = [self.delegate bottomCard];
        bottomCard.transform = CGAffineTransformIdentity;
        bottomCard.center = self.bottomCenter;

        MatchUserCardView *paddingCard = [self.delegate paddingCard];
        paddingCard.center = self.paddingCenter;
        paddingCard.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self setNeedsLayout];
    }];
}

- (void)nextCardWithLike:(BOOL)like {
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
        if (like) {
            self.center = CGPointMake(1080, self.center.y);
        } else {
            self.center = CGPointMake(-1080, self.center.y);
        }
        [self.delegate bottomCard].transform = CGAffineTransformIdentity;
        [self.delegate bottomCard].frame = CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height - 5);

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.delegate didLike:like user:self.user];
        [self setNeedsLayout];
    }];
}

@end
