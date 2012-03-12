//
//  PlanTipo2ViewController.h
//  KIAMotorShow
//
//  Created by fernando colman on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PlanTipo2ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
    
    IBOutlet UILabel * modeloLabel;
    IBOutlet UILabel * precioLabel;
    IBOutlet UILabel * entregaLabel;
    IBOutlet UILabel * tasaLabel;
    IBOutlet UILabel * plazo;
    IBOutlet UILabel * porcFinanciarLabel;
    IBOutlet UILabel * montoFinanciarLabel;
    IBOutlet UILabel * porcBancoLabel;
    IBOutlet UILabel * cuotaAnualLabel;
    IBOutlet UITextField * plazoRefi;
    IBOutlet UILabel * comiRefiLabel;
    IBOutlet UILabel * cuotaMensLabel;
    
    IBOutlet UITextField * email;
    
    NSString* tipoPlan;
    NSString* modelo;
    int precio;
}

@property (nonatomic,retain) UILabel* modeloLabel;
@property (nonatomic,retain) UILabel* precioLabel;
@property (nonatomic,retain) UILabel* entregaLabel;
@property (nonatomic,retain) UILabel* tasaLabel;
@property (nonatomic,retain) UILabel* plazo;
@property (nonatomic,retain) UILabel* porcFinanciarLabel;
@property (nonatomic,retain) UILabel* montoFinanciarLabel;
@property (nonatomic,retain) UILabel* porcBancoLabel;
@property (nonatomic,retain) UILabel* cuotaAnualLabel;
@property (nonatomic,retain) UITextField* plazoRefi;
@property (nonatomic,retain) UILabel* comiRefiLabel;
@property (nonatomic,retain) UILabel* cuotaMensLabel;


@property (nonatomic,retain) UITextField* email;

@property (nonatomic,retain) NSString* tipoPlan;
@property (nonatomic,retain) NSString* modelo;
@property (nonatomic) int precio;

-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;


@end
