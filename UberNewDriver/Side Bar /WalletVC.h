//
//  WalletVC.h
//  AloBasha  Driver
//
//  Created by Spextrum on 08/06/17.
//  Copyright © 2017 Deep Gami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface WalletVC : BaseVC
@property (weak, nonatomic) IBOutlet UIButton *Btn_Navigation;
@property (weak, nonatomic) IBOutlet UIButton *BtnBack;
- (IBAction)Back_Button:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *BtnAddMoney;
- (IBAction)BtnMoneyAdd:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *LblAmount;
@property (weak, nonatomic) IBOutlet UINavigationBar *Bar_Navigation;
@property (weak, nonatomic) IBOutlet UIView *ViewForWithdrawAmount;
@property (weak, nonatomic) IBOutlet UITextField *TxtAmount;
@property (weak, nonatomic) IBOutlet UIButton *BtnConfirm;
@property (weak, nonatomic) IBOutlet UIButton *BtnCancel;
- (IBAction)ConfirmButton:(id)sender;
- (IBAction)CancelButton:(id)sender;

@end
