import java.io.*;
import java_cup.runtime.*;

public class LexerTest{

    public static void main(String[] args) {
        Symbol sym;
        try {
            Lexer lexer = new Lexer(new FileReader(args[0]));
            System.out.println("\n=======================Start=======================");
            for (sym = lexer.next_token(); sym.sym != 0;
                    sym = lexer.next_token()) {

                System.out.println("Token " + sym.toString() +", with value = " + sym.value + " at line " + sym.left + ", column " + sym.right);

            }
            System.out.println("=========================End=========================\n");
        }
        catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}