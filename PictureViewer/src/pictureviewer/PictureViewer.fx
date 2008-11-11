/*
 * PictureViewer.fx
 *
 * Created on Aug 10, 2008, 4:45:35 PM
 */

package pictureviewer;

import javafx.scene.layout.HBox;
import pictureviewer.nodes.*;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.input.MouseEvent;
import javafx.scene.image.Image;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.animation.Interpolator;

/**
 * Contains the two main nodes. The large photo component and the 
 * horizontal box.
 * 
 * @author nl24167
 */

public class PictureViewer extends CustomNode {
    
    private attribute urls : String[] = [
        "file:///home/nl24167/NetBeansProjects/PictureViewer/resources/images/NATURE-Leaf_1920x1200.jpg",
        "file:///home/nl24167/NetBeansProjects/PictureViewer/resources/images/Good_Vibrations-1440x900.jpg",
        "file:///home/nl24167/NetBeansProjects/PictureViewer/resources/images/Leaf_Bud_by_areelcue.jpg",
        "file:///home/nl24167/NetBeansProjects/PictureViewer/resources/images/image.jpg"
    ];
    
    private attribute commentsList : String[] = [
        "It is a wise father that knows his own child.",
        "Something's rotten in the state of Denmark.",
        "Man is the only animal that blushes -- or needs to.",
        "The ripest fruit falls first."
    ];

    
    private attribute offsetX : Number = 2;
    private attribute offsetY : Number = 2;
    private attribute horizontalSpacing : Number = 1;
    private attribute selectedImage = 0;

    private attribute photoNode : PhotoNode = PhotoNode{
        imageUrls: urls;
        comments: commentsList[0];
    };
    private attribute thumbnails : ThumbnailRow = ThumbnailRow {
        urls : this.urls;
    };
    
    public function create(): Node {
        return Group {
            content: [     
                HBox {
                    translateX: offsetX
                    translateY: offsetY
                    spacing: horizontalSpacing
                    content: [photoNode,thumbnails] 
                }
            ]
            onMouseClicked: function( e: MouseEvent ):Void {
                
                if (e.getClickCount() == 2) {
                    
                    // run for the first time
                    selectedImage++;
                    photoNode.nextPicture(selectedImage,commentsList[selectedImage]);
                    thumbnails.nextOverlay(selectedImage, urls[selectedImage]);
                    
                    // now run automatically
                    var timeline : Timeline = Timeline {
                        repeatCount: Timeline.INDEFINITE;
            
                        var next : KeyFrame = KeyFrame {
                            time: 10s

                            action : function() {
                                if (
                                selectedImage == 3) {
                                    selectedImage = -1;
                                } 
                                selectedImage++;
                                photoNode.nextPicture(selectedImage,commentsList[selectedImage]);
                                thumbnails.nextOverlay(selectedImage, urls[selectedImage]);
                            }
                        }            
            
                        keyFrames : [next]               
                    };
        
                    timeline.start();    
                }
            }
        }
    }
}
