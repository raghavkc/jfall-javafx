/*
 * ThumbnailNode.fx
 *
 * Created on Aug 10, 2008, 1:34:36 PM
 */

package pictureviewer.nodes;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.image.ImageView;
import javafx.scene.image.Image;

/**
 * @author nl24167
 */

// place your code here
public class ThumbnailNode extends CustomNode {

    public static attribute xSize : Integer = 112;
    public static attribute ySize : Integer = 70;    
    
    public attribute imageUrl : String;
    private attribute image: Image = Image {
                        url: bind imageUrl;
                        width: bind xSize;
                        height: bind ySize;
                    }
    
    public function create(): Node {
        
        return Group {
            content: [ ImageView {
                    image:image
                }]
        };
    }
}