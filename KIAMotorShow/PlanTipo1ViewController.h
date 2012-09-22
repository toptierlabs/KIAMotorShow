//
//  PlanTipo1ViewController.h
//  KIAMotorShow
//
//  Created by fernando colman on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PlanTipo1ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
    
    IBOutlet UILabel * modeloLabel;
    IBOutlet UILabel * precioLabel;
    IBOutlet UITextField * entrega;
    IBOutlet UILabel * tasaLabel;
    IBOutlet UITextField * plazo;
    IBOutlet UILabel * porcFinanciarLabel;
    IBOutlet UILabel * montoFinanciarLabel;
    IBOutlet UILabel * montoEntregaLabel;
    IBOutlet UILabel * porcBancoLabel;
    IBOutlet UILabel * cuotaLabel;
    IBOutlet UILabel * primerCuota;
    IBOutlet UILabel * textoGastos;
    IBOutlet UILabel * entregaLabel;
    IBOutlet UILabel * tituloLabel;
    
    IBOutlet UITextField * email;
    
    NSString* tipoPlan;
    NSString* modelo;
    int precio;
}

@property (nonatomic,retain) UILabel* modeloLabel;
@property (nonatomic,retain) UILabel* precioLabel;
@property (nonatomic,retain) UITextField* entrega;
@property (nonatomic,retain) UILabel* tasaLabel;
@property (nonatomic,retain) UITextField* plazo;
@property (nonatomic,retain) UILabel* porcFinanciarLabel;
@property (nonatomic,retain) UILabel* montoFinanciarLabel;
@property (nonatomic,retain) UILabel* montoEntregaLabel;
@property (nonatomic,retain) UILabel* porcBancoLabel;
@property (nonatomic,retain) UILabel* cuotaLabel;
@property (nonatomic,retain) UILabel* primerCuota;
@property (nonatomic,retain) UITextField* email;
@property (nonatomic,retain) UILabel* textoGastos;
@property (nonatomic,retain) UILabel* entregaLabel;
@property (nonatomic,retain) UILabel* tituloLabel;

@property (nonatomic,retain) NSString* tipoPlan;
@property (nonatomic,retain) NSString* modelo;
@property (nonatomic) int precio;

-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;


@end
