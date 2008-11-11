/*
 * CategoryNode.fx
 *
 * Created on Nov 2, 2008, 9:38:41 PM
 */

package jfxgui.layout;

import javafx.animation.*;
import javafx.input.*;
import javafx.scene.*;
import javafx.scene.effect.*;
import javafx.scene.geometry.*;
import javafx.scene.image.*;
import javafx.scene.paint.*;
import javafx.scene.layout.*;
import javafx.scene.text.*;
import javafx.scene.transform.*;

/**
 * Category node holds the category name, and an icon
 *
 * @author nl24167
 */
public class CategoryNode extends CustomNode {
    
      public attribute name : String;
      private attribute icon : ImageView = ImageView {
            scaleX: 0.5;
            scaleY: 0.5;
            image: Image {
            url: "file:/home/nl24167/Desktop/javafx/resources/air.png"
        }
      }

      public function create(): Node {
        var box : HBox = HBox {
            onMouseEntered: function (e:MouseEvent) {
                effect = Bloom {
                }
            }
            onMouseExited: function (e:MouseEvent) {
                effect = null;
            }
            translateX: 5
            spacing: 5;
            content: [
                icon, 
                Text {
                    translateY: 16;
                    fill: Color.WHITE
                    font: Font { 
                        size: 12
                        style: FontStyle.BOLD_ITALIC
                        name: "Arial"
                    }
                    smooth : true
                    content: bind name;
                }
            ]

        };
        
        return box;
    }
}
