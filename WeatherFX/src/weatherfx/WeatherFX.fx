/*
 * Main.fx
 *
 * Created on Sep 11, 2008, 3:57:22 PM
 */

package weatherfx;

import javafx.application.Stage;
import javafx.scene.geometry.Circle;
import javafx.scene.paint.Color;
import javafx.application.Application;
import javafx.application.Frame;
import javafx.application.WindowStyle;
import javafx.input.*;

import weatherfx.nodes.*;

var barOffset : Number = 250;

Frame {
    windowStyle:WindowStyle.UNDECORATED;
    title: "WeatherFX"
    width: 500
    height: 300
    visible: true
    

  
    var infobar : InfoBar = InfoBar {
        location: bind map.selectedLocation
        visible: false
    };
      var map : EuropeMap = EuropeMap{
        showMapBorders: bind bar.showMapBorders;
        metarCodeChanged : function() {
            infobar.visible = true;
        }
        }

        var bar : ButtonBar = ButtonBar {
        translateY: barOffset;
        temperatureClicked : function(e:MouseEvent) {
            infobar.addTemperature();
        }
        pressureClicked : function (e:MouseEvent) {
            infobar.addPressure();
        }
        doubleClickedBar : function (e:MouseEvent) {
            if (infobar.visible) {
                infobar.visible = false;
            } else {
                infobar.visible = true;
            }
        }
    };
    
    
    stage: Stage {
        content: [
            map,bar,infobar
        ]
    }
}