//
//  ContentView.swift
//  CPSC_5340_Final_Tic_Tac_Toe
//
//  Created by Brett Williams on 4/20/23.
//

import SwiftUI

struct ContentView: View {
    //Allows access to the ViewModel class.
    @StateObject private var viewModel = ViewModel();
    
    var body: some View {
        //Found this GeometryReader structure on "HackingWithSwift", good for making the app look right on other devices.
        GeometryReader{
            geometry in
            VStack{
                Text("Total Wins: \(viewModel.winCount)")
                    .padding()
                    .font(.system(size:30))
                    .bold()
                Spacer()
                HStack{
                    Text("Hard Mode: ");
                    Toggle("", isOn: $viewModel.hard);
                }.frame(width:geometry.size.width*0.55);
                Spacer()
                LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]){
                    ForEach(0..<9){
                        i in
                        ZStack{
                            Rectangle()
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.18)
                                .background(Color.white)
                            Image(systemName: viewModel.turns[i]?.team ?? "")
                                .resizable()
                                .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.16)
                                .foregroundColor(.blue)
                        }
                        .onTapGesture{
                            viewModel.round(for: i)}
                    }
                }
            }
            Spacer()
        }
        .padding()
        .alert(item: $viewModel.gameOver, content: { gameOver in
            Alert(title: gameOver.info, dismissButton: .default(Text("Play again?"), action: {viewModel.reset()}))
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
