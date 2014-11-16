//
//  ChatTableViewCell.m
//  tinder
//
//  Created by Alan McConnell on 11/14/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface ChatTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation ChatTableViewCell

- (void)awakeFromNib {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setUser:(User *)user {
    _user = user;
    
    CGFloat cornerRadius = self.profileImageView.frame.size.width / 2;
    [self.profileImageView setImageWithURL:user.profileImageURL];
    self.profileImageView.layer.cornerRadius = cornerRadius;
    [self.profileImageView.layer setMasksToBounds:YES];
    self.profileImageView.clipsToBounds = YES;

    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(1, 1);
    self.containerView.layer.shadowOpacity = 0.5;
    self.containerView.layer.shadowRadius = 2.0;
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:cornerRadius].CGPath;
    
    self.nameLabel.text = user.name;
    self.subtitleLabel.text = @"Send a message...";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
