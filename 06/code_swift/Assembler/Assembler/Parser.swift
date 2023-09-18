//
//  Parser.swift
//  Assembler
//
//  Created by 山崎啓佑 on 2023/08/19.
//

import Foundation


class Parser {
    
    enum commandTypes {
        case A_COMMAND
        case C_COMMNAD
        case L_COMMAND
    }
    
    
    var commands:Array<String>;
    var currentCommand:String = "";
    var currentCommandNumber:Int = 0; // 0? 1? どっちかはコーディングを進めてから決める。
    
    static let symbolPattern = "[0-9][0-9a-zA-Z_.$:]*";
    static let dest = "(null|[ADM]|AM|MD|AD|AMD)?";
    static let jump = "(null|JGT|JEQ|JGE|JLT|JNE|JLE|JMP)?";
    static let comp = "(-|!)?(0|1|1|A|D|M)(\\+|-|&|\\|)?(1|-1|A|D|M)?"
    
    static let A_COMMNAD_PATTERN = "@" + symbolPattern;
    static let C_COMMNAD_PATTERN = dest + "=?" + comp + ";?" + jump;
    static let L_COMMNAD_PATTERN = "\\(" + symbolPattern + "\\)";
    
    
    init(filePath:String) {
        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
            self.commands = fileContents.split(whereSeparator: \.isNewline).map{String($0)};
        } catch let error as NSError{
            fatalError("ファイル読み込み失敗 " + error.debugDescription);
        }
    }
    
    func hasMoreCommnads() -> Bool {
        return commands.count != self.currentCommandNumber
    }
    
    func advance() -> Void {
        currentCommand = commands[currentCommandNumber];
        currentCommandNumber += 1;
    }
    
    func commandType() -> commandTypes {
        
        var regex = try! NSRegularExpression(pattern: Parser.A_COMMNAD_PATTERN, options: [])
        var match = regex.firstMatch(in: self.currentCommand, range: NSRange(0..<self.currentCommand.count))
        if(match != nil)
        {
            return Parser.commandTypes.A_COMMAND
        }
        
        regex = try! NSRegularExpression(pattern: Parser.C_COMMNAD_PATTERN, options: [])
        match = regex.firstMatch(in: self.currentCommand, range: NSRange(0..<self.currentCommand.count))
        if(match != nil)
        {
            return Parser.commandTypes.C_COMMNAD
        }

        regex = try! NSRegularExpression(pattern: Parser.L_COMMNAD_PATTERN, options: [])
        match = regex.firstMatch(in: self.currentCommand, range: NSRange(0..<self.currentCommand.count))

        if(match != nil)
        {
            return Parser.commandTypes.L_COMMAND
        }
        
        fatalError("構文解析に失敗しました。 コマンドの形式が不正です。" + currentCommand )

    }
    
    func symbol() -> String {
                
        if(self.currentCommand.hasPrefix("@"))
        {
            return self.currentCommand.replacingOccurrences(of: "@", with: "");
        }
        
        if(self.currentCommand.hasPrefix("("))
        {
            return self.currentCommand.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: "(", with: "");
        }
        
        fatalError("構文解析に失敗しました。 シンボルの形式が不正です。" + currentCommand )
    }
    
    func dest() -> String {
        // =が存在する -> destが存在する。
        if let destLocation = self.currentCommand.range(of: "=")
        {
            return String(self.currentCommand[..<destLocation.lowerBound])
        }
        // =が存在しない -> destが存在しない。
        return "";
    }
    
    func comp() -> String {

        var compString = "";
        // =とそれ以前の文字を削除
        if let destLocation = self.currentCommand.range(of: "=")
        {
            compString = String(self.currentCommand[destLocation.upperBound...])
        }
        
        // ;とそれ以降の文字を削除
        if let jumpLocation = self.currentCommand.range(of: ";")
        {
            compString = String(self.currentCommand[..<jumpLocation.lowerBound])
        }
        return compString;

    }
    
    func jump() -> String {
        
        if let jumpLocation = self.currentCommand.range(of: ";")
        {
            return String(self.currentCommand[jumpLocation.upperBound...])
        }

        return "";

    }
    
    
}
