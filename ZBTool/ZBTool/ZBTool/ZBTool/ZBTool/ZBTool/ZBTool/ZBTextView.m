//
//  ZBTextView.m
//  ZBTool
//
//  Created by qmap01 on 2017/6/29.
//  Copyright © 2017年 Zhaobin. All rights reserved.
//

#import "ZBTextView.h"
#define kPLACEHOLDER_FRAME(frame)   CGRectMake(8.0f, 8.0f, (frame).size.width - 16.0f, (frame).size.height - 16.0f)
#define kPLACEHOLDER_COLOR   [UIColor colorWithWhite:0.702f alpha:1.0f]

@interface ZBTextView ()

@property(nonatomic, assign)BOOL shouldDrawPlaceholder;
//- (void)_initialize;
//- (void)_updateShouldDrawPlaceholder;
//- (void)_textChanged:(NSNotification *)notification;
@end


@implementation ZBTextView
@synthesize shouldDrawPlaceholder = _shouldDrawPlaceholder;
@synthesize placeholder = _placeholder;
@synthesize placeholderColor = _placeholderColor;
- (void)setText:(NSString *)string {
    [super setText:string];
    [self _updateShouldDrawPlaceholder];
}


- (void)setPlaceholder:(NSString *)string {
    if ([string isEqual:_placeholder]) {
        return;
    }
    
    _placeholder = string;
    
    
    [self _updateShouldDrawPlaceholder];
}


#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self _initialize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self _initialize];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (_shouldDrawPlaceholder) {
        [_placeholderColor set];
        [_placeholder drawInRect:kPLACEHOLDER_FRAME(self.frame) withAttributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:_placeholderColor}
         ];
    }
}

#pragma mark - Private

- (void)_initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:self];
    
    self.placeholderColor = kPLACEHOLDER_COLOR;
    _shouldDrawPlaceholder = NO;
}


- (void)_updateShouldDrawPlaceholder {
    BOOL prev = _shouldDrawPlaceholder;
    _shouldDrawPlaceholder = self.placeholder && self.placeholderColor && self.text.length == 0;
    
    if (prev != _shouldDrawPlaceholder) {
        [self setNeedsDisplay];
    }
}


- (void)_textChanged:(NSNotification *)notificaiton {
    [self _updateShouldDrawPlaceholder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
