
/*
 * EuropeMap.fx
 *
 * Created on Sep 16, 2008, 5:33:18 PM
 */

package weatherfx.nodes;

import weatherfx.resources.*;
import weatherfx.util.geo.MetarUtil;
import weatherfx.util.geo.LocationInfo;
import javafx.animation.*;
import javafx.input.*;
import javafx.input.KeyEvent;
import javafx.scene.*;
import javafx.scene.effect.*;
import javafx.scene.geometry.*;
import javafx.scene.image.*;
import javafx.scene.paint.*;
import javafx.scene.text.*;
import javafx.scene.transform.*;
import java.lang.System;

/**
 * Wrapper around the SVG map. This wrapper adds functionality
 * to the map.
 */
public class EuropeMap extends CustomNode {

    // offset to start the map in the netherlands
    public attribute offsetY : Number = -300;
    public attribute offsetX : Number = -300;
    public attribute zoom : Number = 2.5;
    
    public attribute metarOffsetX : Number = -378;
    public attribute metarOffsetY : Number = 199;
    
    // offsets specifically for this map
    public attribute metarZoomX : Number = 833;
    public attribute metarZoomY : Number = 831;
    public attribute rotates : Number = 4.88;
        
    private attribute borderColor : Color = Color.BLACK;
    private attribute borderSize : Number = 40;
   
    private attribute map : EuropeMapSVG = EuropeMapSVG {};
    private attribute infobar : InfoBar = null;
    
    public attribute metarCodeChanged : function():Void;
    
    public attribute selectedLocation : String = null;
    public attribute showMapBorders : Boolean = true on replace {
    
        
        if (showMapBorders) {
            borderSize = 3;
            borderColor = Color.BLACK;
        } else {
            borderSize = 5;
            borderColor = Color.LIGHTYELLOW;
        }
    }

    // handle the onKeyPressed event
    override attribute onKeyPressed = function ( e: KeyEvent ):Void {
        
        if (e.getKeyCode() == KeyCode.VK_EQUALS) {
            zoom = zoom + 0.01;
        } else if (e.getKeyCode() == KeyCode.VK_MINUS) {
            zoom = zoom - 0.01;
        } else if (e.getKeyCode() == KeyCode.VK_DOWN) {
            offsetY = offsetY - 2;
        } else if (e.getKeyCode() == KeyCode.VK_UP) {
            offsetY = offsetY + 2;
        } else if (e.getKeyCode() == KeyCode.VK_LEFT) {
            offsetX = offsetX + 2;
        } else if (e.getKeyCode() == KeyCode.VK_RIGHT) {
            offsetX = offsetX - 2;
        } else if (e.getKeyCode() == KeyCode.VK_W) {
            metarOffsetY +=1;
        } else if (e.getKeyCode() == KeyCode.VK_S) {
            metarOffsetY -=1;
        } else if (e.getKeyCode() == KeyCode.VK_A) {
            metarOffsetX +=1;
        } else if (e.getKeyCode() == KeyCode.VK_D) {
            metarOffsetX -=1;    
        } else if (e.getKeyCode() == KeyCode.VK_Y) {
            metarZoomY +=1;
        } else if (e.getKeyCode() == KeyCode.VK_H) {
            metarZoomY -=1;    
        } else if (e.getKeyCode() == KeyCode.VK_K) {
            metarZoomX +=1;
        } else if (e.getKeyCode() == KeyCode.VK_L) {
            metarZoomX -=1;    
        } else if (e.getKeyCode() == KeyCode.VK_Z) {
            rotates +=0.1;
        } else if (e.getKeyCode() == KeyCode.VK_X) {
            rotates -=0.1;    
        }
    }
    
     // handles the dragging of the node
     private attribute startX = 0.0;  
     private attribute startY = 0.0;  
   
   
     /**
      * When the mouse is pressed, we note the current position
      */
     override attribute onMousePressed = function(e:MouseEvent):Void {  
         startX = e.getDragX()-offsetX;  
         startY = e.getDragY()-offsetY;  
     }  
   
     /**
      * When the mouse is dragged , we move the offset of the figure
      */
     override attribute onMouseDragged = function(e:MouseEvent):Void {  
         offsetX = e.getDragX()/2-startX;  
         offsetY = e.getDragY()/2-startY;  
     }
     

     /**
      * If the mousewheel is used, we zoom in or out
      */
     override attribute onMouseWheelMoved = function(e:MouseEvent):Void {
         if (e.getButton() == 0) {
             if (e.getWheelRotation() > 0) {
                  zoom = zoom - 0.06;
             } else if (e.getWheelRotation() < 0) {
              zoom = zoom + 0.06;
         }
         }
     }
     
     
   // called when the node is created
    public function create(): Node {
        //  var locations;
        var locations = MetarUtil.processMetarLocations(new java.io.FileInputStream(new java.io.File("stations.txt")));         
        var group = Group {     
            scaleX: bind zoom;
            scaleY: bind zoom;    
            translateY: bind offsetY;
            translateX: bind offsetX;
            content: [
                EuropeMapSVG{
                  borderColor: bind borderColor;
                  borderSize: bind borderSize;
                  
                }
            ];}
    
                              //location.getCountryCode() == "DE" or 
                          //location.getCountryCode() == "FR" or 
                          //location.getCountryCode() == "ES") and            
         for (location in locations  where 
                          (location.getCountryCode() == "NL" or
                          location.getCountryCode() == "NL") and
                          (location.getMetarCode().trim() != "" ))  {
            insert 
             Circle {
                 //scaleX: 0.07
                 //scaleY: 0.07
                 var internalOffsetY : Number = 0;
                 var name = location.getName();
                 var metarCode = location.getMetarCode();
                 rotate: bind rotates;
                 centerX: bind (metarZoomX) * location.getCoordinate().getX() - metarOffsetX;
                 centerY: bind (metarZoomY) * location.getCoordinate().getY() - metarOffsetY;
                 radius: 0.7
                 fill: Color.RED
                 
                 onMouseClicked: function(e:MouseEvent) {
                     selectedLocation = metarCode;
                     metarCodeChanged();
                 }
             } into group.content;
         }
        
        return group;
    }    
    
}
