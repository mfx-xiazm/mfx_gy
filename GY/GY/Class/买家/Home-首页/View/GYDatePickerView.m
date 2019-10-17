//
//  GYDatePickerView.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYDatePickerView.h"

@interface GYDatePickerView ()
@property (nonatomic, weak) IBOutlet UIDatePicker *startDateView;
@property (nonatomic, weak) IBOutlet UIDatePicker *endDateView;
@end
@implementation GYDatePickerView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.startDateView addTarget:self action:@selector(pickerValueChange:) forControlEvents:UIControlEventValueChanged];
//    [self.endDateView addTarget :self action:@selector(pickerValueChange:) forControlEvents:UIControlEventValueChanged];
}
- (void)pickerValueChange:(UIDatePicker *)sender  {
    if (sender == self.startDateView) {
        self.endDateView.minimumDate = sender.date;
    }else if(sender == self.endDateView) {
        self.startDateView.maximumDate = sender.date;
    }
}
- (IBAction)comfirmClicked:(UIButton *)sender {
    if (self.action) {
        self.action(self.startDateView.date,self.endDateView.date);
    }
}

@end
