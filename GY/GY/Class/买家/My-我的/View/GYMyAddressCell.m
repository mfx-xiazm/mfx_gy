//
//  GYMyAddressCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyAddressCell.h"
#import "GYConfirmOrder.h"

@interface GYMyAddressCell ()
@property (weak, nonatomic) IBOutlet UILabel *receiver;
@property (weak, nonatomic) IBOutlet UILabel *receiver_phone;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *is_defalt;

@end
@implementation GYMyAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setAddress:(GYConfirmAddress *)address
{
    _address = address;
    self.receiver.text = _address.receiver;
    self.receiver_phone.text = _address.receiver_phone;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",_address.area_name,_address.address_detail];
    self.is_defalt.hidden = !_address.is_default;
}

- (IBAction)editClicked:(UIButton *)sender {
    if (self.editClickedCall) {
        self.editClickedCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
