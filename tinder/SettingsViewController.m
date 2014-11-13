//
//  SettingsViewController.m
//  tinder
//
//  Created by Chia-Chi Lin on 11/11/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "SettingsViewController.h"
#import "User.h"

#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface SettingsViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UIView *ageView;
@property (weak, nonatomic) IBOutlet UIView *budgetView;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UISlider *ageSlider;
@property (weak, nonatomic) IBOutlet UILabel *budgetLabel;
@property (weak, nonatomic) IBOutlet UISlider *budgetSlider;

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
    self.title = @"Settings";
    CGRect frame = CGRectMake(0, 0, 30, 30);
    UIImage *menuImage = [UIImage imageNamed:@"Menu"];
    UIButton *menuButton = [[UIButton alloc] initWithFrame:frame];
    [menuButton setImage:menuImage forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(onMenuButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    UIImage *chatImage = [UIImage imageNamed:@"Chat"];
    UIButton *chatButton = [[UIButton alloc] initWithFrame:frame];
    [chatButton setImage:chatImage forState:UIControlStateNormal];
    [chatButton addTarget:self action:@selector(onChatButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:chatButton];
    
    // Set up the scroll view constraints.
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeading relatedBy:0 toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:0 toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.view addConstraint:rightConstraint];
    
    // Set up keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // Set up subview borders and corners.
    [self makeRoundedCorners:self.photoView.layer];
    [self makeRoundedCorners:self.ageView.layer];
    [self makeRoundedCorners:self.budgetView.layer];
    [self makeRoundedCorners:self.descriptionView.layer];
    [self makeBorders:self.photoImageView.layer];
    [self makeRoundedCorners:self.photoImageView.layer];
    [self makeBorders:self.descriptionTextView.layer];
    [self makeRoundedCorners:self.descriptionTextView.layer];
    
    User *user = [User user];
    if (user.preferences_set) {
        self.photoImageView.image = user.image;
        [self setAge:user.age];
        [self setBudget:user.budget];
        self.descriptionTextView.text = user.desc;
    } else {
        self.photoImageView.image = [UIImage imageNamed:@"UploadPhoto"];
        [self setAge:21];
        [self setBudget:1000];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.photoImageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onViewTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)onPhotoImageViewTap:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)onAgeSliderValueChanged:(id)sender {
    self.ageLabel.text = [NSString stringWithFormat:@"%ld", [self getAge]];
}

- (IBAction)onBudgetSliderValueChanged:(id)sender {
    self.budgetLabel.text = [NSString stringWithFormat:@"$%ld", [self getBudget]];
}

- (IBAction)onMenuButtonTap:(id)sender {
    if ([self saveSettings]) {
        
    }
}

- (IBAction)onChatButtonTap:(id)sender {
    if ([self saveSettings]) {
        
    }
}

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
    PFUser *user = [PFUser currentUser];
    
    NSData *imageData = UIImagePNGRepresentation(self.photoImageView.image);
    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.png", user.objectId] data:imageData];
    [imageFile saveInBackground];
    
    [user setObject:imageFile forKey:@"image"];
    [user setObject:@([self getAge]) forKey:@"age"];
    [user setObject:@([self getBudget]) forKey:@"budget"];
    [user setObject:self.descriptionTextView.text forKey:@"desc"];
    [user setObject:@(YES) forKey:@"preferences_set"];
    
    [user saveInBackground];
    
    return YES;
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
