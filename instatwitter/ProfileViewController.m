//
//  ProfileViewController.m
//  instatwitter
//
//  Created by frankboamps on 7/10/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "HomeFeedViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "Post.h"
#import "InstaCollectionCell.h"
#import "InataPostTableViewCell.h"
#import "DeatailsViewController.h"
#import <UIKit/UIKit.h>

@interface ProfileViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *userPostArray;
@property (weak, nonatomic) IBOutlet UILabel *userProfileName;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIImage *editedImage;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *userName = PFUser.currentUser.username;
    self.userProfileName.text = userName;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing *(postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.profileImageView.layer.cornerRadius = 25;
    self.profileImageView.clipsToBounds = YES;
    PFFileObject *PFObjectProfileImage = [PFUser currentUser][@"profileImage"];
    NSURL *profileImageURL = [NSURL URLWithString:PFObjectProfileImage.url];
    self.profileImageView.image = nil;
    [self.profileImageView setImageWithURL:profileImageURL];
    [self refreshData];
}


- (IBAction)didTapNoProfile:(id)sender
{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}


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


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.originalImage = info[UIImagePickerControllerOriginalImage];
    self.editedImage = [self resizeImage:self.originalImage withSize:CGSizeMake(400, 400)];
    [self.profileImageView setImage:self.editedImage];
    [PFUser currentUser][@"profileImage"] = [Post getPFFileFromImage:self.editedImage];
    [[PFUser currentUser] saveInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)refreshData
{
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable posts, NSError *_Nullable error) {
        if (posts) {
            self.userPostArray = posts;
            [self.collectionView reloadData];
            self.profileImageView.layer.cornerRadius = 30;
            self.profileImageView.clipsToBounds = YES;
        }
        else {
            
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    InstaCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"instaCollectionCell" forIndexPath:indexPath];
    
    Post *post = self.userPostArray[indexPath.row];
    cell.post = post;
    NSString *post_image_address = post.image.url;
    NSURL *postImageURL = [NSURL URLWithString:post_image_address];
    cell.postedImage.image = nil;
    [cell.postedImage setImageWithURL:postImageURL];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.userPostArray.count;
}

- (IBAction)didTapEditProfileButton:(id)sender
{
    PFFileObject *PFObjectProfileImage = [PFUser currentUser][@"profileImage"];
    NSURL *profileImageURL = [NSURL URLWithString:PFObjectProfileImage.url];
    self.profileImageView.image = nil;
    [self.profileImageView setImageWithURL:profileImageURL];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"postDetailSegue"]){
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Post *post = self.userPostArray[indexPath.row];
        DeatailsViewController *postDetailsViewController = [segue destinationViewController];
        postDetailsViewController.post = post;
    }
}


@end
