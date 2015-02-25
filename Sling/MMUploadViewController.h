//
//  MMUploadViewController.h
//  Sling
//
//  Created by Madhav Murthy on 03/10/14.
//  Copyright (c) 2014 Madhav Murthy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMCategoryPickerController.h"

@interface MMUploadViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MMCategoryPickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *itemTitle;
@property (strong, nonatomic) IBOutlet UITextField *itemPrice;
@property (strong, nonatomic) IBOutlet UITextField *itemDescription;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *videoFilePath;
@property (nonatomic, strong) NSString *category;

- (IBAction)upload:(id)sender;
- (IBAction)cancel:(id)sender;

@end
