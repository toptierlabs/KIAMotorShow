//
//  ModelDetailTableViewController.h
//  KIAMotorShow
//
//  Created by fernando colman on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelDetailTableViewController : UITableViewController{
    NSString* model;
    NSMutableDictionary* detailsArray;
    
    IBOutlet UITableView *tableView;
    IBOutlet UIWebView *webView;
}

@property (nonatomic,retain) NSString* model;
@property (nonatomic,retain) NSMutableDictionary* detailsArray;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIWebView* webView;

@end
