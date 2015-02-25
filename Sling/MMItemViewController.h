//
//  MMItemViewController.h
//  Sling
//
//  Created by Madhav Murthy on 04/10/14.
//  Copyright (c) 2014 Madhav Murthy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MMItemViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) PFObject *item;
@property (strong, nonatomic) PFObject *user;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) IBOutlet UILabel *itemPrice;
@property (strong, nonatomic) IBOutlet UILabel *itemDescription;
@property (strong, nonatomic) IBOutlet UILabel *uploader;
@property (strong, nonatomic) IBOutlet UILabel *contact;

@end
