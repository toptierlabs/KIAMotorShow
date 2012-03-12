//
//  PlanTipo2ViewController.m
//  KIAMotorShow
//
//  Created by fernando colman on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlanTipo2ViewController.h"

@implementation PlanTipo2ViewController

@synthesize modeloLabel,precioLabel,entregaLabel,tasaLabel,plazo,porcFinanciarLabel,montoFinanciarLabel,plazoRefi,comiRefiLabel;
@synthesize porcBancoLabel,cuotaMensLabel,cuotaAnualLabel,tipoPlan,modelo,precio,email;

NSString* subject;
NSArray* plazos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

-(IBAction)hideTheKeyboard:(id)sender
{
    
    
    [self.view endEditing:TRUE];
}

-(IBAction)calcular:(id)sender{
    int cantCuotas;
    double tmu,tmi;
    
    if ([plazoRefi.text isEqualToString:@"12 meses"]) {
        cantCuotas = 12;
    } else if ([plazoRefi.text isEqualToString:@"18 meses"]) {
        cantCuotas = 18;       
    }
    else{
        cantCuotas = 24;
    }
    
    
    tmu = 0.00472276658416138;
        
    tmi = 0.00576177523267688;

    
    int porcFinanciar = 50;
    [porcFinanciarLabel setText:[NSString stringWithFormat:@"%d%%", porcFinanciar]];
    
    double porc = 0.5;    
    
    double montoAdelanto = precio * porc;
    
    int montoFinanciar = round(precio - montoAdelanto);
    
    [montoFinanciarLabel setText:[NSString stringWithFormat:@"%d", montoFinanciar]];

    double capital = [montoFinanciarLabel.text doubleValue];
    double ints = capital * tmu;
    double ivaints = ints * 0.22;
    double cuota = capital / ((1 - pow((1 / (1 + tmi)), cantCuotas)) / tmi);
    double amortCap = cuota - ints - ivaints;
    double sv = capital * 0.00060;
    double tcps = (capital + ints) * 0.000332;
    int cuotaTotal = round(cuota + tcps + sv);
    
    [cuotaAnualLabel setText:[NSString stringWithFormat:@"%d", montoFinanciar]];
    [cuotaMensLabel  setText:[NSString stringWithFormat:@"%d", cuotaTotal]];
    
    
}

-(IBAction)enviarEmail:(id)sender{
    
    [self.view endEditing:TRUE];
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
    
    
}

#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:subject];
    
    NSString *mailTo = email.text; 
    
    NSString *pathURLs = [[NSBundle mainBundle] pathForResource:@"mails" ofType:@"plist"];
    NSDictionary* dicTexts = [[NSDictionary alloc] initWithContentsOfFile:pathURLs];
    
    NSString *mailBcc = [dicTexts objectForKey:@"mailBcc"]; 
    
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:mailTo]; 
    
    [picker setToRecipients:toRecipients];
    [picker setBccRecipients:[NSArray arrayWithObject:mailBcc]];
    
    // Fill out the email body text
    NSString *body = @"";
    
    body = [NSString stringWithFormat:@"%@\n- Producto    %@", body, modelo];
    body = [NSString stringWithFormat:@"%@\n- PVP(Precio de venta al público)    U$S%d", body, precio];
    body = [NSString stringWithFormat:@"%@\n- Entrega    50%",body];
    body = [NSString stringWithFormat:@"%@\n- Plazo    %@", body, plazo.text];
    body = [NSString stringWithFormat:@"%@\n- A Financiar(porcentaje a financiar y monto a financiar)    %@", body,  [NSString stringWithFormat:@"%@-U$S%@", porcFinanciarLabel.text, montoFinanciarLabel.text]];
    body = [NSString stringWithFormat:@"%@\n-  Valor de primera cuota    U$S%@", body, cuotaMensLabel.text];
    
    
    body = [NSString stringWithFormat:@"%@\n\n\n  *Se incluyen gastos de seguro de vida para personas físicas", body];
  
    

    
    [picker setMessageBody:body isHTML:NO];
    
    [self presentModalViewController:picker animated:YES];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{  
    NSString* message;
    
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            message = @"Canceled";
            break;
        case MFMailComposeResultSaved:
            message = @"Saved";
            break;
        case MFMailComposeResultSent:
            message = @"Sent";
            break;
        case MFMailComposeResultFailed:
            message = @"Failed";
            break;
        default:
            message = @"Not sent";
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [self dismissModalViewControllerAnimated:YES];
}

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
    NSString *mailTo = email.text; 
    NSString *subject = subject; 
    
    NSString *recipients = [NSString stringWithFormat: @"mailto:%@&subject=%@", mailTo, subject];
    
    
    NSString *body = @"&body=";
    
    body = [NSString stringWithFormat:@"%@\n- Producto    %@", body, modelo];
    body = [NSString stringWithFormat:@"%@\n- PVP(Precio de venta al público)    U$S%d", body, precio];
    body = [NSString stringWithFormat:@"%@\n- Entrega    50%",body];
    body = [NSString stringWithFormat:@"%@\n- Plazo    %@", body, plazo.text];
    body = [NSString stringWithFormat:@"%@\n- A Financiar(porcentaje a financiar y monto a financiar)    %@", body,  [NSString stringWithFormat:@"%@-U$S%@", porcFinanciarLabel.text, montoFinanciarLabel.text]];
    body = [NSString stringWithFormat:@"%@\n-  Valor de primera cuota    U$S%@", body, cuotaMensLabel.text];
    
    if ([tipoPlan isEqualToString:@"PrimerCuota3Meses"] || [tipoPlan isEqualToString:@"TasaLoca"]) {
        body = [NSString stringWithFormat:@"%@\n\n\n  *Se incluyen gastos de seguro de vida para personas físicas", body];
    }

    
    
    NSString *email = [[NSString alloc] initWithFormat:@"%@%@", recipients, body];
    NSString *encodedEmail = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodedEmail]];
    
}


#pragma mark - View lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    plazos = [[NSArray alloc] initWithObjects:@"12 meses", @"18 meses",@"24 meses",nil];
    
    plazoRefi.text = @"12 meses";
    
    [modeloLabel setText:modelo];
    [precioLabel setText:[NSString stringWithFormat:@"%d", precio]];

    
    [tasaLabel setText:@"0.0%"];
    [plazo setText:@"12 meses"];
    [self.navigationItem setTitle:@"GANATE 1 AÑO"];
    subject = @"GANATE 1 AÑO – Flexiplan BBVA";
    
    // Create Picker view Toolbar. It contains a done button
    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar sizeToFit];
    
    //to make the done button aligned to the right
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    //Create pickerview objects and set delegate
    UIPickerView * pickerViewFrom= [[UIPickerView alloc] init];
    pickerViewFrom.showsSelectionIndicator = YES;
    pickerViewFrom.dataSource = self;
    pickerViewFrom.delegate = self;
    pickerViewFrom.tag = 100;
    
    plazoRefi.inputView = pickerViewFrom;
    plazoRefi.inputAccessoryView = toolbar;
}


- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Picker view events

//PickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;

}

// Executed when a new element is selected in the picker view
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
        plazoRefi.text =  [plazos objectAtIndex:row];
            
 }

// Get the number of elements in the picker view
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [plazos count];

}

// Get the text to be shown for an element in the picker view.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    
    return [plazos objectAtIndex:row];
          
}

// Done button clicked in the toolbar. Hides the picker view.
-(void)doneClicked:(id) sender
{
    // Hide responders
    [plazoRefi resignFirstResponder]; 
}


@end
