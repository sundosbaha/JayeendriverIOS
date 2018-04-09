//
//  RightSideMenu.h
//  TaxiAppz Driver
//
//  Created by Spextrum on 17/05/17.
//  Copyright © 2017 Deep Gami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "PickMeUpMapVC.h"
#import "ArrivedMapVC.h"
#import "CellSlider.h"
#import "UIView+Utils.h"
#import "UIImageView+Download.h"
#import "ProviderLogout.h"

@interface RightSideMenu : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    BOOL internet;
}
@property (nonatomic,strong) PickMeUpMapVC *ViewObj;

@end
