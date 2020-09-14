JAVA=java
JAVAC=javac
JFLEX=$(JAVA) -jar jflex-1.8.2/lib/jflex-full-1.8.2.jar
CUPJAR=./java-cup-11b.jar
CUP=$(JAVA) -jar $(CUPJAR)
CP=.:$(CUPJAR)

default:	run

.SUFFIXES:	$(SUFFIXES)	.class	.java

.java.class:
	$(JAVAC)	-cp	$(CP)	$*.java	

FILE=		Lexer.java	parser.java	sym.java	\
				LexerTest.java

run:	test

test:	all
	$(JAVA)	-cp	$(CP)	LexerTest	./tests/basicTerminals.txt	>	./tests/output/basicTerminals-output.txt
	cat	-n	./tests/output/basicTerminals-output.txt
	$(JAVA)	-cp	$(CP)	LexerTest	./tests/lexerTest.txt	>	./tests/output/lexTest-output.txt
	cat	-n	./tests/output/lexTest-output.txt
	$(JAVA)	-cp	$(CP)	LexerTest	./tests/basicFails.txt	>	./tests/output/basicFails-output.txt
	cat	-n	./tests/output/basicFails-output.txt
	$(JAVA)	-cp	$(CP)	LexerTest	./tests/basicRegex.txt	>	./tests/output/basicRegex-output.txt
	cat	-n	./tests/output/basicRegex-output.txt

all:	Lexer.java	parser.java	$(FILE:java=class)

clean:
	rm	-f	*.class *~ *.bak Lexer.java parser.java sym.java	./tests/output/lexTest-output.txt	./tests/output/basicFails-output.txt	./tests/output/basicRegex-output.txt	./tests/output/basicTerminals-output.txt

Lexer.java:	grammar.jflex
	$(JFLEX)	grammar.jflex

parser.java:	tokens.cup
	$(CUP) -interface < tokens.cup

parserD.java:	tokens.cup
	$(CUP)	-interface -dump < tokens.cup
