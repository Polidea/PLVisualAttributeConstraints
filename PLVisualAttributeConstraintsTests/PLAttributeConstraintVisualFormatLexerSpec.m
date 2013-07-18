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

#define EXP_SHORTHAND

#import "PLAttributeConstraintVisualFormatLexer.h"
#import "PLAttributeConstraintVisualFormatAtom.h"
#import "PLAttributeConstraintVisualFormatLexerSpecHelpers.h"

SPEC_BEGIN(PLAttributeConstraintVisualFormatLexerSpec)

        describe(@"PLAttributeConstraintVisualFormatLexer", ^{

            __block PLAttributeConstraintVisualFormatLexer *lexer;

            beforeEach(^{
                lexer = [[PLAttributeConstraintVisualFormatLexer alloc] init];
            });

            context(@"always", ^{
                it(@"should be awesome", ^{
                    BOOL awesome = YES; // Damn it is!
                    [[theValue(awesome) should] equal:theValue(YES)];
                });
            });

            context(@"parsing empty input string", ^{
                beforeAll(^{
                    lexer.text = @"";
                });
                it(@"should return EOF atom", ^{
                    PLAttributeConstraintVisualFormatAtom *atom = [lexer next];
                    [[theValue(atom.atomType) should] equal:theValue(PLAtomTypeEndOfInput)];
                });
                it(@"should keep returning EOF atom", ^{
                    PLAttributeConstraintVisualFormatAtom *atom = nil;
                    for (int j = 0; j < 5; j++) {
                        atom = [lexer next];
                        [[theValue(atom.atomType) should] equal:theValue(PLAtomTypeEndOfInput)];
                    }
                });
            });

            context(@"parsing samples", ^{

                it(@"should return all supported atoms", ^{

                    lexer = [[PLAttributeConstraintVisualFormatLexer alloc] initWithText:@" . <= == >= identifier + - 23.45 56 ident2 *"];

                    BOOL success = [PLAttributeConstraintVisualFormatLexerSpecHelpers assertLexer:lexer
                                                            returnsAtomsTypesAndStringDataInOrder:
                                                                    @[
                                                                            @[@(PLAtomTypeWhitespace), @" ", @(0)],
                                                                            @[@(PLAtomTypeDot), @".", @(1)],
                                                                            @[@(PLAtomTypeWhitespace), @" ", @(2)],
                                                                            @[@(PLAtomTypeRelationLessOrEqual), @"<=", @(3)],
                                                                            @[@(PLAtomTypeWhitespace), @" ", @(5)],
                                                                            @[@(PLAtomTypeRelationEqual), @"==", @(6)],
                                                                            @[@(PLAtomTypeWhitespace), @" ", @(8)],
                                                                            @[@(PLAtomTypeRelationGreaterOrEqual), @">=", @(9)],
                                                                            @[@(PLAtomTypeWhitespace), @" ", @(11)],
                                                                            @[@(PLAtomTypeIdentifier), @"identifier", @(12)],
                                                                            @[@(PLAtomTypeWhitespace), @" ", @(22)],
                                                                            @[@(PLAtomTypePlus), @"+", @(23)],
                                                                            @[@(PLAtomTypeWhitespace), @" ", @(24)],
                                                                            @[@(PLAtomTypeMinus), @"-", @(25)],
                                                                            @[@(PLAtomTypeWhitespace), @" ", @(26)],
                                                                            @[@(PLAtomTypeFloatingPointNumber), @"23.45", @(27)],
                                                                            @[@(PLAtomTypeWhitespace), @" ", @(32)],
                                                                            @[@(PLAtomTypeFloatingPointNumber), @"56", @(33)],
                                                                            @[@(PLAtomTypeWhitespace), @" ", @(35)],
                                                                            @[@(PLAtomTypeIdentifier), @"ident2", @(36)],
                                                                            @[@(PLAtomTypeWhitespace), @" ", @(42)],
                                                                            @[@(PLAtomTypeAsterisk), @"*", @(43)],
                                                                            @[@(PLAtomTypeEndOfInput), [NSNull null], @(44)]
                                                                    ]
                    ];

                    [[theValue(success) should] equal:theValue(YES)];

                });
                
                it(@"should return correct atoms #1", ^{

                    lexer = [[PLAttributeConstraintVisualFormatLexer alloc] initWithText:@" control1.attr1  <= control2.attr56  "];

                    BOOL success = [PLAttributeConstraintVisualFormatLexerSpecHelpers assertLexer:lexer
                                                            returnsAtomsTypesAndStringDataInOrder:
                                                                    @[
                                                                            @[@(PLAtomTypeWhitespace), @" ", @(0)],
                                                                            @[@(PLAtomTypeIdentifier), @"control1", @(1)],
                                                                            @[@(PLAtomTypeDot), @".", @(9)],
                                                                            @[@(PLAtomTypeIdentifier), @"attr1", @(10)],
                                                                            @[@(PLAtomTypeWhitespace), @"  ", @(15)],
                                                                            @[@(PLAtomTypeRelationLessOrEqual), @"<=", @(17)],
                                                                            @[@(PLAtomTypeWhitespace), @" ", @(19)],
                                                                            @[@(PLAtomTypeIdentifier), @"control2", @(20)],
                                                                            @[@(PLAtomTypeDot), @".", @(28)],
                                                                            @[@(PLAtomTypeIdentifier), @"attr56", @(29)],
                                                                            @[@(PLAtomTypeWhitespace), @"  ", @(35)],
                                                                            @[@(PLAtomTypeEndOfInput), [NSNull null], @(37)],
                                                                    ]
                    ];

                    [[theValue(success) should] equal:theValue(YES)];

                });

                it(@"should return correct atoms #2", ^{

                    lexer = [[PLAttributeConstraintVisualFormatLexer alloc] initWithText:@"a.b.<===>=234.65<=qwer"];

                    BOOL success = [PLAttributeConstraintVisualFormatLexerSpecHelpers assertLexer:lexer
                                                            returnsAtomsTypesAndStringDataInOrder:
                                                                    @[
                                                                            @[@(PLAtomTypeIdentifier), @"a"],
                                                                            @[@(PLAtomTypeDot), @"."],
                                                                            @[@(PLAtomTypeIdentifier), @"b"],
                                                                            @[@(PLAtomTypeDot), @"."],
                                                                            @[@(PLAtomTypeRelationLessOrEqual), @"<="],
                                                                            @[@(PLAtomTypeRelationEqual), @"=="],
                                                                            @[@(PLAtomTypeRelationGreaterOrEqual), @">="],
                                                                            @[@(PLAtomTypeFloatingPointNumber), @"234.65"],
                                                                            @[@(PLAtomTypeRelationLessOrEqual), @"<="],
                                                                            @[@(PLAtomTypeIdentifier), @"qwer"],
                                                                            @[@(PLAtomTypeEndOfInput), [NSNull null]],
                                                                    ]
                    ];

                    [[theValue(success) should] equal:theValue(YES)];

                });

            });

        });

        SPEC_END
