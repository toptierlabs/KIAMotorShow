//
//  ModelDetailTableViewController.m
//  KIAMotorShow
//
//  Created by fernando colman on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModelDetailTableViewController.h"
#import "PlansTableViewController.h"


@implementation ModelDetailTableViewController

@synthesize model, detailsArray,tableView,webView;

NSDictionary* modelDetail;

NSArray *sortedKeys;

NSString* fullmodel;
int precio;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


NSInteger sort(id a, id b, void* p) {
    return  [a compare:b options:NSNumericSearch];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    NSString *path = [[NSBundle mainBundle] pathForResource:@"modelsDetails" ofType:@"plist"];
	self.detailsArray = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *immutableKeys = [[detailsArray objectForKey:model] allKeys];
    
    //Make a mutable array in order to sort the keys 
    NSMutableArray *detailsTypesMutableKeys = [[NSMutableArray alloc] initWithArray:immutableKeys];
    sortedKeys = [detailsTypesMutableKeys sortedArrayUsingFunction:&sort context:nil];
        
    modelDetail = [detailsArray objectForKey:model];

    [self.navigationItem setTitle:model.uppercaseString];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [sortedKeys count];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //for hight
    if ([model isEqualToString:@"Mohave"]) {
        
        return 400;
    }else {
        return 300;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView_param cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView_param 
                             dequeueReusableCellWithIdentifier:@"ModelDetailCell"];
    

 
    NSLog(@"KEY %@",[sortedKeys objectAtIndex:indexPath.row]);
    
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
    
    
    numberFormat.usesGroupingSeparator = YES;
    
    
    numberFormat.groupingSeparator = @".";
    
    
    numberFormat.groupingSize = 3;
    
    int precioInt = [[[modelDetail objectForKey:[sortedKeys objectAtIndex:indexPath.row]] objectForKey:@"precio"] intValue];

    
    NSString *stringNumber = [numberFormat stringFromNumber:[NSNumber numberWithInt:precioInt]];

    
    UILabel* titleLabel = (UILabel *)[cell viewWithTag:101];
    titleLabel.text = [NSString stringWithFormat:@"%@",[[modelDetail objectForKey:[sortedKeys objectAtIndex:indexPath.row]] objectForKey:@"tipo"]];
    
    UILabel* precioLabel = (UILabel *)[cell viewWithTag:104];
    precioLabel.text = [NSString stringWithFormat:@"USD %@",stringNumber];

    

    [(UIImageView *)[cell viewWithTag:100] setImage:[UIImage imageNamed: [model lowercaseString]]]; 
    
    
//    UILabel* detailsLabel = (UILabel *)[cell viewWithTag:102];
//	detailsLabel.text = [[modelDetail objectForKey:[sortedKeys objectAtIndex:indexPath.row]] objectForKey:@"detalle"];
//    detailsLabel.numberOfLines = 0;
//    
//    
//    [detailsLabel sizeToFit];
    
     UIWebView* detailsWebview = (UIWebView *)[cell viewWithTag:103];
     [detailsWebview loadHTMLString:[[modelDetail objectForKey:[sortedKeys objectAtIndex:indexPath.row]] objectForKey:@"detalle"] baseURL:[NSURL URLWithString:@""]];
    
    if ([model isEqualToString:@"Mohave"]) { 
    
        CGRect tvbounds = [detailsWebview bounds];
        [detailsWebview setFrame:CGRectMake(20, 
                                    55, 
                                    tvbounds.size.width, 
                                    310)];
    }
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView_param didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([model isEqualToString: [[modelDetail objectForKey:[sortedKeys objectAtIndex:indexPath.row]] objectForKey:@"tipo"]])
        fullmodel = model;
    else
        fullmodel = [NSString stringWithFormat:@"%@ %@", model, [[modelDetail objectForKey:[sortedKeys objectAtIndex:indexPath.row]] objectForKey:@"tipo"]];
    precio = [[[modelDetail objectForKey:[sortedKeys objectAtIndex:indexPath.row]] objectForKey:@"precio"] integerValue];
    
    //Deselect the row before leaving the method
    [tableView_param deselectRowAtIndexPath:indexPath animated:NO];   
    
    [self performSegueWithIdentifier: @"PlansSegue" sender: self];
    
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    PlansTableViewController  *viewController = segue.destinationViewController;
    viewController.modelo = fullmodel;
    viewController.precio = precio;

    
}

@end
