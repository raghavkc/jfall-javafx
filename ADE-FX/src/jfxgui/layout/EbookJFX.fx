package jfxgui.layout;

import javafx.application.Frame;
import java.awt.Window;
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
import javafx.animation.*;
import javafx.input.*;
import javafx.scene.*;
import javafx.scene.effect.*;
import javafx.scene.geometry.*;
import javafx.scene.image.*;
import javafx.scene.paint.*;
import javafx.scene.text.*;
import javafx.scene.layout.*;
import javafx.scene.transform.*;

public class EbookJFX extends CustomNode {
     
    public attribute window : Window; 
    public attribute selectedPDF : String;
    private attribute overviewPage : GridBox;
    public attribute pdfViewPage : PDFView = PDFView {
        parentWidth : bind width;
        parentHeight : bind height;
    };

    private attribute resultGroup : Group = Group {
    };
    public attribute width : Integer = 500;
    public attribute height : Integer = 500;
    
    
     
    public function create(): Node {

        //requestFocus();
        setupOverviewPage();
        setupPdfViewPage();
        resultGroup.content = [overviewPage];
        
        return resultGroup;
    }
    
    private function setupPdfViewPage() {
        pdfViewPage.onMouseClicked = function(e:MouseEvent) {
            
            if (e.getButton() == 1 and e.getClickCount() == 2) {
                resultGroup.content = [overviewPage];   
            }
        };
    }
    
    /**
     * This function fills the gridbox with a set of images and adds
     * mouse logica to these images.
     */
    private function setupOverviewPage() {

        var pdfhelper = new PDFImageNode();
        var pdfs = pdfhelper.getAllPdfs("/home/nl24167/Desktop/javafx/test");
        
        overviewPage = GridBox {
            translateX : 10;
            translateY : 10;
            parentWidth : bind width;
            content: 
                for (pdf in pdfs) {
                    var gridNode : GridBoxNode = GridBoxNode {
                        pdflocation: pdf.location;
                        // setup the actions when clicked on the mouse
                        onMouseClicked : function(e:MouseEvent) {
                            if (e.getButton() == 3) {
                                delete gridNode from overviewPage.content;
                            } else if (e.getButton() == 1 and e.getClickCount() == 2) {
                                pdfViewPage.pdfLocation = gridNode.pdflocation;
                                selectedPDF = gridNode.pdflocation;
                                resultGroup.content = [pdfViewPage]                               
                            }
                        };
                        // setup the image which is shown
                        node : VBox {
                            content : [
                                ImageView {
                                    image: Image {
                                        bufferedImage : pdf.image
                                        height: 100
                                    }
                                }
                                ,
                                Text {
                                    font: Font { 
                                        size: 12
                                        name: "Arial"
                                        style: FontStyle.ITALIC
                                    }
                                    x: 0, y: 15
                                    fill: Color.WHITE
                                    smooth: true
                                    content: pdf.name
                                }
                            ]

                        }
                        
                    }
                 // the gridNode is added to the content   
                 gridNode;
                }   
        };
    }
}
