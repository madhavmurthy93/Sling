//
//  MMUploadViewController.m
//  Sling
//
//  Created by Madhav Murthy on 03/10/14.
//  Copyright (c) 2014 Madhav Murthy. All rights reserved.
//

#import "MMUploadViewController.h"
#import "MMCategoryPickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>

@interface MMUploadViewController ()

@end

@implementation MMUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
}

- (void)viewWillAppear:(BOOL)animated {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.videoMaximumDuration = 10;
    
    if (self.image == nil && [self.videoFilePath length] == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
}

- (void)markSelectedViewController:(MMCategoryPickerController *)controller didFinishChoosingCategory:(NSString *)item {
    self.category = item;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MMCategoryPickerController *controller = (MMCategoryPickerController *)[segue destinationViewController];
    controller.delegate = self;
}

#pragma mark - Image Picker Controller delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *) kUTTypeImage]) {
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    } else {
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        self.videoFilePath = [videoURL path];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions

- (IBAction)upload:(id)sender {
    NSString *title = [self.itemTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *price = [self.itemPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *description = [self.itemDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.image == nil && [self.videoFilePath length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Try again!"
                                                            message:@"Please capture or select a photo or video to share!"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    } else if ([title length] == 0 || [price length] == 0 || [description length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter information in all fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        [self uploadItem];
        [self.tabBarController setSelectedIndex:0];
    }
}

- (void)uploadItem {
    NSString *title = self.itemTitle.text;
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *price = [f numberFromString:self.itemPrice.text];
    NSString *description = self.itemDescription.text;
    NSString *category = self.category;
    NSData *data;
    NSString *name;
    NSString *type;
    
    if (self.image != nil) {
        UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
        data = UIImagePNGRepresentation(newImage);
        name = @"image.png";
        type = @"image";
    } else {
        data = [NSData dataWithContentsOfFile:self.videoFilePath];
        name = @"video.mov";
        type = @"video";
    }
    
    PFFile *file = [PFFile fileWithName:name data:data];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                message:@"Please try sending your message again."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else {
            PFObject *item = [PFObject objectWithClassName:@"Items"];
            [item setObject:file forKey:@"file"];
            [item setObject:type forKey:@"fileType"];
            [item setObject:title forKey:@"itemTitle"];
            [item setObject:price forKey:@"itemPrice"];
            [item setObject:description forKey:@"itemDescription"];
            [item setObject:category forKey:@"itemCategory"];
            [item setObject:[[PFUser currentUser] objectId] forKey:@"uploaderId"];
            [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                        message:@"Please try sending your message again."
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                } else {
                    // Success.
                    self.image = nil;
                    self.videoFilePath = nil;
                    PFQuery *query = [PFQuery queryWithClassName:@"Categories"];
                    [query whereKey:@"category" equalTo:category];
                    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        if (error) {
                            NSLog(@"Error: %@ %@", error, [error userInfo]);
                        } else {
                            NSNumber *items = [object objectForKey:@"items"];
                            items = [NSNumber numberWithInt:([items intValue] + 1)];
                            [object setObject:items forKey:@"items"];
                            [object saveInBackground];
                        }
                    }];
                }
            }];
        }
    }];
}

- (IBAction)cancel:(id)sender {
    self.image = nil;
    self.videoFilePath = nil;
    [self.tabBarController setSelectedIndex:0];
}

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height {
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

@end
