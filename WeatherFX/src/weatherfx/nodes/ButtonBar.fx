/*
 * ButtonBar.fx
 *
 * Created on Sep 12, 2008, 8:47:04 AM
 */

package weatherfx.nodes;

import javafx.input.*;
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
import javafx.scene.layout.HBox;

/**
 *  
 *
 * @author nl24167
 */
public class ButtonBar extends CustomNode {
    
    public attribute showMapBorders : Boolean = true;
    
    // the spacing between the elements in the bar
    private attribute spacing : Number = 20;
    // the location of the background bar
    private attribute backgroundBarLocation : String = "{__DIR__}/../resources/bar.png";
    // the image of the background bar
    private attribute backgroundBar : Image = Image {
        url: backgroundBarLocation;
    }
    
    public attribute temperatureClicked : function(e:MouseEvent):Void;
    public attribute pressureClicked : function(e:MouseEvent):Void;
    public attribute windClicked : function(e:MouseEvent):Void;
    public attribute cloudsClicked : function(e:MouseEvent):Void;
    public attribute doubleClickedBar : function(e:MouseEvent):Void;
    
    /**
     * Creates this node, this node contains buttons, the nar and the
     * zoom function
     */
    public function create(): Node {
        
        return Group {
            
            content: [
                ImageView {
                    // move down and set transparent
                    translateY: 15
                    opacity: 0.5
                    image: backgroundBar
                }
                ,
                HBox {
                    onMouseClicked: function (me:MouseEvent):Void {
                        if (me.getClickCount() == 2) {
                            java.lang.System.out.println("sdfsdfs");
                            doubleClickedBar(me);   
                            
                        }
                    }
                    spacing: spacing
                    translateX: spacing
                    content: [
                        ButtonNode {
                            resourceName : "{__DIR__}/../resources/clouds.png"
                            nodeName: "Wolken"
                            onMouseClicked: function(me:MouseEvent):Void {
                                if (me.getClickCount() == 1) {
                                    cloudsClicked(me);
                                }
                            }
                            
                        },
                        ButtonNode {
                            resourceName : "{__DIR__}/../resources/pressure.png"
                            nodeName: "Druk"
                            onMouseClicked: function(me:MouseEvent):Void {
                                if (me.getClickCount() == 1) {
                                    pressureClicked(me);
                                }
                            }
                        },
                        ButtonNode {
                            resourceName : "{__DIR__}/../resources/temperature.png"
                            nodeName: "\u00B0C"
                            onMouseClicked: function(me:MouseEvent):Void {
                                if (me.getClickCount() == 1) {
                                    temperatureClicked(me);
                                }
                            }
                        },
                        ButtonNode {
                            resourceName : "{__DIR__}/../resources/wind.png"
                            nodeName: "wind"
                            onMouseClicked: function(me:MouseEvent):Void {
                                if (me.getClickCount() == 1) {
                                    windClicked(me);
                                }
                            }
                        },
                        ButtonNode {
                            resourceName : "{__DIR__}/../resources/borders.png"
                            nodeName: "grenzen"
                            onMouseClicked: function(me:MouseEvent):Void {
                                if (not showMapBorders) showMapBorders = true
                                else showMapBorders = false;
                            }
                        }                        
                    ]
                }
            ]
        };
    }
}
