//
//  SettingsViewController.m
//  tinder
//
//  Created by Chia-Chi Lin on 11/11/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "ProfileViewController.h"
#import "SettingsViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "LoginViewController.h"

#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import <UIImageView+AFNetworking.h>

//@interface SettingsViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@interface SettingsViewController () <UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
@property (strong, nonatomic) IBOutlet UIButton *onLogout;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

//@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UIView *ageView;
@property (weak, nonatomic) IBOutlet UIView *budgetView;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
//@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UISlider *ageSlider;
@property (weak, nonatomic) IBOutlet UILabel *budgetLabel;
@property (weak, nonatomic) IBOutlet UISlider *budgetSlider;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileBackgroundImageView;

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *contentViewPanGestureRecognizer;
@property (strong, nonatomic) ProfileViewController *profileVC;
@property (strong, nonatomic) UIImageView *movingProfileImageView;
@property (strong, nonatomic) UIImageView *movingProfileBackgroundImageView;
- (IBAction)onLogoutButtonPress:(id)sender;

//@property (nonatomic) BOOL isPhotoUpdated;

@end

const NSInteger kAgeMin = 0;
const NSInteger kAgeMax = 120;
const NSInteger kBudgetMin = 0;
const NSInteger kBudgetMax = 5000;

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set up the navigation bar.
//    self.title = @"Settings";
//    CGRect frame = CGRectMake(0, 0, 30, 30);
//    UIImage *menuImage = [UIImage imageNamed:@"Menu"];
//    UIButton *menuButton = [[UIButton alloc] initWithFrame:frame];
//    [menuButton setImage:menuImage forState:UIControlStateNormal];
//    [menuButton addTarget:self action:@selector(onMenuButtonTap:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
//    UIImage *chatImage = [UIImage imageNamed:@"Chat"];
//    UIButton *chatButton = [[UIButton alloc] initWithFrame:frame];
//    [chatButton setImage:chatImage forState:UIControlStateNormal];
//    [chatButton addTarget:self action:@selector(onChatButtonTap:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:chatButton];
    
    // Set up the scroll view constraints.
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeading relatedBy:0 toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:0 toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.view addConstraint:rightConstraint];
    
    // Set up the content view pan gesture recognizer delegate.
    self.contentViewPanGestureRecognizer.delegate = self;
    
    // Set up keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // Set up profile images
    User *user = [User user];
    [self.profileImageView setImageWithURL:user.profileImageURL];
    [self.profileImageView.layer setCornerRadius:self.profileImageView.frame.size.height / 2];
    [self.profileImageView.layer setBorderWidth:1];
    [self.profileImageView.layer setMasksToBounds:YES];
    [self.profileBackgroundImageView setImageWithURL:user.profileImageURL];
    self.profileBackgroundImageView.alpha = 0.2;
    
    // Set up subview borders and corners.
//    [self makeRoundedCorners:self.photoView.layer];
//    [self makeRoundedCorners:self.ageView.layer];
//    [self makeRoundedCorners:self.budgetView.layer];
//    [self makeRoundedCorners:self.descriptionView.layer];
//    [self makeBorders:self.photoImageView.layer];
//    [self makeRoundedCorners:self.photoImageView.layer];
    [self makeBorders:self.descriptionTextView.layer];
    [self makeRoundedCorners:self.descriptionTextView.layer];
    
    if (user.preferences_set) {
//        [self.photoImageView setImageWithURL:user.profileImageURL];
        [self setAge:user.age];
        [self setBudget:user.budget];
        self.descriptionTextView.text = user.desc;
        
//        self.isPhotoUpdated = YES;
    } else {
//        self.photoImageView.image = [UIImage imageNamed:@"UploadPhoto"];
        [self setAge:21];
        [self setBudget:1000];
        
//        self.isPhotoUpdated = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([self saveSettings]) {
        
    } else {
//        if (!self.isPhotoUpdated) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Settings" message:@"Please select a photo." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        }
        
//        if ([self.descriptionTextView.text isEqualToString:@""]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Settings" message:@"Please write a description about yourself." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardDidShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.descriptionView.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.descriptionView.frame animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.contentViewPanGestureRecognizer) {
        return YES;
    }
    
    return NO;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 2;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [containerView addSubview:toViewController.view];
    toViewController.view.backgroundColor = [UIColor clearColor];
    self.profileVC.scrollView.transform = CGAffineTransformMakeTranslation(0.0, self.profileVC.scrollView.frame.size.height);
    
    self.profileVC.view.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:2 animations:^{
        self.profileVC.scrollView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
        
        self.profileVC.view.backgroundColor = [UIColor whiteColor];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        [self.movingProfileImageView removeFromSuperview];
        [self.movingProfileBackgroundImageView removeFromSuperview];
        self.profileImageView.hidden = NO;
        self.profileBackgroundImageView.hidden = NO;
        self.contentView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
    }];
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
//    self.photoImageView.image = chosenImage;
//    self.isPhotoUpdated = YES;
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}

