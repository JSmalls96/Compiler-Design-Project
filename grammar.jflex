import java_cup.runtime.*;

%%

%cup
%line
%column
%unicode
%class Lexer
%{
    StringBuilder string = new StringBuilder();
    /**
    * Return a new Symbol with the given token id, and with the current line and
    * column numbers.
    */
    Symbol newSym(int tokenId) {
        return new Symbol(tokenId, yyline, yycolumn);
    }

    /**
    * Return a new Symbol with the given token id, the current line and column
    * numbers, and the given token value.  The value is used for tokens such as
    * identifiers and numbers.
    */
    Symbol newSym(int tokenId, Object value) {
        return new Symbol(tokenId, yyline, yycolumn, value);
    }

%}

// regex for carriage return or line feed (newline)
// lineTerminator
lineTerminator = \r|\n|\r\n

// all characters that are not carriage return or line feed
//inputCharacter
inputCharacter = [^\r\n]

digit = [0-9]
nonZeroDigit = [1-9]
letter  = [A-Za-z]

// an identifier has a leading letter followed by zero or more letters or digits
id = {letter}({letter}|{digit})*
// id =  [:jletter:][:jletterdigit:]*

// an integer literal has a digit followed by zero or more digits
intlit = 0 | ({nonZeroDigit}{digit}*)

