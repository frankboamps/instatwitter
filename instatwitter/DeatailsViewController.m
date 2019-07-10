//
//  DeatailsViewController.m
//  instatwitter
//
//  Created by frankboamps on 7/10/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import "DeatailsViewController.h"
#import "HomeFeedViewController.h"

@interface DeatailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *detailViewImage;
@property (weak, nonatomic) IBOutlet UILabel *detailViewCaptionLabel;

@end

@implementation DeatailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.detailViewImage.image = self.post[@"image"];
    self.detailViewCaptionLabel.text = self.post.caption;
}

- (IBAction)didTapBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES  completion:nil];
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