//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}

- (IBAction)onViewTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

//- (IBAction)onPhotoImageViewTap:(id)sender {
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    [self presentViewController:picker animated:YES completion:nil];
//}

- (IBAction)onContentViewPan:(UIPanGestureRecognizer *)sender {
    static BOOL transitionInitiated;
    static CGFloat originY;
    
    CGPoint location = [sender locationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (self.scrollView.contentOffset.y > 0.0 || velocity.y <= 0.0) {
            transitionInitiated = NO;
            return;
        }
        
        transitionInitiated = YES;
        originY = location.y;
        
        CGRect frame;
        frame = self.profileImageView.frame;
        frame.origin.y += 80;
        self.movingProfileImageView = [[UIImageView alloc] initWithFrame:frame];
        self.movingProfileImageView.image = self.profileImageView.image;
        self.movingProfileImageView.contentMode = self.profileImageView.contentMode;
        self.movingProfileImageView.clipsToBounds = self.profileImageView.clipsToBounds;
        [self.movingProfileImageView.layer setCornerRadius:self.movingProfileImageView.frame.size.height / 2];
        [self.movingProfileImageView.layer setBorderWidth:1];
        [self.movingProfileImageView.layer setMasksToBounds:YES];
        
        frame = self.profileBackgroundImageView.frame;
        frame.origin.y += 80;
        self.movingProfileBackgroundImageView = [[UIImageView alloc] initWithFrame:frame];
        self.movingProfileBackgroundImageView.image = self.profileBackgroundImageView.image;
        self.movingProfileBackgroundImageView.contentMode = self.profileBackgroundImageView.contentMode;
        self.movingProfileBackgroundImageView.clipsToBounds = self.profileBackgroundImageView.clipsToBounds;
        self.movingProfileBackgroundImageView.alpha = 0.2;
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self.movingProfileBackgroundImageView];
        [window addSubview:self.movingProfileImageView];
        
        self.profileImageView.hidden = YES;
        self.profileBackgroundImageView.hidden = YES;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if (transitionInitiated) {
            CGFloat offset = location.y - originY;
            CGFloat percent;
            if (offset < 0.0) {
                percent = 0.0;
            } else if (offset > 100.0) {
                percent = 1.0;
            } else {
                percent = offset / 100.0;
            }
        
            self.movingProfileImageView.transform = CGAffineTransformMakeTranslation(0.0, 50.0 * percent);
            self.movingProfileImageView.alpha = 0.8 * (1.0 - percent);
            CGRect frame = self.movingProfileBackgroundImageView.frame;
            frame.size.height = 150.0 + 100.0 * percent;
            self.movingProfileBackgroundImageView.frame = frame;
            self.movingProfileBackgroundImageView.alpha = 0.2 + 0.8 * percent;
            self.contentView.transform = CGAffineTransformMakeTranslation(0.0, 100.0 * percent);
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (transitionInitiated) {
            CGFloat offset = location.y - originY;
            CGFloat percent;
            if (offset < 0.0) {
                percent = 0.0;
            } else if (offset > 100.0) {
                percent = 1.0;
            } else {
                percent = offset / 100.0;
            }
        
            if (percent >= 1.0) {
                self.profileVC = [[ProfileViewController alloc] init];
                UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:self.profileVC];
                nvc.modalPresentationStyle = UIModalPresentationCustom;
                nvc.transitioningDelegate = self;
                [self presentViewController:nvc animated:YES completion:nil];
            } else {
                [self.movingProfileImageView removeFromSuperview];
                [self.movingProfileBackgroundImageView removeFromSuperview];
                self.profileImageView.hidden = NO;
                self.profileBackgroundImageView.hidden = NO;
                self.contentView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
            }
        }
    }
}