/*
a character literal begins with a ', and is followed by a single character desciption and then terminated by a '
a single character description can be any legal character other than ' or \, to signify those characters they should 
begin with a \ as in '\" or '\\', some special characters include '\t' (tab character), '\n' (newline character)
*/
charlit = [^\r\n\'\\]

/*  a floating point literal consists of one or more digits, followed by a decimal point (.) followed by one or more digits */
floatlit = (0|{nonZeroDigit}{digit}*)\.({digit}{digit}*)

/*
a string literal begins with a ", is followed by zero or more string characters and ends with a ", the string characters 
cannot include a newline character, a tab character, a backslash character or a double quote directly, these must be signified 
using \ (as in \n for newline, \t for tab character, \\ for backslash, and \"), so "ab\tcd\n\"" is a string consisting of
an a, b, tab character, c, d, newline character and a double quote character.
*/
// strlit = [^\"\\\n\r] | {escChar}
strlit = [^\r\n\"\\] 

/*
whitespace includes space, newline, return and tab characters
*/
whitespace = [ \n\r\t]+

/*
comments are included as follows:
  on any line the characters \\ start a comment that is ended at the end of that line
  \* opens a comment that continues until the first occurrrence of *\
traditionalComment is the expression that matches the string / * followed by a character that is not a *,
followed by anything that does not contain, but ends in * /. As this would not match comments like / **** /,
we add / * followed by an arbitrary number (at least one) of * followed by the closing /. This is not
the only, but one of the simpler expressions matching non-nesting Java comments. It is tempting to just 
write something like the expression / * . * * /, but this would match more than we want. It would for instance
match the entire input / * * / x = 0; / * * /, instead of two comments and four real tokens. See the macros
DocumentationComment and CommentContent for an alternative.
*/
traditionalComment = "\\*" [^*] ~"*\\" | "\\*" "*"+ "\\"
endOfLineComment = "\\" {inputCharacter}* {lineTerminator}?
documentationComment = "\\*" "*"+ [^/*] ~"*\\"

comment = {traditionalComment} | {endOfLineComment} | {documentationComment}

%state STRING, CHARLITERAL

%%

//Lexeme Rules
<YYINITIAL>{
  /* keywords */
  "char"                         { return newSym(sym.CHAR, "char"); }
  "class"                        { return newSym(sym.CLASS, "class"); }
  "else"                         { return newSym(sym.ELSE, "else"); }
  "final"                        { return newSym(sym.FINAL, "final"); }
  "float"                        { return newSym(sym.FLOAT, "float"); }
  "for"                          { return newSym(sym.FOR, "for"); }
  "int"                          { return newSym(sym.INT, "int"); }
  "if"                           { return newSym(sym.IF, "if"); }
  "return"                       { return newSym(sym.RETURN, "return"); }
  "void"                         { return newSym(sym.VOID, "void"); }
  "while"                        { return newSym(sym.WHILE, "while"); }
  "printline"                    { return newSym(sym.PRINTLINE, "printline");}

  /* boolean literals */
  "true"                         { return newSym(sym.BOOLEANLIT, "true"); }
  "false"                        { return newSym(sym.BOOLEANLIT, "false"); }

  /* null literal */
  "null"                         { return newSym(sym.NULL_LIT, "null"); }


  /* separators */
  "("                            { return newSym(sym.LPAREN, "("); }
  ")"                            { return newSym(sym.RPAREN, ")"); }
  "{"                            { return newSym(sym.LBRACE, "{"); }
  "}"                            { return newSym(sym.RBRACE, "}"); }
  "["                            { return newSym(sym.LBRACK, "["); }
  "]"                            { return newSym(sym.RBRACK, "]"); }
  ";"                            { return newSym(sym.SEMICOLON, ";"); }
  ","                            { return newSym(sym.COMMA, ","); }

  /* operators */
  "="                            { return newSym(sym.EQ, "="); }
  ">"                            { return newSym(sym.GT, ">"); }
  "<"                            { return newSym(sym.LT, "<"); }
  "~"                            { return newSym(sym.COMP,"~"); }
  "?"                            { return newSym(sym.QUESTION, "?"); }
  ":"                            { return newSym(sym.COLON, ":"); }
  "=="                           { return newSym(sym.EQEQ, "=="); }
  "<="                           { return newSym(sym.LTEQ, "<="); }
  ">="                           { return newSym(sym.GTEQ, ">="); }
  "&&"                           { return newSym(sym.ANDAND, "&&"); }
  "||"                           { return newSym(sym.OROR, "||"); }
  "++"                           { return newSym(sym.PLUSPLUS, "++"); }
  "--"                           { return newSym(sym.MINUSMINUS, "--"); }
  "+"                            { return newSym(sym.PLUS,"+"); }
  "-"                            { return newSym(sym.MINUS, "-"); }
  "*"                            { return newSym(sym.MULT, "*"); }
  "/"                            { return newSym(sym.DIV, "/"); }
  "&"                            { return newSym(sym.AND, "&"); }
  "|"                            { return newSym(sym.OR, "|"); }


  /* identifiers */ 
  {id}                           { return newSym(sym.ID, yytext()); }  

  {intlit}                       { return newSym(sym.INTLIT, Integer.valueOf(yytext())); }
  {floatlit}                     { return newSym(sym.FLOATLIT, new Float(yytext().substring(0,yylength()))); }

  /* string literal */
  // \"{strlit}*\"                  { return newSym( sym.STRLIT ); }
  // trigger STRING action and clear string array
  \"                             {yybegin(STRING); string.setLength(0);}

  /* character literal */
  // \'{charlit}\'                  { return newSym( sym.CHARLIT ); }
  \'                             {yybegin(CHARLITERAL);}


  /* comments */
  {comment}                      { /* ignore */ }
  // "//"{inputChar}*               { /* ignore */ }
  // "/*"~"*/"                      { /* ignore */ }
  /* whitespace */
  {whitespace}                   { /* ignore */ }

}

<STRING>{
  /* 
    if the scanner comes across double quote in state YYINITIAL
  */
  \"                             {yybegin(YYINITIAL); return newSym(sym.STRLIT, string.toString());}

  {strlit}+             { string.append( yytext() ); }
  // escape sequences
  "\\t"                          {string.append("\t");}
  "\\n"                          {string.append("\n");}
  "\\\""                         { string.append( '\"' ); }
  "\\\\"                         { string.append( '\\' ); }

  /* error cases */
  \\.                            { throw new RuntimeException("Illegal escape sequence \""+yytext()+"\""); }
  {lineTerminator}               { throw new RuntimeException("Unterminated string at end of line"); }
}

<CHARLITERAL>{
  {charlit}\'                    {yybegin(YYINITIAL); return newSym(sym.CHARLIT, yytext().charAt(0));}

  // escape sequence
  "\\t"\'                        { yybegin(YYINITIAL); return newSym(sym.CHARLIT, '\t');}
  "\\n"\'                        { yybegin(YYINITIAL); return newSym(sym.CHARLIT, '\n');}
  "\\\""\'                       { yybegin(YYINITIAL); return newSym(sym.CHARLIT, '\"');}
  "\\'"\'                        { yybegin(YYINITIAL); return newSym(sym.CHARLIT, '\'');}
  "\\\\"\'                       { yybegin(YYINITIAL); return newSym(sym.CHARLIT, '\\'); }


    /* error cases */
  \\.                            { throw new RuntimeException("Illegal escape sequence \""+yytext()+"\""); }
  {lineTerminator}               { throw new RuntimeException("Unterminated character literal at end of line"); }
}

.                  { System.out.println("Illegal char, '" + yytext() +"' line: " + yyline + ", column: " + yychar); } 