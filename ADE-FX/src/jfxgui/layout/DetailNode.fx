/*
 * DetailNode.fx
 *
 * Created on Oct 30, 2008, 8:04:37 PM
 */

package jfxgui.layout;

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
import javafx.animation.*;
import javafx.input.*;
import javafx.scene.*;
import javafx.scene.effect.*;
import javafx.scene.geometry.*;
import javafx.scene.image.*;
import javafx.scene.paint.*;
import javafx.scene.text.*;
import javafx.scene.transform.*;
import javafx.scene.layout.VBox;

/**
 * @author nl24167
 */

public class DetailNode extends CustomNode {
    
    public attribute width : Number;
    public attribute pdf : String on replace {
        loadPDF();
    }; 
    
    private attribute image : ImageView;

    private function loadPDF() {
        if (pdf != null) {
         var pdfhelper = new PDFImageNode();
         var file : java.io.File = new java.io.File(pdf);
         
         var replacement : Image = Image {
            bufferedImage : pdfhelper.getImage(file) as java.awt.image.BufferedImage; 
            width : 100;
         }
         
         image.image = replacement;
 
        }
        
        image.effect = Reflection {}

    }
    
    
    public function create(): Node {
        
        image = ImageView {
                    translateX: 10
                    image: Image {
                        url: "file:/home/nl24167/Desktop/javafx/resources/600px-No_image_available.svg.png"
                        width : 90
                    }
                };
        
        var box : VBox = VBox {
            
            spacing: 10
            content: [
                Text {
                    font: Font { 
                        size: 14 
                        name: "Arial"
                        style: FontStyle.BOLD_ITALIC
                    }
                    x: 16, y: 15
                    fill: Color.WHITE
                    smooth: true
                    content: "last read"
                },image
            ]
        };

        
        return box;
    }
}
