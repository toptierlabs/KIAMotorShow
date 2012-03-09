//
//  PlansTableViewController.h
//  KIAMotorShow
//
//  Created by fernando colman on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlansTableViewController : UITableViewController{
    NSString* modelo;
    int precio;
}

@property (nonatomic,retain) NSString* modelo;

@property (nonatomic) int precio;

@end
