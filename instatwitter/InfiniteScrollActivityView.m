//
//  InfiniteScrollActivityView.m
//  instatwitter
//
//  Created by frankboamps on 7/10/19.
//  Copyright © 2019 frankboamps. All rights reserved.
//

#import "InfiniteScrollActivityView.h"

@implementation InfiniteScrollActivityView

UIActivityIndicatorView* activityIndicatorView;
static CGFloat _defaultHeight = 60.0;

+ (CGFloat)defaultHeight
{
    return _defaultHeight;
}

#pragma mark - Initiating scroll view and its frame

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setupActivityIndicator];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupActivityIndicator];
    }
    return self;
}

#pragma mark - Set view layoutsubview

- (void)layoutSubviews
{
    [super layoutSubviews];
    activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

#pragma mark - setting up activity indicator

- (void)setupActivityIndicator
{
    activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicatorView.hidesWhenStopped = true;
    [self addSubview:activityIndicatorView];
}

#pragma mark - Setting animations

-(void)stopAnimating
{
    [activityIndicatorView stopAnimating];
    self.hidden = true;
}

-(void)startAnimating
{
    self.hidden = false;
    [activityIndicatorView startAnimating];
}

@end
