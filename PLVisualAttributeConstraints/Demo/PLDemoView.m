//
//  Created by Kamil Jaworski on 16.07.2013.
//  kamil.jaworski@gmail.com
//


#import "PLDemoView.h"
#import "NSLayoutConstraint+PLVisualAttributeConstraints.h"

@implementation PLDemoView {
    UILabel *_titleLabel;
    UIImageView *_image;
    UILabel *_versionLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor blackColor];

        _titleLabel = [self createLabelWithText:@"PLVisualAttributeConstraint Demo"];
        [self addSubview:_titleLabel];

        _image = [self createImageViewWithImage:[UIImage imageNamed:@"guy.png"]];
        [self addSubview:_image];

        _versionLabel = [self createLabelWithText:@"v1.0.0"];
        [self addSubview:_versionLabel];

        [self setupConstraints];

    }
    return self;
}

#pragma mark -- constraints setup

- (void)setupConstraints {

    // !!!

    // Those two methods are interchangeable
    // They create _exactly_ the same constraints

    // First uses this very lib
    // Second shows how to create such constraints using nothing but standard library

    [self setupConstraintsUsingLib];
//    [self setupConstraintsUsingStandardMethod];

}

- (void)setupConstraintsUsingLib {

    NSDictionary *views = @{
            @"parent" : self,
            @"title" : _titleLabel,
            @"version" : _versionLabel,
            @"image" : _image
    };

    [self addConstraints:[NSLayoutConstraint attributeConstraintsWithVisualFormatsArray:
            @[

                    @"title.centerx == parent.centerx",
                    @"title.top == parent.top + 30",

                    @"image.centerx == parent.centerx",
                    @"image.centery == parent.centery",

                    @"version.right == parent.right - 5",
                    @"version.bottom == parent.bottom - 5",

            ]
                                                                                  views:views]];

//
// PS. you can also create single constraints like that:
//
//    [self addConstraint:[NSLayoutConstraint attributeConstraintWithVisualFormat:@"title.centerx == parent.centerx"
//                                                                          views:views]];
//

}

- (void)setupConstraintsUsingStandardMethod {

//    @"title.centerx == self.centerx",
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
//    @"title.top == self.top + 30",
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:30.0]];

//    @"image.centerx == self.centerx",
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_image
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];

//    @"image.centery == self.centery",
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_image
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.0]];

//    @"version.right == self.right - 5",
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_versionLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:-5.0]];

//    @"version.bottom == self.bottom - 5",
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_versionLabel
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:-5.0]];

}

#pragma mark -- controls creating

- (UIImageView *)createImageViewWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    return imageView;
}

- (UILabel *)createLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor grayColor];
    return label;
}

@end
