package jfxgui.layout;

import javafx.scene.Group;
import java.lang.System;
import java.util.HashMap;
import java.util.ArrayList;
import java.awt.geom.Point2D;
import javafx.animation.*;
import javafx.input.*;
import javafx.scene.*;
import javafx.scene.effect.*;
import javafx.scene.geometry.*;
import javafx.scene.image.*;
import javafx.scene.paint.*;
import javafx.scene.text.*;
import javafx.scene.transform.*;
import java.lang.Math;

/**
 * A group that automatically lays out the nodes
 */
public class GridBox extends Group {   
    
    public attribute horizontalSpace:Integer=20;
    public attribute verticalSpace:Integer=20;
    public attribute parentWidth:Integer = 0 on replace {
        impl_requestLayout();
    };
    // whenever the columns change reshuffle the layout
    private attribute columns:Integer=1 on replace {         
        impl_requestLayout(); 
    };   
    
    /**
     * Initialize this component
     */
    init {   
        impl_layout = doBoxLayout;
    }
    
     /**
     * Layout the nodes in the box using a standard grid layout.
     * whenever a node is added or removed, the doBoxLayout is 
     * called, and if needed animations are ran.
     */
    private function doBoxLayout(g:Group) : Void {   
        var maxWidth:Number=0.0;
        var maxHeight:Number=0.0;
        
        for(n in content) {
            maxWidth = if (n.getBoundsWidth() > maxWidth) n.getBoundsWidth() 
            else maxWidth;
            maxHeight = if(n.getBoundsHeight() > maxHeight) n.getBoundsHeight() 
            else maxHeight;
        }
        
        if (parentWidth > 0) {
            columns = Math.floor(((parentWidth - translateX) / (maxWidth + horizontalSpace/2))) as Integer;
        }
        
        // iterate over all the elements in content
        var i:Integer=0;
        for(n in content where (n as GridBoxNode).gridBoxManaged == true) {   
            var gridNode = n as GridBoxNode;
            // use the position in the grid to calculate their position
            var x = i mod columns;
            var y = (
                i / columns).intValue();
            
            // calculate the new values and include the spacing
            var newX = x * maxWidth + (horizontalSpace / 2 * x) ;
            var newY = y * maxHeight + (verticalSpace / 2 * y);
            
            // if the point hasn't been added yet, set it in it's calculated position
            var newPoint = Point {x:newX as Integer  y:newY as Integer}
            if (
            gridNode.point == null) {
                gridNode.point = newPoint;
                gridNode.impl_layoutX = newX;
                gridNode.impl_layoutY = newY;
                gridNode.siblings = sizeof content;
            } else {
                // if we need to move to a new point move there
                if (newPoint.x != gridNode.point.x or newPoint.y != gridNode.point.y) {
                    animateNode(gridNode,newPoint);        
                } 
            }
            i++;
        }            
    }
    
    public function insertNearest(node:GridBoxNode) {
        // first remove this node from the content list
        delete node from content;
        
        var minDistance = java.lang.Integer.MAX_VALUE;
        var minNode : Integer = 0;
        var isLeft : Boolean = true;
        for(n in content) {
            if (n != node) {
                // check the distance to the upper left corner
                var xDist = java.lang.Math.abs(node.impl_layoutX - n.impl_layoutX);
                var yDist = java.lang.Math.abs(node.impl_layoutY - n.impl_layoutY);
                if ((xDist + yDist) < minDistance) {
                    minNode = indexof n;
                    minDistance = xDist + yDist as Integer; 
                    isLeft = true;
                }
                
                // check the distance to the upper right corner
                xDist = java.lang.Math.abs(node.impl_layoutX - (n.impl_layoutX + n.getBoundsWidth()));;
                if ((xDist + yDist) < minDistance) {
                    minNode = indexof n;
                    minDistance = xDist + yDist as Integer; 
                    isLeft = false;
                }
            }
        }
         
         // we only need to do something if we've found a node
        if (isLeft) {
             // first remove the old node, and then insert the new one
             insert node before content[minNode];
        } else {
            // the first one was the nearest one
            insert node after content[minNode];
        }
        node.gridBoxManaged = true;
        impl_requestLayout();
    }
    
    /**
     * This function animate a node in this gridbox. When the content
     * of this gridbox changes, the nodes are animated to their new
     * location.
     */
    private function animateNode(node:GridBoxNode, newPoint:Point) {
        if (not node.timeline.running or (newPoint.x == node.point.x and newPoint.y == node.point.y)) {
            node.timeline = Timeline {
                repeatCount: 1
                autoReverse: false
                // define the first keyframe
                var begin : KeyFrame = KeyFrame {
                    time: 0s
                    values: [node.impl_layoutX => node.point.x tween Interpolator.EASEBOTH,
                             node.impl_layoutY => node.point.y tween Interpolator.EASEBOTH,
                             node.opacity => 1 tween Interpolator.EASEBOTH]
                }
                var middle : KeyFrame = KeyFrame {
                    time : 1.0s
                    values: [node.opacity => 0.1 tween Interpolator.EASEBOTH]
                }
                // define the end keyframe
                var end : KeyFrame = KeyFrame {
                    time: 2.0s
                    values: [node.impl_layoutX => newPoint.x tween Interpolator.EASEBOTH,
                             node.impl_layoutY => newPoint.y tween Interpolator.EASEBOTH,
                             node.opacity => 1 tween Interpolator.EASEBOTH
                             ]
                    // this action is executed at the end.
                    action: function() {
                        node.point = newPoint;                                                        
                    }
                }
                keyFrames : [begin,middle,end]
            };  
            node.timeline.start();
        } 
    } 
} 