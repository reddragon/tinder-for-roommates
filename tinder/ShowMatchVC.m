//
//  ShowMatchVC.m
//  tinder
//
//  Created by Gaurav Menghani on 11/16/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "ShowMatchVC.h"
#import "ChatViewController.h"

@interface ShowMatchVC ()

@property User* matchingUser;
@property (strong, nonatomic) IBOutlet UILabel *matchingUserName;
- (IBAction)onChat:(id)sender;
- (IBAction)onDismiss:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *chatButton;
@property (strong, nonatomic) IBOutlet UIButton *dismissButton;
@property (strong, nonatomic) IBOutlet UIImageView *leftImage;
@property (strong, nonatomic) IBOutlet UIImageView *rightImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftImageDistance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightImageDistance;

@end

@implementation ShowMatchVC

- (id)initWithMatchingUser:(User*)user {
    self.matchingUser = user;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.leftImage setImage:self.matchingUser.profileImage];
    [self.rightImage setImage:[[User user] profileImage]];
    
    [self prettifyImage:self.leftImage];
    [self prettifyImage:self.rightImage];
    
    [self.chatButton setTitle:[NSString stringWithFormat:@"   Message %@   ", self.matchingUser.first_name] forState:UIControlStateNormal];
    
    self.chatButton.layer.borderWidth = 1.0f;
    self.chatButton.layer.cornerRadius = 8.0;
    self.chatButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.dismissButton.layer.borderWidth = 1.0f;
    self.dismissButton.layer.cornerRadius = 8.0;
    self.dismissButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    /*
    CGPoint center = self.rightImage.center;
    CGPoint final = CGPointMake(center.x - 100, center.y);
    [UIView animateWithDuration:5.0 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.leftImageDistance.constant = 100.0;
        // [self.leftImage layoutIfNeeded];
    } completion:^(BOOL finished) {
        NSLog(@"Finished animating");
        // [self.leftImage layoutIfNeeded];
    }];
    
    [UIView animateWithDuration:3.0 animations:^{
        self.rightImage.transform = CGAffineTransformMakeScale(3.0, 3.0);
    }];
    */
}

- (void)viewDidAppear:(BOOL)animated {
    self.leftImageDistance.constant = -100.0;
    self.rightImageDistance.constant = 100.0;
    [self.leftImage layoutIfNeeded];
    [self.leftImage setHidden:NO];
    [self.rightImage setHidden:NO];
    [self.rightImage layoutIfNeeded];
    
    
    [UIView animateWithDuration:0.75 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:0 animations:^{
        self.leftImageDistance.constant = 45.0;
        self.rightImageDistance.constant = -45.0;
        [self.leftImage layoutIfNeeded];
        [self.rightImage layoutIfNeeded];
    } completion:^(BOOL finished) {
        NSLog(@"Finished animating");
    }];
}

- (void)prettifyImage:(UIImageView*) imgView {
    [imgView.layer setCornerRadius:imgView.frame.size.width / 2];
    imgView.clipsToBounds = YES;
    imgView.layer.borderWidth = 3.0f;
    imgView.layer.borderColor = [UIColor colorWithRed:220/255.0 green:235/255.0 blue:252.0/255.0 alpha:1.0].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentChat {
    ChatViewController *cvc = [[ChatViewController alloc] init];
    cvc.match = self.matchingUser;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
    [self.view.window.rootViewController presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)onChat:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [self performSelector:@selector(presentChat) withObject:self afterDelay:0.51];
    }];
}

- (IBAction)onDismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
