#    Project #1: 4386 Compiler Design
##   Lexical Analyzer
###  Stuart Small: sjs160530
###  Fall 2020

How to run:
**make run**

How to reset:
**make clean**

##### Add Testcases:

Add test files to  CP/tests dir,
Add statements to makefile with format:<br />
    $(JAVA)	-cp	$(CP)	LexerTest	./tests/FIELNAME.txt	>	./tests/output/FIELNAME-output.txt<br />
	cat	-n	./tests/output/FIELNAME-output.txt<br />


Program         →   class id { Memberdecls }<br />
Memberdecls     →   Fielddecls Methoddecls <br />
Fielddecls      →   Fielddecl Fielddecls | λ <br />
Methoddecls     →   Methoddecl Methoddecls | λ <br />
Fielddecl       →   Optionalfinal Type id Optionalexpr ;<br />
                |   Type id [ intlit ];<br />
Optionalfinal   →   final | λ<br />
Optionalexpr    →   = Expr | λ<br />
Methoddecl      →   Returntype id ( Argdecls ) { Fielddecls Stmts } Optionalsemi<br />
Optionalsemi    →   ; | λ<br />
Returntype      →   Type | void<br />
Type            →   int | char | bool | float<br />
Argdecls        →   ArgdeclList | λ<br />
ArgdeclList     →   Argdecl , ArgdeclList | Argdecl<br />
Argdecl         →   Type id | Type id [ ]<br />
Stmts           →   Stmt Stmts | λ<br />
Stmt            →   if ( Expr ) Stmt OptionalElse | while ( Expr ) Stmt | Name = Expr ;<br />
                |   read ( Readlist ) ; | print ( Printlist ) ; | printline ( Printlinelist ) ;<br />
                |   id ( ) ; | id ( Args ) ; | return ; | return Expr ; | Name ++ | Name --<br />
                |   { Fielddecls Stmts } Optionalsemi<br />
OptionalElse    →   else Stmt | λ<br />
Name            →   id | id [ Expr ]<br />
Args            →   Expr , Args | Expr<br />
Readlist        →   Name , Readlist | Name<br />
Printlist       →   Expr , Printlist | Expr<br />
Printlinelist   →   Printlist | λ<br />
Expr            →   Name | id ( ) | id ( Args ) | intlit | charlit | strlit | floatlit | true | false<br />
                |   ( Expr ) | ~ Expr | - Expr | + Expr | ( Type ) Expr <br />
                |   Expr Binaryop Expr | ( Expr ? Expr : Expr )<br />
Binaryop    →   * | / | + | - | < | > | <= | >= | == | <> | \|\| | &&<br />