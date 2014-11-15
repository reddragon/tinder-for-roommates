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

@end

@implementation ChatTableViewCell

- (void)awakeFromNib {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setUser:(User *)user {
    _user = user;
    
    [self.profileImageView setImageWithURL:user.profileImageURL];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;

    self.nameLabel.text = user.name;
    self.subtitleLabel.text = @"Send a message...";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
