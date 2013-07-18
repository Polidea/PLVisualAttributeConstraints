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

#import <Kiwi/Kiwi.h>

#import <CoreData/CoreData.h>

#import "PLAttributeConstraintVisualFormatAtom.h"
#import "PLAttributeConstraintVisualFormatLexerStub.h"
#import "PLAttributeConstraintVisualFormatParser.h"
#import "PLAttributeConstraintVisualFormatLibSpecHelpers.h"

#define EXP_SHORTHAND


SPEC_BEGIN(PLAttributeConstraintVisualFormatParserSpec)

        describe(@"PLAttributeConstraintVisualFormatParser", ^{

            __block PLAttributeConstraintVisualFormatLexerStub *lexerMock;
            __block PLAttributeConstraintVisualFormatParser *parser;
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

                lexerMock = nil;

            });

            context(@"should parse sample input", ^{
                it(@"#1", ^{

                    lexerMock = [PLAttributeConstraintVisualFormatLexerStub stubWithAtomsArray:@[

                            [PLAttributeConstraintVisualFormatAtom atomWithType:PLAtomTypeIdentifier stringData:@"first" startIndex:0],
                            [PLAttributeConstraintVisualFormatAtom atomWithType:PLAtomTypeDot stringData:@"." startIndex:5],
                            [PLAttributeConstraintVisualFormatAtom atomWithType:PLAtomTypeIdentifier stringData:@"top" startIndex:6],

                            [PLAttributeConstraintVisualFormatAtom atomWithType:PLAtomTypeRelationEqual stringData:@"==" startIndex:9],

                            [PLAttributeConstraintVisualFormatAtom atomWithType:PLAtomTypeIdentifier stringData:@"second" startIndex:11],
                            [PLAttributeConstraintVisualFormatAtom atomWithType:PLAtomTypeDot stringData:@"." startIndex:17],
                            [PLAttributeConstraintVisualFormatAtom atomWithType:PLAtomTypeIdentifier stringData:@"top" startIndex:18],

                            [PLAttributeConstraintVisualFormatAtom atomWithType:PLAtomTypeEndOfInput stringData:nil startIndex:21],

                    ]];

                    parser = [[PLAttributeConstraintVisualFormatParser alloc] initWithLexer:lexerMock];

                    NSLayoutConstraint *parsed = [parser parseConstraintWithViews:views];
                    NSLayoutConstraint *reference = [NSLayoutConstraint constraintWithItem:first
                                                                                 attribute:NSLayoutAttributeTop
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:second
                                                                                 attribute:NSLayoutAttributeTop
                                                                                multiplier:1 constant:0];

                    BOOL success = [PLAttributeConstraintVisualFormatLibSpecHelpers isConstraint:parsed equalToConstraint:reference];

                    [[theValue(success) should] equal:theValue(YES)];

                });
            });

        });

        SPEC_END
