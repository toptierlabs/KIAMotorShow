//
//  ModelTableViewController.h
//  KIAMotorShow
//
//  Created by fernando colman on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    NSArray* models;
    
    IBOutlet UIImageView * carImage;
    IBOutlet UITableView *tableView;
}

@property (nonatomic,retain) NSArray* models;
@property (nonatomic,retain) UIImageView* carImage;
@property (nonatomic, retain) UITableView *tableView;

@end
