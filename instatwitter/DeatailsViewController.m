//
//  DeatailsViewController.m
//  instatwitter
//
//  Created by frankboamps on 7/10/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import "DeatailsViewController.h"
#import "HomeFeedViewController.h"
#import "DateTools.h"

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
    PFFileObject *userImageFile = self.post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.detailViewImage.image = [UIImage imageWithData:data];
        }
    }];
    NSLog(@"%@", self.post);
   //self.postCreatedAtLabel.text = self.post.createdAt;
    NSString *pastTime;
    NSDate *now = [NSDate date];
    NSDate *tweetDate = self.post.createdAt;
    long monthDiff = [now monthsFrom:tweetDate];
    long dayDiff = [now daysFrom:tweetDate];
    long hourDiff = [now hoursFrom:tweetDate];
    long minuteDiff = [now minutesFrom:tweetDate];
    long secondDiff = [now secondsFrom:tweetDate];
    if (monthDiff == 0){
        if (dayDiff != 0){
//            NSLog(@"%l", dayDiff);
//            if (dayDiff == (long) 1){
//                 pastTime = [[NSString stringWithFormat:@"%lu", dayDiff] stringByAppendingString:@" day ago"];
//            }
            pastTime = [[NSString stringWithFormat:@"%lu", dayDiff] stringByAppendingString:@" day ago"];
        }
        else if (hourDiff != 0){
            pastTime = [[NSString stringWithFormat:@"%lu", hourDiff] stringByAppendingString:@" hours ago"];
        }
        else if (minuteDiff != 0){
            pastTime = [[NSString stringWithFormat:@"%lu", minuteDiff] stringByAppendingString:@" minutes ago"];
        }
        else if (secondDiff != 0){
            pastTime = [[NSString stringWithFormat:@"%lu", secondDiff] stringByAppendingString:@" seconds ago"];
        }
        self.postCreatedAtLabel.text = pastTime;
    }

    self.detailViewCaptionLabel.text = self.post.caption;
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
