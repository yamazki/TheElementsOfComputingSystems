// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

// 白色に塗りつぶす変数whiteを定義
@0
D=A
@white
M=D

// 黒色に塗りつぶす用の変数blackを定義
@0
D=!A
@black
M=D

@SCREEN
D=A

// SCREENの最初の番地を定義(@SCREENと同じ値)
@start
M=D

// SCREENの最後の番地を定義(@SCREEN+8192)
@8192
D=D+A
@last
M=D

// 最初の番地をDに格納
(END)
    @start
    D=M
    @i
    M=D
    
    @24576
    D=M
    @BLACKLOOP
    D;JEQ

    @24576
    D=M
    @WHITELOOP
    D;JMP

    @END
    0;JMP

(BLACKLOOP)
    // Dレジスタに保存されているiの値を取り出す。
    @i
    D=M

    // iの値から、ループをするかの判定を行う。
    @last
    D=M-D
    D=D-1
    @END
    D;JLT

    // 対象のアドレスをBlackの値で塗りつぶす
    @black
    D=M    
    @i
    A=M
    M=D

    // iに1を加算する。
    @i
    D=M
    D=D+1
    M=D
    @BLACKLOOP
    D;JMP


(WHITELOOP)
    // Dレジスタに保存されているiの値を取り出す。
    @i
    D=M

    // iの値から、ループをするかの判定を行う。
    @last
    D=M-D
    D=D-1
    @END
    D;JLT

    // 対象のアドレスをBlackの値で塗りつぶす
    @white
    D=M    
    @i
    A=M
    M=D

    // iに1を加算する。
    @i
    D=M
    D=D+1
    M=D
    @WHITELOOP
    D;JMP

