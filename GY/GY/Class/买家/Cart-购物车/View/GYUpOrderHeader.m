//
//  GYUpOrderHeader.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYUpOrderHeader.h"
#import "GYConfirmOrder.h"

@interface GYUpOrderHeader ()
@property (weak, nonatomic) IBOutlet UILabel *receiver;
@property (weak, nonatomic) IBOutlet UILabel *receiver_phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@end
@implementation GYUpOrderHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setDefaultAddress:(GYConfirmAddress *)defaultAddress
{
    _defaultAddress = defaultAddress;
    self.receiver.text = _defaultAddress.receiver;
    self.receiver_phone.text = _defaultAddress.receiver_phone;
    self.address.text = [NSString stringWithFormat:@"%@%@",_defaultAddress.area_name,_defaultAddress.address_detail];
}
- (IBAction)addressClicked:(UIButton *)sender {
    if (self.addressClickedCall) {
        self.addressClickedCall();
    }
}

@end
