/*
 * Main.fx
 *
 * Created on Nov 11, 2008, 9:10:59 PM
 */

package adefx;

/**
 * @author nl24167
 */

// place your code here
import javafx.application.Frame;
import javafx.application.Stage;
import jfxgui.layout.*;
import javafx.scene.geometry.Circle;
import javafx.scene.paint.Color;
import javafx.input.MouseEvent;
import java.lang.System;
import javafx.application.WindowStyle;
import javafx.scene.image.ImageView;
import javafx.scene.image.Image;
import javafx.scene.geometry.Rectangle;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.input.*;
import javafx.scene.geometry.Line;
import javafx.scene.VerticalAlignment;

var isMaxScreen : Boolean = false;

var frame : Frame = Frame {
    windowStyle: WindowStyle.UNDECORATED
    title: "JavaFX PDFViewer"
    width: 800,  height: 550
    closeAction: function() { 
        java.lang.System.exit( 0 ); 
    }
    visible: true
    resizable: true    
    opacity: 0.8
    
    var ebookJFX : EbookJFX = EbookJFX {
                        width : bind stage.width - 130 as Integer;
                        height: bind stage.height; 
                        window: bind frame.window;
    }
       
    var vbox : VBox = VBox {
        content: [     CategoryNode {
                                  name : "All"
                              },
                              CategoryNode {
                                  name : "JavaOne"
                              },
                              CategoryNode {
                                  name : "Technical"
                              },
                              CategoryNode {
                                  name : "Literature"
                              },
                              CategoryNode {
                                  name : "Other"
                              }]
    };
    
    var detail :  DetailNode = DetailNode{
                                  width: 100
                                  pdf : bind ebookJFX.selectedPDF;
                              }

    var fillupbox : Rectangle = Rectangle {
                                width: 110, 
                                height: bind stage.height - vbox.getBoundsHeight() -  detail.getBoundsHeight() -25,
                                fill: Color.BLACK
                                }
                                
    var seperatorLine : Line = Line {
                                  startX: 10, startY: 10
                                  endX: 10, endY: bind stage.height -10
                                  strokeWidth: 2
                                  stroke: Color.WHITE
                                  opacity: 0.5
                              };
                              
    var leftVBox : VBox = VBox {
                          spacing: 3
                          content: [
                              detail
                              ,fillupbox,
                              Line {
                                  startX: 10, startY: 0
                                  endX: 110, endY: 0
                                  strokeWidth: 2
                                  stroke: Color.WHITE
                                  opacity: 0.5
                              }
                              ,
                              vbox
                          ]

                      } 
       
    var stage : Stage = Stage {
        var hbox : HBox = HBox {
            onKeyPressed : function(e:KeyEvent) {
            if (e.getKeyCode() == KeyCode.VK_RIGHT) {
                ebookJFX.pdfViewPage.nextPage();
            } else if (e.getKeyCode() == KeyCode.VK_LEFT) {
                ebookJFX.pdfViewPage.previousPage();
            } else if (e.getKeyCode() == 40) {
                // switch between max screen
                if (not isMaxScreen) {
                  java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment ().getDefaultScreenDevice().setFullScreenWindow (frame.window);    
                  isMaxScreen = true;
                  delete hbox.content[1];
                  delete hbox.content[0];
                } else {
                  java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment ().getDefaultScreenDevice().setFullScreenWindow (null);    
                  isMaxScreen = false;             
                  insert seperatorLine before hbox.content[0];
                  insert leftVBox before hbox.content[0];
                }
            }
        };
                spacing: 10
                content: [ 
                      leftVBox,seperatorLine,ebookJFX
                ]
            }
            
        fill: Color.BLACK
        content: [
            hbox,            
            Rectangle {
                // TODO: Should start an animation here
                onMouseDragged: function (e: MouseEvent) {

                    if(
                    frame.width + e.getDragX() > 0) {
                        frame.width += 
                        e.getDragX() / 8 as Integer;
                    }

                    if(frame.height + e.getDragY() > 0) {
                        frame.height += 
                        e.getDragY() / 8 as Integer;
                    }
                }
                width: 10, height: 10
                x: bind stage.width - 10;
                y: bind stage.height - 10; 
                
                fill: Color.WHITE
                opacity: 0.5
            }
        ]
    }   
    
    
    stage : stage;
    
}