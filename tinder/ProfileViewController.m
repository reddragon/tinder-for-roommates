//
//  ProfileViewController.m
//  tinder
//
//  Created by Chia-Chi Lin on 11/17/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "ProfileViewController.h"

#import <UIImageView+AFNetworking.h>

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) User *user;

@end

@implementation ProfileViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.user = [User user];
    }
    return self;
}

- (instancetype)initWithUser:(User *)user {
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set up the scroll view constraints.
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeading relatedBy:0 toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:0 toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.view addConstraint:rightConstraint];
    
    // Set up the Done button.
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onDone:)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = doneButton;
    
    // Set up the profile image.
    CGRect profileImageViewFrame = self.profileImageView.frame;
    profileImageViewFrame.origin.y += self.navigationController.navigationBar.frame.size.height;
    self.profileImageView.frame = profileImageViewFrame;
    [self.profileImageView setImageWithURL:self.user.profileImageURL];
    
    // Set up the labels.
    self.nameAgeLabel.text = [NSString stringWithFormat:@"%@, %ld", self.user.name, self.user.age];
    self.aboutLabel.text = [NSString stringWithFormat:@"About %@", self.user.name];
    self.descriptionLabel.text = self.user.desc;
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"bar height: %f", self.navigationController.navigationBar.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
