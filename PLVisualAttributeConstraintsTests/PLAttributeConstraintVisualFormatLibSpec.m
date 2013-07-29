/*

 Copyright (c) 2013, Kamil Jaworski, Polidea
 All rights reserved.

 mailto: kamil.jaworski@gmail.com

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the Polidea nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY KAMIL JAWORSKI, POLIDEA ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL KAMIL JAWORSKI, POLIDEA BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */

#import "Kiwi.h"

#define EXP_SHORTHAND

#import <CoreGraphics/CoreGraphics.h>

#import "PLAttributeConstraintVisualFormatLibSpecHelpers.h"
#import "NSLayoutConstraint+PLVisualAttributeConstraints.h"

SPEC_BEGIN(PLAttributeConstraintVisualFormatLibSpec)

        describe(@"PLAttributeConstraintVisualFormatLibSpec", ^{

            __block UIView *first;
            __block UIView *second;
            __block NSDictionary *views;

            beforeEach(^{

                first = [[UIView alloc] initWithFrame:CGRectZero];
                second = [[UIView alloc] initWithFrame:CGRectZero];

                views = @{
                        @"first" : first,
                        @"second" : second
                };

            });

            context(@"should fail while parsing invalid formats samples:", ^{
                it(@"invalid #1", ^{
                    NSLayoutConstraint *parsed = [NSLayoutConstraint attributeConstraintWithVisualFormat:@"someNonexistingControl.top == second.top" views:views];
                    [[parsed should] beNil];
                });
                it(@"invalid #2", ^{
                    NSLayoutConstraint *parsed = [NSLayoutConstraint attributeConstraintWithVisualFormat:@"first.top = second.top" views:views];
                    [[parsed should] beNil];
                });
                it(@"invalid #3", ^{
                    NSLayoutConstraint *parsed = [NSLayoutConstraint attributeConstraintWithVisualFormat:@"first.top < second.top" views:views];
                    [[parsed should] beNil];
                });
                it(@"invalid #4", ^{
                    NSLayoutConstraint *parsed = [NSLayoutConstraint attributeConstraintWithVisualFormat:@"first.topleft <= second.top" views:views];
                    [[parsed should] beNil];
                });
            });

            context(@"should parse samples:", ^{

                it(@"#1", ^{

                    NSLayoutConstraint *parsed = [NSLayoutConstraint attributeConstraintWithVisualFormat:@"first.top == second.top" views:views];

                    NSLayoutConstraint *original = [NSLayoutConstraint constraintWithItem:first
                                                                                attribute:NSLayoutAttributeTop
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:second
                                                                                attribute:NSLayoutAttributeTop
                                                                               multiplier:1
                                                                                 constant:0];

                    [[theValue(parsed) shouldNot] equal:theValue(nil)];
                    [[theValue(original) shouldNot] equal:theValue(nil)];

                    BOOL success = [PLAttributeConstraintVisualFormatLibSpecHelpers isConstraint:parsed
                                                                               equalToConstraint:original];

                    [[theValue(success) should] equal:theValue(YES)];

                });

                it(@"#2", ^{

                    NSLayoutConstraint *parsed = [NSLayoutConstraint attributeConstraintWithVisualFormat:@"first.bottom <= second.left * 2 - 10" views:views];

                    NSLayoutConstraint *original = [NSLayoutConstraint constraintWithItem:first
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                   toItem:second
                                                                                attribute:NSLayoutAttributeLeft
                                                                               multiplier:2
                                                                                 constant:-10];

                    [[theValue(parsed) shouldNot] equal:theValue(nil)];
                    [[theValue(original) shouldNot] equal:theValue(nil)];

                    BOOL success = [PLAttributeConstraintVisualFormatLibSpecHelpers isConstraint:parsed
                                                                               equalToConstraint:original];

                    [[theValue(success) should] equal:theValue(YES)];

                });

                it(@"#3", ^{

                    NSLayoutConstraint *parsed = [NSLayoutConstraint attributeConstraintWithVisualFormat:@"first.bottom <= 100" views:views];

                    NSLayoutConstraint *original = [NSLayoutConstraint constraintWithItem:first
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                   toItem:first
                                                                                attribute:NSLayoutAttributeBottom
                                                                               multiplier:0
                                                                                 constant:100];

                    [[theValue(parsed) shouldNot] equal:theValue(nil)];
                    [[theValue(original) shouldNot] equal:theValue(nil)];

                    BOOL success = [PLAttributeConstraintVisualFormatLibSpecHelpers isConstraint:parsed
                                                                               equalToConstraint:original];

                    [[theValue(success) should] equal:theValue(YES)];

                });

                it(@"#4 (hack sample)", ^{

                    NSLayoutConstraint *parsed = [NSLayoutConstraint attributeConstraintWithVisualFormat:@"first.top <= 100" views:views];

                    NSLayoutConstraint *original = [NSLayoutConstraint constraintWithItem:first
                                                                                attribute:NSLayoutAttributeTop
                                                                                relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                   toItem:first
                                                                                attribute:NSLayoutAttributeTop
                                                                               multiplier:0
                                                                                 constant:100];

                    [[theValue(parsed) shouldNot] equal:theValue(nil)];
                    [[theValue(original) shouldNot] equal:theValue(nil)];

                    BOOL success = [PLAttributeConstraintVisualFormatLibSpecHelpers isConstraint:parsed
                                                                               equalToConstraint:original];

                    [[theValue(success) should] equal:theValue(YES)];

                });

                it(@"#5", ^{

                    NSLayoutConstraint *parsed = [NSLayoutConstraint attributeConstraintWithVisualFormat:@"_first.bottom <= _s_econd.top" views:
                    @{
                            @"_first": first,
                            @"_s_econd": second
                    }];

                    NSLayoutConstraint *original = [NSLayoutConstraint constraintWithItem:first
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                   toItem:second
                                                                                attribute:NSLayoutAttributeTop
                                                                               multiplier:1
                                                                                 constant:0];

                    [[theValue(parsed) shouldNot] equal:theValue(nil)];
                    [[theValue(original) shouldNot] equal:theValue(nil)];

                    BOOL success = [PLAttributeConstraintVisualFormatLibSpecHelpers isConstraint:parsed
                                                                               equalToConstraint:original];

                    [[theValue(success) should] equal:theValue(YES)];

                });

            });

        });


        SPEC_END
