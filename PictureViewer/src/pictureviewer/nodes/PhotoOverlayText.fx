/*
 * PhotoOverlayText.fx
 *
 * Created on Aug 10, 2008, 3:40:20 PM
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

/**
 * 
 * @author nl24167
 */
public class PhotoOverlayText extends CustomNode {

    public attribute x : Number = 0;
    public attribute y : Number = 280;
    public attribute text : String = "";
    
    public function create(): Node {
        
        return Group {
            content: [ Rectangle {
                    x: bind this.x, 
                    y: bind this.y
                    
                    width: 480, height: 20
                    fill: Color.BLACK
                    opacity: 0.5
                    
                }, 
                Text {
                    fill: Color.WHITE
                    font: Font { 
                        size: 12 
                        style: FontStyle.PLAIN
                    }
                    x: bind this.x + 10, 
                    y: bind this.y + 14
                    content: bind text;
                }]
        };
    }
}
