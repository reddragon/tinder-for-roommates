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

- (void)setMatch:(Match *)match {
    _match = match;
    User *user = match.match;
    
    CGFloat cornerRadius = self.profileImageView.frame.size.width / 2;

    UIImage *defaultAvatar = [UIImage imageNamed:@"Profile"];
    [self.profileImageView setImageWithURL:user.profileImageURL placeholderImage:defaultAvatar];
    self.profileImageView.layer.cornerRadius = cornerRadius;
    [self.profileImageView.layer setMasksToBounds:YES];
    self.profileImageView.clipsToBounds = YES;

    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(1, 1);
    self.containerView.layer.shadowOpacity = 0.5;
    self.containerView.layer.shadowRadius = 2.0;
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds
                                                                     cornerRadius:cornerRadius].CGPath;
    
    self.nameLabel.text = user.first_name;
    
    if (self.match.lastMessage != nil) {
        self.subtitleLabel.text = self.match.lastMessage;
    } else {
        self.subtitleLabel.text = [NSString stringWithFormat:@"Matched at %@", self.match.date];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
