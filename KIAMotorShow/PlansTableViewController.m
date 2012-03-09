//
//  PlansTableViewController.m
//  KIAMotorShow
//
//  Created by fernando colman on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlansTableViewController.h"
#import "PlanTipo1ViewController.h"
#import "PlanTipo2ViewController.h"


@implementation PlansTableViewController

@synthesize modelo,precio;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([[segue identifier] isEqualToString:@"PrimerCuota3Meses"]){
        
		PlanTipo1ViewController  *viewController = segue.destinationViewController;
        viewController.modelo = modelo;
        viewController.tipoPlan = @"PrimerCuota3Meses";
        viewController.precio = precio;
    }
    else if([[segue identifier] isEqualToString:@"TasaLoca"]){
        
        PlanTipo1ViewController  *viewController = segue.destinationViewController;
        viewController.modelo = modelo;
        viewController.tipoPlan = @"TasaLoca";
        viewController.precio = precio;
    }
    else if([[segue identifier] isEqualToString:@"Ganate1Año"]){
        
        PlanTipo2ViewController  *viewController = segue.destinationViewController;
        viewController.modelo = modelo;
        viewController.tipoPlan = @"Ganate1Año";
        viewController.precio = precio;
    }
    else if([[segue identifier] isEqualToString:@"50-50"]){
        
        PlanTipo1ViewController  *viewController = segue.destinationViewController;
        viewController.modelo = modelo;
        viewController.tipoPlan = @"50-50";
        viewController.precio = precio;
    }
    
}

@end
