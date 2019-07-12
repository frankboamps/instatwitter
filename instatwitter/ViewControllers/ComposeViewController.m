//
//  ComposeViewController.m
//  instatwitter
//
//  Created by frankboamps on 7/8/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import "ComposeViewController.h"
#import "Post.h"
#import "HomeFeedViewController.h"
#import "JGProgressHUD.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *composeImage;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIImage *editedImage;

@end

@implementation ComposeViewController

#pragma mark - View contoller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.postTextField.delegate = self;
}

#pragma mark - Setting tapped photo

- (IBAction)whenPhotoIsTapped:(id)sender
{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    // imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}

#pragma mark - Setting image picker controller

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.originalImage = info[UIImagePickerControllerOriginalImage];
    self.editedImage = [self resizeImage:self.originalImage withSize:CGSizeMake(400, 400)];
    [self.postImage setImage:self.editedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Resizing image

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size
{
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Setting up Tap Buttons

- (IBAction)shareButtonTapped:(id)sender
{
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    [HUD showInView:self.view];
    [Post postUserImage:self.editedImage withCaption:self.postTextField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            [HUD dismissAnimated:YES];
            [self dismissViewControllerAnimated:true completion:^{
                [self.delegate didPost];
            }];
        }
        else{
            [HUD dismissAnimated:YES];
        }
    }];
}

- (IBAction)cancelButtonTapped:(id)sender
{
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
