//
//  SecondViewController-Design.swift
//  inviti
//
//  Created by Gop on 10/20/2560 BE.
//  Copyright © 2560 gopGorppol. All rights reserved.
//

import Foundation
import UIKit

extension SecondViewController {
    
    func initiationDesign(){
        
        sideTab.layer.cornerRadius = 15;
        sideTab.layer.masksToBounds = true;
        
        mainTableView.layer.cornerRadius = 15;
        mainTableView.layer.masksToBounds = true;
        
        setDetailViewOrigin(x: 32, y: 233)
        
        sideTab.frame.origin.x = CGFloat(sideTabOrigin)
        sideTab.frame.origin.y = 140
        
        myBoardNotifBarView.frame.origin.x = 15
        myBoardNotifBarView.frame.origin.y = 60
        myBoardNotifView.layer.cornerRadius = 15
        myBoardNotifView.layer.masksToBounds = true;

        
        
        probabilityView.frame.origin.x = 9
        probabilityView.frame.origin.y =  253
        
    }
    
    @IBAction func buttonPlus(_ sender: UIButton) {
        
        if (onOff == true){
            UIView.animate(withDuration: 0.5){
                
                self.sideTab.frame.origin.x = 0
                
                self.onOff = false
                
            }
        }else{
            
            UIView.animate(withDuration: 0.5){
                
                self.sideTab.frame.origin.x = CGFloat(self.sideTabOrigin)
                
                self.onOff = true
                
                
            }
        }
        
    }


    @IBAction func notificationButton(_ sender: UIButton) {
        

            UIView.animate(withDuration: 0.35){
                
                self.myBoardNotifBarView.frame.origin.x = 200

                self.mainTableView.frame.origin.x = -375
                
                self.sideTab.frame.origin.x = 0
                
                self.onOff = false
                
            
        }
        
        
    }
    
   
    
    
    @IBAction func myBoardButton(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.35){
            
            self.myBoardNotifBarView.frame.origin.x = 15
            
            self.sideTab.frame.origin.x = 375
            
            self.mainTableView.frame.origin.x = 0
            
            self.onOff = false
            
            
        }
        

        
        
        
        
    }
    






}
