//
//  CEPopupPickerView.m
//  CEPopupPickerView
//
//  Created by Chris Eidhof on 2/4/12.
//  Copyright (c) 2012 Chris Eidhof. All rights reserved.
//

#import "CEPopupPickerView.h"


@interface CEPopupPickerView () {
@private
    NSArray* values;
    UIView* glassPane;
    UIView* parentView;
    UIPickerView* CEPickerView;
    NSInteger selectedIndex;
}

- (void)setupGlasspane;
- (void)setupAndAddPickerView;
- (void)animatePickerViewFromBottomOfParentView;
- (void)movePickerViewToBottomOfParentView;
- (void)movePickerViewOutsideBoundsOfParentView;
- (BOOL)isDisplaying;

@end

@implementation CEPopupPickerView

@synthesize callback, pickerAccessibilityLabel;

- (id)initWithValues:(NSArray*)theValues callback:(pickerViewCloseHandler)theCallback {
    self = [super init];
    if(self) {
        values = theValues;
        self.callback = theCallback;
        selectedIndex = 0;
    }
    return self;
}

- (void)presentInView:(UIView*)theParentView {
    parentView = theParentView;
    [self setupGlasspane];
    [parentView addSubview:glassPane];
    [self setupAndAddPickerView];
    [self animatePickerViewFromBottomOfParentView];
}

- (void)close {
    if (![self isDisplaying]) return;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self movePickerViewToBottomOfParentView];
    } completion:^(BOOL finished) {
        [glassPane removeFromSuperview];
    }];
}

- (NSInteger)selectedIndex {
    return [CEPickerView selectedRowInComponent:0];
}

- (void)setSelectedIndex:(NSInteger)theSelectedIndex {
    if(theSelectedIndex > [values count]-1) {
        NSException* e = [NSException exceptionWithName:NSInvalidArgumentException reason:@"Selected index out of bounds" userInfo:nil];
        [e raise];
    }
    selectedIndex = theSelectedIndex;
    BOOL animateSelection = [self isDisplaying];
    [CEPickerView selectRow:selectedIndex inComponent:0 animated:animateSelection];
}

- (void)setupGlasspane {
    if(glassPane != nil) return;
    glassPane = [[UIView alloc] initWithFrame:parentView.bounds];
    glassPane.accessibilityLabel = @"Tap to close";
    glassPane.backgroundColor = [UIColor clearColor];
    glassPane.opaque = NO;
    UITapGestureRecognizer* glassPaneTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGlassPane:)];
    [glassPane addGestureRecognizer:glassPaneTapRecognizer];
}

- (void)setupAndAddPickerView {
    if(CEPickerView != nil) return;
    
    CEPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [glassPane addSubview:CEPickerView];
    CEPickerView.delegate = self;
    CEPickerView.dataSource = self;
    CEPickerView.showsSelectionIndicator = YES;
    CEPickerView.accessibilityLabel = self.pickerAccessibilityLabel;
    [CEPickerView selectRow:selectedIndex inComponent:0 animated:YES];
    UITapGestureRecognizer* pickerViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPickerView:)];
    pickerViewTapGestureRecognizer.cancelsTouchesInView = NO;
    [CEPickerView addGestureRecognizer:pickerViewTapGestureRecognizer];
}

- (void)animatePickerViewFromBottomOfParentView {
    [self movePickerViewToBottomOfParentView];
    [UIView animateWithDuration:0.2 animations:^{
        [self movePickerViewOutsideBoundsOfParentView];
    }];
}

- (void)movePickerViewToBottomOfParentView {
    CGFloat maxY = CGRectGetMaxY(parentView.bounds);
    CGRect pickerFrame = CEPickerView.frame;
    pickerFrame.origin.y = maxY;
    CEPickerView.frame = pickerFrame;
}

- (void)movePickerViewOutsideBoundsOfParentView {
    CGFloat maxY = CGRectGetMaxY(parentView.bounds);
    CGRect pickerFrame = CEPickerView.frame;
    pickerFrame.origin.y = maxY - pickerFrame.size.height;
    CEPickerView.frame = pickerFrame;
}

- (void)notifyDelegateAndClose {
    selectedIndex = [CEPickerView selectedRowInComponent:0];
    callback(selectedIndex);
    [self close];
}

- (BOOL)isDisplaying {
    return [glassPane superview] != nil;
}

#pragma mark UIGestureRecognizer callbacks

- (void)tapGlassPane:(UITapGestureRecognizer*)sender {
    [self notifyDelegateAndClose];
}

- (void)tapPickerView:(UITapGestureRecognizer*)sender {
    CGPoint point = [sender locationInView:CEPickerView];
    const CGFloat numberOfVisibleRows = 5;
    const CGFloat middleRow = 2;
    CGFloat heightOfPickerRow = CEPickerView.frame.size.height/numberOfVisibleRows;
    CGFloat tappedRow = floor(point.y / heightOfPickerRow);
    if(tappedRow == middleRow) {
        [self notifyDelegateAndClose];
    }
    
}

#pragma mark UIPickerView methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [values objectAtIndex:row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [values count];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSArray *betOptions = @[@"5",@"10",@"15",@"20",@"25",@"50",@"75",@"100"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,pickerView.frame.size.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    label.text = [NSString stringWithFormat:@"%@", [betOptions objectAtIndex:row]];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}


@end
