/*
 * GridBoxNode.fx
 *
 * Created on Oct 27, 2008, 9:51:36 PM
 */

package jfxgui.layout;

import javafx.animation.*;
import javafx.input.*;
import javafx.scene.*;
import javafx.scene.effect.*;
import javafx.scene.geometry.*;
import javafx.scene.image.*;
import javafx.scene.paint.*;
import javafx.scene.text.*;
import javafx.scene.transform.*;

/**
 * @author nl24167
 */

public class GridBoxNode extends CustomNode {

    public attribute pdflocation : String;
    public attribute node:Node;
    public attribute point:Point;
    public attribute siblings:Number;
    public attribute timeline : Timeline;  
    public attribute gridBoxManaged : Boolean = true;
    public attribute isDragging :  Boolean = false;
    public attribute dragXStart : Integer;
    public attribute dragYStart : Integer;
    
    public function create(): Node {
        
        node.onMouseReleased = function (e:MouseEvent) {
            if (isDragging) {
                // now we need to insert the node in it's closet
                // position
                gridBoxManaged = true;
                isDragging = false;
                node.opacity = 1.0;
                
                var gridbox = parent as GridBox;
                gridbox.insertNearest(this);
                point.x = impl_layoutX as Integer;
                point.y = impl_layoutY as Integer;
                gridbox.impl_requestLayout();
            }
            
        }
        
        node.onMouseDragged = function (e:MouseEvent) {
            
            if (not isDragging) {
                node.opacity = 0.3;
                dragXStart = impl_layoutX as Integer  ;
                dragYStart = impl_layoutY as Integer;
                isDragging = true;
                gridBoxManaged = false;
                // TODO: move to last in gridbox to make sure it's rendered
                // on top
                impl_layoutX = dragXStart + e.getDragX();
                impl_layoutY = dragYStart + e.getDragY();
                var gridbox = parent as GridBox;
                gridbox.impl_requestLayout();
            } else {
                
                impl_layoutX = dragXStart + e.getDragX();
                impl_layoutY = dragYStart + e.getDragY();
            }
        }
        return node;
    }
}
