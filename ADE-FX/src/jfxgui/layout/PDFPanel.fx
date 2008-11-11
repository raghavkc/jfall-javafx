/*
 * PDFPanel.fx
 *
 * Created on Oct 29, 2008, 7:58:27 PM
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

public class PDFPanel extends CustomNode {
    
     public attribute group : Group;
     public attribute content : Node[];
    
     public function create(): Node {
        group = Group  { 
            
            content : bind this.content;
        }
        
        return group;
    }
    

}
