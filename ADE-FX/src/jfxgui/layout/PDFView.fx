
/*
 * PDFView.fx
 *
 * Created on Oct 29, 2008, 8:46:57 PM
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
import com.sun.pdfview.PDFFile;
import com.sun.pdfview.PDFPage;


public class PDFView extends CustomNode {

    public attribute pdfLocation : String on replace {
        reloadPDF();
    };
    private attribute pdf : PDFFile;
    private attribute pdfhelper : PDFImageNode = PDFImageNode {};
    private attribute currentPage : Image;
    private attribute imageView : ImageView;
    public attribute parentWidth : Number = 0 on replace {redrawPDF();};
    public attribute parentHeight : Number = 0 on replace {redrawPDF();};
    private attribute pageCounter = 1 on replace {redrawPDF()}; 
    private attribute maxPages : Number = 0;
    private static attribute BORDER_OFFSET = 20;
    
    public function create(): Node {
        
        imageView = ImageView {
            image: bind currentPage;
        }
        
        
        return imageView;
    }
    
    public function nextPage() {
        if (pageCounter < maxPages) {
            pageCounter++;
        }
    }
    
    public function previousPage() {
        if (pageCounter != 1) pageCounter --;
    }
    
    private function redrawPDF() {
        if (pdf != null) {
            var image = pdfhelper.getPage(pdf,pageCounter); 
        
            if (image.getHeight(null) < image.getWidth(null)) {
                currentPage = Image {
                    bufferedImage:image as java.awt.image.BufferedImage;
                    width: parentWidth - BORDER_OFFSET*2;
                }    
            } else if (image.getHeight(null) > image.getWidth(null)) {
                currentPage = Image {
                        bufferedImage:image as java.awt.image.BufferedImage;
                        height: parentHeight - BORDER_OFFSET*2;
                 }    
            }
            
            imageView.translateY = (parentHeight - currentPage.height) / 2;
            imageView.translateX = BORDER_OFFSET;
        }
    }
    
    private function reloadPDF() {
        if (pdfLocation != null and pdfLocation.length() > 0) {
            pdf = pdfhelper.loadPDF(pdfLocation);
            pageCounter = 1;
            var image = pdfhelper.getPage(pdf,pageCounter); 
            maxPages = pdf.getNumPages();
            
            
        
            if (image.getHeight(null) < image.getWidth(null)) {
                currentPage = Image {
                    bufferedImage:image as java.awt.image.BufferedImage;
                    width: parentWidth - BORDER_OFFSET*2;
                }    
            } else if (image.getHeight(null) > image.getWidth(null)) {
                currentPage = Image {
                        bufferedImage:image as java.awt.image.BufferedImage;
                        height: parentHeight - BORDER_OFFSET*2;
                 }    
            }  
            
             imageView.translateY = (parentHeight - currentPage.height) / 2;
             imageView.translateX = BORDER_OFFSET;
        }
    }
    
}
