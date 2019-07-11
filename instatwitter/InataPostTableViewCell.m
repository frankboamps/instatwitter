//
//  InataPostTableViewCell.m
//  instatwitter
//
//  Created by frankboamps on 7/9/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import "InataPostTableViewCell.h"

@implementation InataPostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapFavoriteButton:(id)sender {
//    if (self.tweet.retweeted) {
//        self.tweetRetweet.selected = NO;
//        self.tweet.retweeted = NO;
//        self.tweet.retweetCount -= 1;
//    }
//    else{
//        self.tweetRetweet.selected = YES;
//        self.tweet.retweeted = YES;
//        self.tweet.retweetCount += 1;
//        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
//            if(error){
//                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
//            }
//            else{
//                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
//            }
//        }];
//    }
}

@end
