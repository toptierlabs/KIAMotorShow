//
//  PlanTipo1ViewController.m
//  KIAMotorShow
//
//  Created by fernando colman on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlanTipo1ViewController.h"
#include <math.h>

@implementation PlanTipo1ViewController

@synthesize modeloLabel,precioLabel,entrega,tasaLabel,plazo,porcFinanciarLabel,montoFinanciarLabel,montoEntregaLabel,porcBancoLabel,cuotaLabel,tipoPlan,modelo,precio,email,primerCuota,textoGastos,entregaLabel,tituloLabel;

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
    
    if ([tipoPlan isEqualToString:@"PrimerCuota3Meses"] || [tipoPlan isEqualToString:@"TasaLoca"]) {
        
        if ([entrega.text intValue] < 20 || [entrega.text intValue] > 90) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"El valor de la entrega debe de estar entre 20% y 90%"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            entrega.text = @"";

        }
    }
}

-(IBAction)calcular:(id)sender{
    
    
    bool error = false;
    if ([tipoPlan isEqualToString:@"PrimerCuota3Meses"] || [tipoPlan isEqualToString:@"TasaLoca"]) {
        
        if ([entrega.text intValue] < 20 || [entrega.text intValue] > 90) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"El valor de la entrega debe de estar entre 20% y 90%"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            entrega.text = @"";
            
            error = true;
        }
    }
    
    if(!error)
    {
            
            int cantCuotas;
            double tmu,tmi,cb;
            
            if ([plazo.text isEqualToString:@"60 meses"]) {
                cantCuotas = 60;
            } else if ([plazo.text isEqualToString:@"48 meses"]) {
                cantCuotas = 48;       
            }
            else if ([plazo.text isEqualToString:@"36 meses"]) {
                cantCuotas = 36;       
            }
            else if ([plazo.text isEqualToString:@"24 meses"]) {
                cantCuotas = 24;       
            }
            else if ([plazo.text isEqualToString:@"18 meses"]) {
                cantCuotas = 18;       
            }
            else{
                cantCuotas = 12;
            }
            
            if ([tipoPlan isEqualToString:@"PrimerCuota3Meses"]) {
                tmu = 0.00596186556442779;
                tmi = 0.00727347598860191;
                cb = 0.98;
            }
            else if([tipoPlan isEqualToString:@"TasaLoca"]){
                tmu = 0.00393957509926013;
                
                tmi = 0.00480628162109736;
                
                cb = 0.98;
            }
            else if([tipoPlan isEqualToString:@"50-50"]){
                tmi = 0.0000000100273968950404;
                
                tmu = 0.00000000821917778282;
                
                cb = 0.995;
                
            }
            
            int porcFinanciar = 100 - [entrega.text intValue];
            [porcFinanciarLabel setText:[NSString stringWithFormat:@"%d%%", porcFinanciar]];
            
            double porc = ([entrega.text doubleValue]/100);
            
            double montoAdelanto = precio * porc;
            
            int intMontoAdelanto =  round(montoAdelanto);
        
            
        
            NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
            numberFormat.usesGroupingSeparator = YES;
            numberFormat.groupingSeparator = @".";
            numberFormat.groupingSize = 3;
            NSString *stringNumber = [numberFormat stringFromNumber:[NSNumber numberWithInt:intMontoAdelanto]];
            
            
            [montoEntregaLabel setText:[NSString stringWithFormat:@"%@",stringNumber]];
            
            
            
            int montoFinanciar = round((precio - montoAdelanto) / cb);
        
            numberFormat = [[NSNumberFormatter alloc] init];
            numberFormat.usesGroupingSeparator = YES;
            numberFormat.groupingSeparator = @".";
            numberFormat.groupingSize = 3;
            stringNumber = [numberFormat stringFromNumber:[NSNumber numberWithInt:montoFinanciar]];

            
            [montoFinanciarLabel setText:[NSString stringWithFormat:@"USD %@", stringNumber]];
            
            
            
            double capital = montoFinanciar;
            double ints = 0;
            double ivaints = 0;
            if(![tipoPlan isEqualToString:@"50-50"]){
                ints = capital * tmu;
                ivaints = ints * 0.22;
            }
            
            double cuota = capital / ((1 - pow((1 / (1 + tmi)), cantCuotas)) / tmi);
            //double amortCap = cuota - ints - ivaints;
            double sv = capital * 0.00060;
            double tcps = (capital + ints) * 0.000332;
            int cuotaTotal = round(cuota + tcps + sv);
        
            numberFormat = [[NSNumberFormatter alloc] init];
            numberFormat.usesGroupingSeparator = YES;
            numberFormat.groupingSeparator = @".";
            numberFormat.groupingSize = 3;
            stringNumber = [numberFormat stringFromNumber:[NSNumber numberWithInt:cuotaTotal]];
            
            [cuotaLabel setText:[NSString stringWithFormat:@"%@", stringNumber]];
            
        
    }
    

    
    
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
    body = [NSString stringWithFormat:@"%@\n- PVP(Precio de venta al público)    USD %d", body, precio];
    body = [NSString stringWithFormat:@"%@\n- Entrega    USD %@", body, montoEntregaLabel.text];
    body = [NSString stringWithFormat:@"%@\n- Plazo    %@", body, plazo.text];
    body = [NSString stringWithFormat:@"%@\n- A Financiar(porcentaje a financiar y monto a financiar)    %@", body,  [NSString stringWithFormat:@"%@ - %@", porcFinanciarLabel.text, montoFinanciarLabel.text]];
    
    if ([tipoPlan isEqualToString:@"50-50"])
    {
        body = [NSString stringWithFormat:@"%@\n-  Cuota mensual    USD %@", body, cuotaLabel.text];
    }   
    else
    {
        body = [NSString stringWithFormat:@"%@\n-  Valor de primera cuota    USD %@", body, cuotaLabel.text];
    }
    
    body = [NSString stringWithFormat:@"%@\n\n  La presente cotización es válida por 30 días", body];
    
    if ([tipoPlan isEqualToString:@"PrimerCuota3Meses"] || [tipoPlan isEqualToString:@"TasaLoca"]) {
        body = [NSString stringWithFormat:@"%@\n\n\n  *Se incluyen gastos de seguro de vida para personas físicas \n", body];
        body = [NSString stringWithFormat:@"%@  *Incluye gastos administrativos \n", body];
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
            message = @"Cancelado";
            break;
        case MFMailComposeResultSaved:
            message = @"Salvado";
            break;
        case MFMailComposeResultSent:
            message = @"Enviado";
            break;
        case MFMailComposeResultFailed:
            message = @"Falló";
            break;
        default:
            message = @"No enviado";
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
    NSString *recipients = [NSString stringWithFormat: @"mailto:%@&subject=%@", mailTo, subject];
    
    
    NSString *body = @"&body=";
    
    body = [NSString stringWithFormat:@"%@\n- Producto    %@", body, modelo];
    body = [NSString stringWithFormat:@"%@\n- PVP(Precio de venta al público)    U$S%d", body, precio];
    body = [NSString stringWithFormat:@"%@\n- Entrega    U$S%@", body, montoEntregaLabel.text];
    body = [NSString stringWithFormat:@"%@\n- Plazo    %@", body, plazo.text];
    body = [NSString stringWithFormat:@"%@\n- A Financiar(porcentaje a financiar y monto a financiar)    %@", body,  [NSString stringWithFormat:@"%@-U$S%@", porcFinanciarLabel.text, montoFinanciarLabel.text]];
   
    
    if ([tipoPlan isEqualToString:@"50-50"])
    {
        body = [NSString stringWithFormat:@"%@\n-  Cuota mensual    U$S%@", body, cuotaLabel.text];
    }   
    else
    {
        body = [NSString stringWithFormat:@"%@\n-  Valor de primera cuota    U$S%@", body, cuotaLabel.text];
    }
    
    body = [NSString stringWithFormat:@"%@\n\n\n  *Se incluyen gastos de seguro de vida para personas físicas", body];

    
    NSString *mail = [[NSString alloc] initWithFormat:@"%@%@", recipients, body];
    NSString *encodedEmail = [mail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodedEmail]];

}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
    
    
    numberFormat.usesGroupingSeparator = YES;
    
    
    numberFormat.groupingSeparator = @".";
    
    
    numberFormat.groupingSize = 3;
    
    
    
    NSString *stringNumber = [numberFormat stringFromNumber:[NSNumber numberWithInt:precio]];

   
    
    [modeloLabel setText:modelo];
    [precioLabel setText:[NSString stringWithFormat:@"%@", stringNumber]];
    [porcBancoLabel setText:@"2%"];
    
    
    if ([tipoPlan isEqualToString:@"PrimerCuota3Meses"]) {
        [tasaLabel setText:@"7.5%"];
        [porcFinanciarLabel setText:[NSString stringWithFormat:@"%d%%", 0]];
        [self.navigationItem setTitle:@"PRIMER CUOTA EN 3 MESES"];
        subject = @"PRIMER CUOTA EN 3 MESES – Flexiplan BBVA";
        
        plazos = [[NSArray alloc] initWithObjects:@"60 meses", @"48 meses",@"36 meses",@"24 meses",@"18 meses",@"12 meses",nil];
        plazo.text = @"60 meses";
        entregaLabel.text = @"ENTREGA (Entre 20% y 90%)";
        tituloLabel.text = @"TASA";
    } else if([tipoPlan isEqualToString:@"TasaLoca"]){
        [tasaLabel setText:@"4.9%"];
        [porcFinanciarLabel setText:[NSString stringWithFormat:@"%d%%", 0]];
        [self.navigationItem setTitle:@"TASA LOCA"];
        subject = @"TASA LOCA – Flexiplan BBVA";
        
        plazos = [[NSArray alloc] initWithObjects:@"48 meses",@"36 meses",@"24 meses",@"18 meses",@"12 meses",nil];
        plazo.text = @"48 meses";
        entregaLabel.text = @"ENTREGA (Entre 20% y 90%)";
         tituloLabel.text = @"TASA BONIFICADA";
    } else if([tipoPlan isEqualToString:@"Ganate1Año"]){
        [tasaLabel setText:@"0.0%"];
        [self.navigationItem setTitle:@"GANATE 1 AÑO"];
        [porcFinanciarLabel setText:[NSString stringWithFormat:@"%d%%", 0]];
        subject = @"GANATE 1 AÑO – Flexiplan BBVA";
    } else if([tipoPlan isEqualToString:@"50-50"]){
        [tasaLabel setText:@"0.0%"];
        [self.navigationItem setTitle:@"50-50 24 MESES 0% INTERES"];
        subject = @"50-50 – Flexiplan BBVA";
        [porcFinanciarLabel setText:[NSString stringWithFormat:@"%d%%", 0]];
        
        plazos = [[NSArray alloc] initWithObjects:@"24 meses",@"18 meses",@"12 meses",nil];
        plazo.text = @"24 meses";
        
        primerCuota.text = @"CUOTA MENSUAL";
        
        textoGastos.text = @"";
        
        entrega.userInteractionEnabled = NO;
        entrega.borderStyle=UITextBorderStyleNone;
        entrega.text = @"50";
        
        tituloLabel.text = @"50-50 0% HASTA 24 CUOTAS";
        
    }
    
    
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
    
    plazo.inputView = pickerViewFrom;
    plazo.inputAccessoryView = toolbar;

    
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
    
    plazo.text =  [plazos objectAtIndex:row];
    
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
    [plazo resignFirstResponder]; 
}


@end
