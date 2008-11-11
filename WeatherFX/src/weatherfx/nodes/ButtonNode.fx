/*
 * ButtonNode.fx
 *
 * Created on Sep 12, 2008, 8:33:19 AM
 */

package weatherfx.nodes;

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
 * This node represents a button. This also contains
 * all the animations and other effects.
 */
public class ButtonNode extends CustomNode {
         
    // set by calling class
    public attribute nodeName : String = "";  
    public attribute resourceName : String;
    
    // control the bounce animation
    private attribute mouseEntered : Boolean = false;
    private attribute bounceOffset : Number = 0;
    private attribute timeline : Timeline;  
    
    private attribute image : ImageView = ImageView {
        image:Image {
            url: bind resourceName;
        }    }
    
    // holds the text
    private attribute text : Text = Text {
        visible: bind 
                        if (mouseEntered) then true
                      else false
        fill: Color.BROWN;
        font: Font { 
            size: 15 
            style: FontStyle.BOLD
        }
        content: nodeName
        translateY: -10
    }
    
    
    /**
     * Returns the custom node. 
     */
    public function create(): Node {
        // make sure the text is alligned correctly
        text.translateX = -(text .getWidth() / 2) + (image.getWidth() /2);
        
        // return a new group with all the elements
        return Group {
            translateY: bind bounceOffset
            onMouseEntered: 
                function(me:MouseEvent):Void {
                    mouseEntered = true;
                    bounceNode(); 
                }
            onMouseExited:
                function(me:MouseEvent):Void {
                    mouseEntered = false;
                }        
            
            // the content of this custom node
            content: [ image,text]
        };
    }
    


    // Handle the animation. We use an on replace to check whether we need
    // to keep running. And we use a simple bounceNode for the initial setup.
    // Once the timeline has been setup we just reuse this timeline

    /**
     * When the running state changes, we check whether we're still hovering
     * over the node. If so, restart the animation.
     */
    private attribute animationRunning : Boolean = bind timeline.running on replace {        
        if (
        not animationRunning and mouseEntered) {
            bounceNode();
        }
    };
    
    /**
     * To avoid starting the animation twice, we just check if it's
     * running. If it is we ignore it. We also check to see if it's
     * null.
     */
    private function bounceNode() {
        if (timeline != null) {
            if (not timeline.running) {
                timeline.start();
            }
        } else {
            startBounce();
        }
    }
    
    /**
     * Setsup the animation. This defines a couple of keyframes
     */
    private function startBounce() {
        timeline = Timeline {
            repeatCount: 1
            autoReverse: true
            
            var begin : KeyFrame = KeyFrame {
                time: 0s
                values: [
                        bounceOffset => 0 tween Interpolator.EASEBOTH]
            }
            
            var middle : KeyFrame = KeyFrame {
                time: 0.5s
                values: [
                        bounceOffset => -25.0 tween Interpolator.EASEBOTH]
            }
            
            var end : KeyFrame = KeyFrame {
                time: 1.0s
                values: [
                        bounceOffset => 0 tween Interpolator.EASEBOTH]
            }
            
            keyFrames : [begin,middle,end]
        };
        timeline.start();
    }
}        
