//
//  NMReceiveTableViewCell.h
//  NotifyMe
//
//  Created by Jeff Kibuule on 8/14/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMReceiveTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *alertLabel;
@property (nonatomic, weak) IBOutlet UILabel *customPayloadLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeStampLabel;


@end
