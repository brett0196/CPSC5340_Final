//
//  ViewModel.swift
//  CPSC_5340_Final_Tic_Tac_Toe
//
//  Created by Brett Williams on 4/22/23.
//

import SwiftUI

class ViewModel:ObservableObject{
    //Sets the game difficulty.
    @Published var hard = true;
    //Win Counter, AppStorage allows for the count to be saved.
    @AppStorage("winCount") var winCount = 0;
    //When modified the view is reloaded and pops the alert.
    @Published var gameOver: finished?
    //Array of 9 spots, initialized to nil.
    @Published var turns: [Turn?] = Array(repeating:nil,count:9)
    
    //Resets the game upon selection.
    func reset() -> (Void){
        turns = Array(repeating:nil,count:9);
    }
    
    //Checks for draws.
    func draw(in turns: [Turn?]) -> (Bool){
        //compactMap removes nils, so if the length is still 9, no nils remain, meaning no turns remain.
        if turns.compactMap({$0}).count == 9{
            return true;
        }
        return false;
    }
    
    func win(for user: Player, in turns: [Turn?]) -> (Bool){
        //Uses sets, similar to a 2D array but less concerned with the order. Also has some useful functions for this use.
        let combos: Set<Set<Int>> = [[0,1,2], [2,5,8], [8,7,6], [0,3,6], [0,4,8], [6,4,2], [3,4,5], [1,4,7]];
        //Turns userTurns into all non-nill spots in User.
        let userTurns = turns.compactMap({$0}).filter({$0.user == user})
        //Maps userTurns to compare to the winning combos.
        let spots = Set(userTurns.map({$0.spot}))
        //If the same subset exists in both combos and spots, returns true.
        for wins in combos where wins.isSubset(of: spots){
            return true;
        }
        //Otherwise returns false if nothing is found.
        return false;
    }
    
    func pcMove(in turns: [Turn?]) -> (Int){
        //Hard Mode. PC will attempt to use some strategy.
        if(hard){
            //Checks for PC win conditions like in the Win() method but matching 2 out of 3 instead.
            //Uses sets, similar to a 2D array but less concerned with the order. Also has some useful functions for this use.
            let combos: Set<Set<Int>> = [[0,1,2], [2,5,8], [8,7,6], [0,3,6], [0,4,8], [6,4,2], [3,4,5], [1,4,7]];
            let pcTurns = turns.compactMap({$0}).filter({$0.user == .pc})
            let spots = Set(pcTurns.map({$0.spot}))
            
            //Checking for any combinations from combos that only need a single number to match the set and win.
            for combo in combos{
                let futureView = combo.subtracting(spots)
                if futureView.count == 1{
                    let valid = validTurn(in: turns, forIndex: futureView.first!)
                    if(!valid) {return futureView.first!}
                }
            }
            
            //Does exactly as above, but checking for human wins to stop them.
            let userTurns = turns.compactMap({$0}).filter({$0.user == .user})
            let spots2 = Set(userTurns.map({$0.spot}))
            
            for combo in combos{
                let futureView = combo.subtracting(spots2)
                if futureView.count == 1{
                    let valid = validTurn(in: turns, forIndex: futureView.first!)
                    if(!valid) {return futureView.first!}
                }
            }
        }
        //Normal. PC is just random.
        var move = Int.random(in: 0..<9)
        while validTurn(in: turns, forIndex: move){
            move = Int.random(in: 0..<9)
        }
        return move
    }
    
    func validTurn(in turns: [Turn?], forIndex i: Int) -> (Bool){
        return turns.contains(where: {$0?.spot == i})
    }
    
    func round(for i: Int){
        //User turn
        if validTurn(in: turns, forIndex: i){
            return;
        }
        turns[i] = Turn(user: .user , spot: i);
        if(win(for: .user,in: turns)){
            gameOver = completion.userWin;
            winCount += 1;
            return;
        }
        if(draw(in:turns)){
            gameOver = completion.userDraw;
            return;
        }
        //PC turn
        let spot = pcMove(in: turns);
        turns[spot] = Turn(user: .pc , spot: spot);
        if(win(for: .pc,in: turns)){
            gameOver = completion.userLose;
            return;
        }
        if(draw(in:turns)){
            gameOver = completion.userDraw;
            return;
        }
    }
    
    struct Turn{
        let user: Player
        let spot: Int
        var team: String{
            if(user == .pc){
                return "xmark"
            }
            else{
                return "circle"
            }
        }
    }

}

