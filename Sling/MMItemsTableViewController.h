//
//  MMItemsTableViewController.h
//  Sling
//
//  Created by Madhav Murthy on 02/10/14.
//  Copyright (c) 2014 Madhav Murthy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMItemsTableViewController : UITableViewController

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSArray *items;
@end
