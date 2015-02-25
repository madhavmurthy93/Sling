//
//  MMCategoryPickerController.h
//  Sling
//
//  Created by Madhav Murthy on 04/10/14.
//  Copyright (c) 2014 Madhav Murthy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMCategoryPickerController;
@protocol MMCategoryPickerControllerDelegate <NSObject>
- (void)markSelectedViewController:(MMCategoryPickerController *)controller didFinishChoosingCategory:(NSString *)item;
@end

@interface MMCategoryPickerController : UITableViewController

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSString *categorySelected;
@property (nonatomic, assign) NSIndexPath *lastSelected;

@property (nonatomic, weak) id <MMCategoryPickerControllerDelegate> delegate;

@end
