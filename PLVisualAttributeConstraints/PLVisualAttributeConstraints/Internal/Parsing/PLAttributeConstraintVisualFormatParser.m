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


#import "PLAttributeConstraintVisualFormatParser.h"
#import "PLAttributeConstraintVisualFormatLexer.h"
#import "PLAttributeConstraintVisualFormatAtom.h"
#import "PLConstraintLayoutAttributeMapper.h"
#import "PLAttributeConstraintVisualFormatLexerProtocol.h"
#import "PLControlWithAttributeParser.h"
#import "PLRelationParser.h"
#import "PLConstantExpressionParser.h"
#import "PLMultiplierExpressionParser.h"
#import "PLVisualFormatErrorLogger.h"

#define PLAttributeConstraintFormatParserDebuggingLogsEnabled 0

@implementation PLAttributeConstraintVisualFormatParser {
    id <PLAttributeConstraintVisualFormatLexerProtocol> _lexer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lexer = nil;
    }
    return self;
}

- (instancetype)initWithLexer:(id <PLAttributeConstraintVisualFormatLexerProtocol>)lexer {
    self = [super init];
    if (self) {
        _lexer = lexer;
    }
    return self;
}

#pragma mark - main parsing method

- (NSLayoutConstraint *)parseConstraintWithViews:(NSDictionary *)views {

    NSAssert(_lexer, @"Trying to parse constraint but no lexer provided", nil);
    NSAssert(views, @"Trying to parse constraint but no views provided", nil);

#if PLAttributeConstraintFormatParserDebuggingLogsEnabled
    NSLog(@"PLAttributeConstraintVisualFormatParser: Creating constraint for format: %@", _lexer.text);
#endif

    CGFloat multiplier = 1.0f;
    CGFloat constant = 0.0f;

    [self omitWhiteSpaces];

    PLControlWithAttributeParser *firstControlParser = [[PLControlWithAttributeParser alloc] initWithLexer:_lexer];
    [firstControlParser parseReportingFailure];
    if(!firstControlParser.parsedWithSuccess){
        return nil;
    }
    
    [self omitWhiteSpaces];

    PLRelationParser *relationParser = [PLRelationParser parserWithLexer:_lexer];
    [relationParser parseReportingFailure];
    if(!relationParser.parsedWithSuccess){
        return nil;
    }

    [self omitWhiteSpaces];

    // Optional second control
    PLControlWithAttributeParser *secondControl = [[PLControlWithAttributeParser alloc] initWithLexer:_lexer];
    BOOL secondControlParsed = [secondControl parseSuppressingFailure];

    [self omitWhiteSpaces];

    BOOL noLayoutAttributeOnRightSide = !secondControlParsed;

    PLConstantExpressionParser *constantParser = [PLConstantExpressionParser parserWithLexer:_lexer];
    PLMultiplierExpressionParser *multiplierParser = [PLMultiplierExpressionParser parserWithLexer:_lexer];

    if (noLayoutAttributeOnRightSide) {

        constantParser.requireLeadingSignChar = NO;
        [constantParser parseReportingFailure];
        if (!constantParser.parsedWithSuccess) {
            return nil;
        }

    } else {

        [multiplierParser parseSuppressingFailure];
        if (multiplierParser.parsedWithSuccess) {
            multiplier = multiplierParser.multiplierValue;
        } else {
            multiplier = 1.0f;
        }

        [self omitWhiteSpaces];

        constantParser.requireLeadingSignChar = YES;
        [constantParser parseSuppressingFailure];
        if (constantParser.parsedWithSuccess) {
            constant = constantParser.constantValue;
        } else {
            constant = 0.0f;
        }

    }

    [self omitWhiteSpaces];

    // Ensure that it's end of string already
    PLAttributeConstraintVisualFormatAtom *atom = nil;
    NSUInteger initialLexerState = _lexer.currentState;
    atom = [_lexer next];
    if (atom.atomType != PLAtomTypeEndOfInput) {
        [PLVisualFormatErrorLogger logExpectedAtomDescribedByString:@"End of format string" gotAtom:atom inText:_lexer.text onIndex:initialLexerState];
        [_lexer setCurrentState:initialLexerState];
        return nil;
    }

    return [self buildConstraintWithFirstControlAttributeParser:firstControlParser
                                                       relation:relationParser.parsedRelationType
                               secondControlWithAttributeParser:secondControl
                                                     multiplier:multiplier
                                                       constant:constant
                                                          views:views];

}