- (IBAction)onAgeSliderValueChanged:(id)sender {
    self.ageLabel.text = [NSString stringWithFormat:@"%ld", [self getAge]];
}

- (IBAction)onBudgetSliderValueChanged:(id)sender {
    self.budgetLabel.text = [NSString stringWithFormat:@"$%ld", [self getBudget]];
}

//- (IBAction)onMenuButtonTap:(id)sender {
//    if ([self saveSettings]) {
//        
//    } else {
//        
//    }
//}
//
//- (IBAction)onChatButtonTap:(id)sender {
//    if ([self saveSettings]) {
//        
//    } else {
//        
//    }
//}

- (void)makeBorders:(CALayer *)layer {
    layer.borderColor = [[UIColor lightGrayColor] CGColor];
    layer.borderWidth = 1.0;
}

- (void)makeRoundedCorners:(CALayer *)layer {
    layer.cornerRadius = 5;
    layer.masksToBounds = YES;
}

- (NSUInteger)getAge {
    return kAgeMin + (int)roundf((kAgeMax - kAgeMin) * self.ageSlider.value);
}

- (void)setAge:(NSInteger)age {
    self.ageLabel.text = [NSString stringWithFormat:@"%ld", age];
    self.ageSlider.value = (float)(age - kAgeMin) / (kAgeMax - kAgeMin);
}

- (NSUInteger)getBudget {
    return kBudgetMin + (int)roundf((kBudgetMax - kBudgetMin) * self.budgetSlider.value);
}

- (void)setBudget:(NSInteger)budget {
    self.budgetLabel.text = [NSString stringWithFormat:@"$%ld", budget];
    self.budgetSlider.value = (float)(budget - kBudgetMin) / (kBudgetMax - kBudgetMin);
}

- (BOOL)saveSettings {
    User *currentUser = [User user];
//    if (self.isPhotoUpdated) {
//        currentUser.image = self.photoImageView.image;
//    }
    currentUser.age = [self getAge];
    currentUser.budget = [self getBudget];
    currentUser.desc = self.descriptionTextView.text;
    currentUser.preferences_set = YES;
    
    PFUser *pfUser = [PFUser currentUser];
//    if (self.isPhotoUpdated) {
//        NSData *imageData = UIImagePNGRepresentation(self.photoImageView.image);
//        PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.png", pfUser.objectId] data:imageData];
//        [imageFile saveInBackground];
//
//        [pfUser setObject:imageFile forKey:@"image"];
//    }
    [pfUser setObject:@([self getAge]) forKey:@"age"];
    [pfUser setObject:@([self getBudget]) forKey:@"budget"];
    [pfUser setObject:self.descriptionTextView.text forKey:@"desc"];

//    if (self.isPhotoUpdated && ![self.descriptionTextView.text isEqualToString:@""]) {
    if (![self.descriptionTextView.text isEqualToString:@""]) {
        [pfUser setObject:@(YES) forKey:@"preferences_set"];
    }
    
    [pfUser saveInBackground];
    
//    if (self.isPhotoUpdated && ![self.descriptionTextView.text isEqualToString:@""]) {
    if (![self.descriptionTextView.text isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

- (ViewType)viewType {
    return SettingsView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onLogoutButtonPress:(id)sender {
    [User logout];
    LoginViewController* lvc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:lvc animated:YES];
}
@end
