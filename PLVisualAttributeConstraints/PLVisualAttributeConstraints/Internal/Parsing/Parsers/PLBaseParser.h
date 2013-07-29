//
//  Created by Kamil Jaworski on 29.07.2013.
//  kamil.jaworski@gmail.com
//


#import <Foundation/Foundation.h>

@protocol PLAttributeConstraintVisualFormatLexerProtocol;

@interface PLBaseParser : NSObject {
@protected
    __weak id <PLAttributeConstraintVisualFormatLexerProtocol> _lexer;
    BOOL _parsedWithSuccess;
}

@property(readonly, weak) id <PLAttributeConstraintVisualFormatLexerProtocol> lexer;

@property(nonatomic, readonly) BOOL parsedWithSuccess;

+ (id)parserWithLexer:(id <PLAttributeConstraintVisualFormatLexerProtocol>)lexer;
- (id)initWithLexer:(id <PLAttributeConstraintVisualFormatLexerProtocol>)lexer;

- (BOOL)parseSuppressingFailure;
- (BOOL)parseReportingFailure;

// Protected
- (BOOL)__parseReportingErrorOnFailure:(BOOL)reportErrorOnFailure;

@end
