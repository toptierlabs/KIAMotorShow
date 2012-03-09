//
//  PlanTipo2ViewController.m
//  KIAMotorShow
//
//  Created by fernando colman on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlanTipo2ViewController.h"

@implementation PlanTipo2ViewController

@synthesize modeloLabel,precioLabel,entrega,tasaLabel,plazo,porcFinanciarLabel,montoFinanciarLabel,plazoRefiLabel,comiRefiLabel;
@synthesize porcBancoLabel,cuotaMensLabel,cuotaAnualLabel,tipoPlan,modelo,precio,email;

NSString* subject;

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
//    int cantCuotas;
//    double tmu,tmi;
//    if ([tipoPlan isEqualToString:@"PrimerCuota3Meses"]) {
//        cantCuotas = 60;
//        tmu = 0.00634561366202258;
//        tmi = 0.00774164866766754;
//    }
//    else{
//        cantCuotas = 48;
//        tmu = 0.00393957509926013;
//        
//        tmi = 0.00480628162109736;
//    }
    
    int porcFinanciar = 100 - [entrega.text intValue];
    [porcFinanciarLabel setText:[NSString stringWithFormat:@"%d%%", porcFinanciar]];
    
    double porc = ([entrega.text doubleValue]/100);    
    
    double montoAdelanto = precio * porc;
    
    int montoFinanciar = round(precio - montoAdelanto);
    
    [montoFinanciarLabel setText:[NSString stringWithFormat:@"%d", montoFinanciar]];

//    double capital = [montoFinanciarLabel.text doubleValue];
//    double ints = capital * tmu;
//    double ivaints = ints * 0.22;
//    double cuota = capital / ((1 - pow((1 / (1 + tmi)), cantCuotas)) / tmi);
//    double amortCap = cuota - ints - ivaints;
//    double sv = capital * 0.00060;
//    double tcps = (capital + ints) * 0.000332;
//    int cuotaTotal = round(cuota + tcps + sv);
    
    [cuotaAnualLabel setText:[NSString stringWithFormat:@"%d", montoFinanciar]];
    
    
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
    body = [NSString stringWithFormat:@"%@\n- Entrega    50%"];
    body = [NSString stringWithFormat:@"%@\n- Plazo    %@", body, plazo.text];
    body = [NSString stringWithFormat:@"%@\n- A Financiar(porcentaje a financiar y monto a financiar)    %@", body,  [NSString stringWithFormat:@"%@-U$S%@", porcFinanciarLabel.text, montoFinanciarLabel.text]];
    body = [NSString stringWithFormat:@"%@\n-  Valor de primera cuota    U$S%@", body, cuotaMensLabel.text];
    
    if ([tipoPlan isEqualToString:@"PrimerCuota3Meses"] || [tipoPlan isEqualToString:@"TasaLoca"]) {
        body = [NSString stringWithFormat:@"%@\n\n\n  *Se incluyen gastos de seguro de vida para personas físicas", body];
    }
    

    
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
    body = [NSString stringWithFormat:@"%@\n- Entrega    50%"];
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
    
    [modeloLabel setText:modelo];
    [precioLabel setText:[NSString stringWithFormat:@"%d", precio]];

    
    [tasaLabel setText:@"0.0%"];
    [plazo setText:@"12 meses"];
    [self.navigationItem setTitle:@"GANATE 1 AÑO"];
    subject = @"GANATE 1 AÑO – Flexiplan BBVA";
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

@end
