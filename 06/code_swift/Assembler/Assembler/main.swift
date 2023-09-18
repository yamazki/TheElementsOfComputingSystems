//
//  main.swift
//  Assembler
//
//  Created by 山崎啓佑 on 2023/08/19.
//

import Foundation



let filePath = "/Users/yamazakikeiyuu/Documents/GitHub/TheElementsOfComputingSystems/06/add/Add.asm";

let parser = Parser.init(filePath: filePath);

while(true) {
    
    if(parser.hasMoreCommnads() == false)
    {
        break;
    }
    
    parser.advance()
    if(parser.currentCommand.hasPrefix("//"))
    {
        continue;
    }
    
    
    let commandType = parser.commandType()
    var symbol:String = "";
    var dest:String = "";
    var comp:String = "";
    var jump:String = "";
    
    switch commandType {
    case .A_COMMAND:
        symbol = parser.symbol()
        print(symbol)
    case .L_COMMAND:
        symbol = parser.symbol()
        print(symbol)
    case .C_COMMNAD:
        dest = Code.dest(mnemonic: parser.dest());
        comp = Code.comp(mnemonic: parser.comp());
        jump = Code.jump(mnemonic: parser.jump());
        print(dest)
        print(comp)
        print(jump)
    }
    
    
    
    
    
    
}

