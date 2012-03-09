//
//  ModelTableViewController.m
//  KIAMotorShow
//
//  Created by fernando colman on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModelTableViewController.h"
#import "ModelDetailTableViewController.h"


@implementation ModelTableViewController

@synthesize models,carImage,tableView;

  NSString* model;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    models = [[NSArray alloc] initWithObjects:@"Picanto", @"Cerato",@"Soul", @"Cerato Koup", @"Sportage", @"Sorento", @"Mohave",nil];

}

- (void)viewDidUnload
{
    [super viewDidUnload];

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



#pragma mark - Table view delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [models count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:@"ModelCell"];
    
    
    model = [models objectAtIndex:indexPath.row];
    
    NSString* logo = [NSString stringWithFormat:@"%@%@", [model lowercaseString], @"Logo"];
    
    [(UIImageView *)[cell viewWithTag:100] setImage:[UIImage imageNamed: [model lowercaseString]]]; 
    [(UIImageView *)[cell viewWithTag:101] setImage:[UIImage imageNamed: logo]]; 
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    model = [models objectAtIndex:indexPath.row];
    
    //Deselect the row before leaving the method
    [tableView deselectRowAtIndexPath:indexPath animated:NO];   
    
    
    //Go to the next view
    [self performSegueWithIdentifier: @"modelDetailSegue" sender: self];
    
    

    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([[segue identifier] isEqualToString:@"modelDetailSegue"]){
        
        
        //Set de model to the next view
		ModelDetailTableViewController  *viewController = segue.destinationViewController;
        viewController.model = model;
    }

  }

@end
