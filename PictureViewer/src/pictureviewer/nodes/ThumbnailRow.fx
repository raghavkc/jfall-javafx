/*
 * ThumbnailRow.fx
            *
 * Created on Aug 10, 2008, 2:39:18 PM
 */

package pictureviewer.nodes;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.image.ImageView;
import javafx.scene.image.Image;
import javafx.scene.layout.VBox;
import javafx.input.MouseEvent;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.animation.Interpolator;

import java.lang.System;

/**
 * @author nl24167
 */

public class ThumbnailRow extends CustomNode {

    // which overlay are we looking at
    public attribute overLayPosition : Number = 1;
    
    // which images are we displaying
    public attribute urls : String[]; 
    
    // used for the animation of the overlay
    private attribute animationPos : Number = 0;
    
    // some magic values which correctly places the images
    private attribute gapBetweenImages : Number = 7;
    private attribute overlayOffsetX : Number = 0;
    private attribute overlayOffsetY : Number = 0;
    private attribute imagesOffsetX : Number = 4;
    private attribute imagesOffsetY : Number = 4;
    private attribute overlayScaleX : Number = 0.83;
    private attribute overlayScaleY : Number = 0.92;
    
    // this method sets the initial view of 4 images with
    // the top one 'selected' by the transparant node
    public function create(): Node {
     
        return Group {
            content: [
                VBox {
                    translateX: imagesOffsetX
                    translateY: imagesOffsetY
                    
                    spacing: bind gapBetweenImages
                    content: [
                        ThumbnailNode{imageUrl: urls[0]},ThumbnailNode{imageUrl: urls[1]},
                        ThumbnailNode{imageUrl: urls[2]},ThumbnailNode{imageUrl: urls[3]} 
                    ]
                },
                ImageView {
                    image: Image {
                        url: "file:///home/nl24167/NetBeansProjects/PictureViewer/resources/images/transparant_border.png" 
                    }
                    translateY: bind overlayOffsetY + animationPos + 
                        (overLayPosition - 1) * (gapBetweenImages 
                        + ThumbnailNode.ySize)
                    translateX: bind overlayOffsetX
                    scaleX : overlayScaleX
                    scaleY : overlayScaleY
                }
            ]
        }
    }
    
    // we have two different types of animations
    // one from top going one down, and one 
    // going from the bottom back to the top
    public function nextOverlay(pictureNumber : Number, url : String) : Void {
        if (overLayPosition == 4) {
            moveLayerUp();
        } else {
            moveLayerDown();
        }
    }
    
    // move the layer back up to the top thumbnail
    private function moveLayerUp() {
        var timeline : Timeline = Timeline {
            repeatCount: 1
            
            // makes sure that the next animation also works
            var cleanup : KeyFrame = KeyFrame {
                time: 5.01s

                action : function() {
                    overLayPosition = 1;
                    animationPos = 0;
                }
            }
            
            // we begin at 0
            var begin = at (0s) {
                            animationPos => 0;
            }
            
            // and move down one field
            var end = at (5s) {
                            animationPos => -1 * (gapBetweenImages + ThumbnailNode.ySize) * 3 ;
            }
            
            keyFrames : [begin,end,cleanup]               
        };
        
        timeline.start();
    }
    
    // Moves the transparant layer one position down
    private function moveLayerDown() {
        var timeline : Timeline = Timeline {
            repeatCount: 1
            
            // makes sure that the next animation also works
            var cleanup : KeyFrame = KeyFrame {
                time: 5.01s

                action : function() {
                    overLayPosition = overLayPosition + 1;
                    animationPos = 0;
                }
            }
            
            // we begin at 0
            var begin = at (0s) {
                            animationPos => 0 ;
            }
            
            // and move down one field
            var end = at (5s) {
                            animationPos => gapBetweenImages + ThumbnailNode.ySize tween Interpolator.EASEBOTH;
            }
            
            keyFrames : [begin,end,cleanup]               
        };
        
        timeline.start();
    }
}