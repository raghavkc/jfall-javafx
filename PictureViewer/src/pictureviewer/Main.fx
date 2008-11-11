/*
 * Main.fx
 *
 * Created on Aug 10, 2008, 1:29:27 PM
 */

package pictureviewer;

import javafx.application.Application;
import javafx.application.Stage;
import javafx.scene.image.ImageView;
import javafx.application.Frame;
import javafx.scene.layout.HBox;
import javafx.application.WindowStyle;

import pictureviewer.nodes.PhotoNode;
import pictureviewer.nodes.ThumbnailRow;
import javafx.scene.geometry.Circle;
import javafx.scene.paint.Color;
import javafx.scene.image.Image;
import javafx.input.MouseEvent;

/**
 * @author nl24167
 */


var frameWidth : Integer = 605;
var frameHeight : Integer = 313;

//var distanceFromTop : Number = 5;
//var distanceFromBottom : Number = 5;

//var img = Image { url : "file:///home/nl24167/NetBeansProjects/PictureViewer/resources/images/image.jpg" };

var application = PictureViewer {}; 
   
var f = Frame {
    
    windowStyle:WindowStyle.UNDECORATED;
    //windowStyle:WindowStyle.
    
    stage : Stage {
        content : [
            application
        ]
    }
    
    visible : true
    title : "Simple pictureviewer"
    width : frameWidth
    height : frameHeight
    closeAction : function() { 
        java.lang.System.exit( 0 );
    } 
}