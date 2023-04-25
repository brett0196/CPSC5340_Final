//
//  Finished.swift
//  CPSC_5340_Final_Tic_Tac_Toe
//
//  Created by Brett Williams on 4/21/23.
//

import SwiftUI

//Is Identifiable to allow for alerts.
struct finished: Identifiable{
    let id = UUID();
    var info: Text;
}

struct completion{
    //Had to set all of these to static to allow gameOver to be modified?
    static let userDraw = finished(info: Text("It's a draw!"));
    static let userLose = finished(info: Text("X's Win!"));
    static let userWin = finished(info: Text("O's Win!"))
}


enum Player{
    case user, pc
}
