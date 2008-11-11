/*
 * PhotoNode.fx
 *
 * Created on Aug 10, 2008, 3:03:09 PM
 */

package pictureviewer.nodes;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.image.ImageView;
import javafx.scene.image.Image;
import javafx.scene.geometry.Rectangle;
import javafx.scene.paint.Color;
import javafx.scene.text.Text;
import javafx.scene.Font;
import javafx.scene.FontStyle;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.animation.Interpolator;
import javafx.lang.Duration;

/**
 * This node represents the larger photo. This node has 
 * all the images preloaded, defines a background image
 * and handles all it's own animations.
 *
 * @author nl24167
 */
public class PhotoNode extends CustomNode {

    // holds the images, only used for preloading the images
    public attribute imageUrls : String[];
    // the current comment that is being shown
    public attribute comments : String = "";
    
    // all the preloaded images
    private attribute images : Image[];
    // the current image that is being shown
    private attribute image: Image;
    // the background image shown when it's faded
    private attribute backgroundImage: Image = Image {
        url: "file:///home/nl24167/NetBeansProjects/PictureViewer/resources/images/JavaFXLogo.png"
    };
    // the photogroup contains the overlay and the shown image
    private attribute photoGroup : Group = Group {
                    content : [
                        ImageView {
                            image: bind image
                        },PhotoOverlayText{
                            x:  0
                            y:  290
                            text: bind comments  
                        }
                    ]
                };
    
    /**
     * Called when this node is intaniated. This returns a group which 
     * can be shown in the application
     */
    public function create(): Node {
        
        // preload the images
        images = [
            Image {width:480 height:310 url: imageUrls[0]},
            Image {width:480 height:310 url: imageUrls[1]},
            Image {width:480 height:310 url: imageUrls[2]},
            Image {width:480 height:310 url: imageUrls[3]},
        ];
        
        // set the image to show
        image = images[0];
        
        // return the whole group which is shown by this component
        // this is the background and the photogroup      
        return Group {
            content: [
                ImageView {
                    image : bind backgroundImage
                    translateX: 50;
                    translateY: 50;
                }, photoGroup
                
            ]
        }
    }
    
    /**
     * The method shows the next picture. It does this by creating an animation
     * which fades in and out and halfway changes the image
     */
    public function nextPicture(selectedImage : Number, comments : String) {
        animateFadeInFadeOut(5s, comments, selectedImage);
    }
    
    //------------------------------------------------------------------
    // Some private helper functions
    //------------------------------------------------------------------
    
    /**
     * Sets up the animation which will fade out an image, load a new one
     * and fades in again.
     */ 
    private function animateFadeInFadeOut(totalTime : Duration, comments : String, selectedImage : Integer ) {
     
        // create a timeline which is run one time
        var timeline : Timeline = Timeline {
            repeatCount: 1      
            
            // we begin at 0, where the opacity is 1
            var begin = at (0s) {
                photoGroup.opacity => 1 ;
            }
            
            // halfway we set the opacity almost at almost 0
            var middle : KeyFrame = KeyFrame {
                time: totalTime / 2
                values: [photoGroup.opacity => 0.01 tween Interpolator.EASEBOTH]
                action: function() {
                    // halfway there, replace the comments and the image
                    this.comments = comments;
                    image = images[selectedImage];
                }
            }
            
            // at the end opacity is back at 1
            var end : KeyFrame = KeyFrame {
                time: totalTime
                values: [
                        photoGroup.opacity => 1 tween Interpolator.EASEBOTH
                ]

            }            
            
            // set the keyframes
            keyFrames : [begin,middle,end]               
        };
        
        // and start the animation
        timeline.start();
    }
}