//
//  LoginViewController.m
//  tinder
//
//  Created by Gaurav Menghani on 11/10/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface LoginViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.loginScrollView.delegate = self;
    
    CGFloat width = self.loginScrollView.frame.size.width;

    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.loginScrollView.frame.size.width - 40, 40)];
    [firstLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:16]];
    firstLabel.text = @"Anonymously \"Like\" or \"Pass\" on people Roomies suggests.";
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.numberOfLines = 2;
    
    UIImageView *first = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginOne"]];
    first.frame = CGRectMake(0, 40, width, self.loginScrollView.frame.size.height - 20);

    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(width + 20, 20, self.loginScrollView.frame.size.width - 40, 40)];
    [secondLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:16]];
    secondLabel.text = @"If someone you've like happens to like you back...";
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.numberOfLines = 2;
    
    UIImageView *second = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginTwo"]];
    second.frame = CGRectMake(width, 40, width, self.loginScrollView.frame.size.height - 20);
    
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(width + width + 20, 20, self.loginScrollView.frame.size.width - 40, 40)];
    [thirdLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:16]];
    thirdLabel.text = @"Chat with your matches inside the app.";
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.numberOfLines = 2;
    
    UIImageView *third = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginThree"]];
    third.frame = CGRectMake(2 * width, 40, width, self.loginScrollView.frame.size.height - 20);

    self.loginScrollView.contentSize = CGSizeMake(width * 3, self.loginScrollView.frame.size.height);

    [self.loginScrollView addSubview:firstLabel];
    [self.loginScrollView addSubview:first];

    [self.loginScrollView addSubview:secondLabel];
    [self.loginScrollView addSubview:second];

    [self.loginScrollView addSubview:thirdLabel];
    [self.loginScrollView addSubview:third];
}

- (IBAction)changePage:(id)sender {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.loginScrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.loginScrollView.frame.size;
    [self.loginScrollView scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat width = self.loginScrollView.frame.size.width;
    int page = floor((self.loginScrollView.contentOffset.x - width / 2) / width) + 1;
    self.pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_presentUserDetailsViewControllerAnimated:(BOOL)animated {
    MainViewController *mvc = [[MainViewController alloc] init];
    [self presentViewController:mvc animated:YES completion:nil];
    // [self.navigationController pushViewController:mvc animated:animated];
}

- (IBAction)onLogin:(id)sender {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"user_hometown"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        // [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
            } else {
                NSLog(@"User with facebook logged in!");
            }
            [self _presentUserDetailsViewControllerAnimated:YES];
        }
    }];
    
    // [_activityIndicator startAnimating]; // Show loading indicator until login is finished
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