#pragma mark -

- (void)omitWhiteSpaces {
    [_lexer omitWhiteSpaces];
}

#pragma mark - constraint building


- (NSLayoutConstraint *)buildConstraintWithFirstControlAttributeParser:(PLControlWithAttributeParser *)firstControlParser
                                                              relation:(NSLayoutRelation)relation
                                      secondControlWithAttributeParser:(PLControlWithAttributeParser *)secondControlParser
                                                            multiplier:(CGFloat)multiplier
                                                              constant:(CGFloat)constant
                                                                 views:(NSDictionary *)views {

    NSAssert(firstControlParser.parsedWithSuccess, @"First control has not been parsed successfully.", nil);

    UIView *firstControlObject = [views objectForKey:firstControlParser.controlName];
    NSLayoutAttribute firstControlAttr = [PLConstraintLayoutAttributeMapper attributeFromString:firstControlParser.attributeName];

    if (firstControlObject == nil) {
        NSLog(@"PLAttributeConstraintVisualFormatParser: invalid first control. %@ unknown.", firstControlParser.controlName);
        return nil;
    }

    if (firstControlAttr == NSLayoutAttributeNotAnAttribute) {
        NSLog(@"PLAttributeConstraintVisualFormatParser: invalid first control attribute. %@ unknown.", firstControlParser.attributeName);
        return nil;
    }

    UIView *secondControl = nil;
    NSLayoutAttribute secondControlAttr = NSLayoutAttributeNotAnAttribute;

    if (secondControlParser.parsedWithSuccess) {

        secondControl = [views objectForKey:secondControlParser.controlName];
        secondControlAttr = [PLConstraintLayoutAttributeMapper attributeFromString:secondControlParser.attributeName];

        if (firstControlObject == nil) {
            NSLog(@"PLAttributeConstraintVisualFormatParser: invalid second control. %@ unknown.", secondControlParser.controlName);
            return nil;
        }

        if (firstControlAttr == NSLayoutAttributeNotAnAttribute) {
            NSLog(@"PLAttributeConstraintVisualFormatParser: invalid second control attribute. %@ unknown.", secondControlParser.attributeName);
            return nil;
        }

    }
    else {

        if (firstControlAttr != NSLayoutAttributeWidth && firstControlAttr != NSLayoutAttributeHeight) {

            // HACK:
            //
            // you can create constraint like that: view.width <= 100
            // however, view.top <= 100 is not supported in the same way
            //
            // in first case, you'll pass
            //      nil     NSLayoutAttributeNotAnAttribute
            // as second control and attribute related to that constraint
            //
            // in second case, that approach will result in a crash
            // so basically I create constraint:    view.width <= view.width * 0 + 100
            //
            //   And that works   ;)
            //

            secondControl = firstControlObject;
            secondControlAttr = firstControlAttr;
            multiplier = 0;

        }
    }

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:firstControlObject
                                                                  attribute:firstControlAttr
                                                                  relatedBy:relation
                                                                     toItem:secondControl
                                                                  attribute:secondControlAttr
                                                                 multiplier:multiplier
                                                                   constant:constant];

#if PLAttributeConstraintFormatParserDebuggingLogsEnabled
    NSLog(@"PLAttributeConstraintVisualFormatParser: Constraint was built: %@", constraint);
#endif

    return constraint;

}

@end
