//
//  MMCategoryTableViewController.h
//  Sling
//
//  Created by Madhav Murthy on 02/10/14.
//  Copyright (c) 2014 Madhav Murthy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCategoryTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *categories;
- (IBAction)logout:(id)sender;

@end
