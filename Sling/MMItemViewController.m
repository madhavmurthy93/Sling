//
//  MMItemViewController.m
//  Sling
//
//  Created by Madhav Murthy on 04/10/14.
//  Copyright (c) 2014 Madhav Murthy. All rights reserved.
//

#import "MMItemViewController.h"

@interface MMItemViewController ()

@end

@implementation MMItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = [self.item objectForKey:@"itemTitle"];
    self.navigationItem.title = title;
    NSString *price = [self.item objectForKey:@"itemPrice"];
    NSString *info = [self.item objectForKey:@"itemDescription"];
    self.itemPrice.text = [NSString stringWithFormat:@"Price: %@", price];
    self.itemDescription.text = [NSString stringWithFormat:@"Description: %@", info];
    NSString *uploaderId = [self.item objectForKey:@"uploaderId"];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:uploaderId block:^(PFObject *object, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } else {
            self.user = object;
            NSString *fname = [self.user objectForKey:@"fname"];
            NSString *lname = [self.user objectForKey:@"lname"];
            NSString *phone = [self.user objectForKey:@"phone"];
            self.uploader.text = [NSString stringWithFormat:@"Name: %@ %@", fname, lname];
            self.contact.text = [NSString stringWithFormat:@"Contact: %@", phone];
        }
    }];
    NSString *fileType = [self.item objectForKey:@"fileType"];
    if([fileType isEqualToString:@"image"]) {
        PFFile *imageFile = [self.item objectForKey:@"file"];
        NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
        NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
        self.imageView.image = [UIImage imageWithData:imageData];
    } else {
        self.moviePlayer = [[MPMoviePlayerController alloc] init];
        PFFile *videoFile = [self.item objectForKey:@"file"];
        NSURL *fileUrl = [NSURL URLWithString:videoFile.url];
        self.moviePlayer.contentURL = fileUrl;
        self.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
        [self.moviePlayer prepareToPlay];
        [self.moviePlayer.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        [self.moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        [self.view addSubview:self.moviePlayer.view];
    }
    
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
