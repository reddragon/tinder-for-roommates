//
//  SearchingForPeopleVC.m
//  tinder
//
//  Created by Gaurav Menghani on 11/15/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "SearchingForPeopleVC.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface SearchingForPeopleVC ()
@property (strong, nonatomic) IBOutlet UIView *radarView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImg;

@end

@implementation SearchingForPeopleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    User* user = [User user];
    if (user.profileImage) {
        [self.profileImg setImage:user.profileImage];
    } else {
        [self.profileImg setImageWithURL:user.profileImageURL];
    }
    [self prettifyImage:self.profileImg];
    
    CGSize radarSize = self.radarView.frame.size;
    self.radarView.layer.borderColor = [[UIColor redColor] CGColor];
    self.radarView.layer.borderWidth = 2.0f;
    self.radarView.layer.cornerRadius = radarSize.width / 2.0;
    self.radarView.backgroundColor = [UIColor orangeColor];
    self.radarView.alpha = 0.3;
    [self animateRadar];
}

- (void)prettifyImage:(UIImageView*) imgView {
    [imgView.layer setCornerRadius:imgView.frame.size.width / 2];
    imgView.clipsToBounds = YES;
    imgView.layer.borderWidth = 3.0f;
    imgView.layer.borderColor = [UIColor colorWithRed:220/255.0 green:235/255.0 blue:252.0/255.0 alpha:1.0].CGColor;
}


- (void)animateRadar {
    [UIView animateWithDuration:2.0 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(1/4.0, 1/4.0);
        self.radarView.transform = transform;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.radarView.transform = transform;
        } completion:^(BOOL finished) {
            [self animateRadar];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
