/*
 * InfoBar.fx
 *
 * Created on Nov 9, 2008, 2:52:35 PM
 */

package weatherfx.nodes;

import javafx.animation.*;
import javafx.input.*;
import javafx.input.KeyEvent;
import javafx.scene.*;
import javafx.scene.effect.*;
import javafx.scene.geometry.*;
import javafx.scene.image.*;
import javafx.scene.paint.*;
import javafx.scene.text.*;
import javafx.scene.transform.*;
import java.lang.System;
import javafx.scene.layout.*;

import org.springframework.context.support.ClassPathXmlApplicationContext;
import metar.service.MetarService;
import metar.dao.*;
import metar.model.*;
import java.text.SimpleDateFormat;

/**
 * @author nl24167
 */

public class InfoBar extends CustomNode {
    
    public attribute heigth : Number = 265;
    public attribute width : Number = 100;
    
    private attribute offsetX = 400 ;
    
    private attribute service: MetarService;
    private attribute metarStation : MetarStation = null;
    private attribute metarName : String = null;
    private attribute metarCode : String = null;
    private attribute longitude : String = null;
    private attribute latitude : String = null;
    
    private attribute box : VBox;
    private attribute detailBox : VBox;
    
    public attribute location : String = "EHEH" on replace {
        if (
        location != null) {
            metarStation = service.getMetarStation(location);
            metarName = metarStation.getName().trim();
            metarCode = metarStation.getMetarCode();
            
            var lat = metarStation.getLatitude();
            var long = metarStation.getLongitude();
            
            longitude = "Long: {long}";
            latitude = "Lat: {lat}";
            
        }
    }
    
    public function create(): Node {
        
        initMetarService();
        
        var background : Rectangle = 
        Rectangle {
            x: offsetX, y: 0
            width: bind width 
            height: bind heigth
            fill: Color.BLACK
            opacity: 0.7
        }
        createBox();
   
        var group : Group = Group {
            content : [background, box]
        }
        
        return group;
    }
    
    private function createBox() {
        var textFont : Font = Font { 
            size: 12 
            style: FontStyle.PLAIN
        }
        
        box = VBox {
            translateX : offsetX + 5;
            translateY : 15;
            spacing : 2;
            content : [
                Text {
                    font : textFont;
                    fill : Color.WHITE
                    content: bind metarName
                },
                Text {
                    font : textFont;
                    fill : Color.WHITE
         
                    content: bind metarCode
                },
                Text {
                    font : textFont;
                    fill : Color.WHITE
           
                    content: bind longitude
                },
                Text {
                    font : textFont;
                    fill : Color.WHITE
            
                    content: bind  latitude
                },
                Line {
                    startX:  10
                    endX: 90
                    strokeWidth: 1
                    stroke: Color.WHITE
                },
                Rectangle {
                    width: bind width 
                    height: 5
                    fill: Color.BLACK
                    opacity: 0.0
                }
            ]
        }; 
    }
    
    public function addPressure() {
        
         delete detailBox from box.content;
        
        detailBox = VBox {
            spacing : 2;
        }
        
         var image =  ImageView {
                translateX : 60;
                translateY : -5;
                image: Image {
                    width : 30
                    url: "{__DIR__}/../resources/pressure.png"
                }
            };
        
        insert image into detailBox.content;
        
        var metarRecords = service.getLatestRecords(location, 5);
        for (metarRecord in metarRecords) {
            var pressure = metarRecord.getPressure();
            var date = metarRecord.getMeasureTime();
            var formatter = new SimpleDateFormat("dd.MM-HH:mm");
            var formattedDate = formatter.format(date);
            var dateText = Text {
                font : Font { 
                    size: 12 style: FontStyle.PLAIN
                }
                fill : Color.WHITE
                content: formattedDate
            }
            var pressureText = Text {
                font : Font { 
                    size: 12 style: FontStyle.PLAIN
                }
                fill : Color.WHITE
                content: pressure + "\u00B0C";
            }  
            insert dateText into detailBox.content; 
            insert pressureText into detailBox.content; 
        }
        
        insert detailBox into box.content;
        fadeInBox(detailBox);
    }    
    
    public function addTemperature() {
        
        delete detailBox from box.content;
        
        detailBox = VBox {
            opacity : 0.1;
            spacing : 2;
        }
        
        var image =  ImageView {
            translateX : 60;
            translateY : -5;
            image: Image {
                width : 30
                url: "{__DIR__}/../resources/temperature.png"
            }
        };
        
        insert image into detailBox.content;
        
        var metarRecords = service.getLatestRecords(location, 5);
        for (metarRecord in metarRecords) {
            var temp = metarRecord.getTemperature();
            var date = metarRecord.getMeasureTime();
            var formatter = new SimpleDateFormat("dd.MM-HH:mm");
            var formattedDate = formatter.format(date);
            var dateText = Text {
                font : Font { 
                    size: 12 style: FontStyle.PLAIN
                }
                fill : Color.WHITE
                content: formattedDate
            }
            var tempText = Text {
                font : Font { 
                    size: 12 style: FontStyle.PLAIN
                }
                fill : Color.WHITE
                content: temp + "\u00B0C";
            }  

            insert dateText into detailBox.content;
            insert tempText into detailBox.content; 
        }
        
       
        insert detailBox into box.content;
        fadeInBox(detailBox);
    }
    
    private function initMetarService() {
        var ctx = new ClassPathXmlApplicationContext("META-INF/applicationcontext.xml");
        service = 
        ctx.getBean("metarService") as MetarService;
    }
    
private function fadeInBox(box:VBox) {
        var timeline = Timeline {
            
            var begin : KeyFrame = KeyFrame {
                time: 0s
                values: [box.opacity => 0.01 tween Interpolator.EASEBOTH]
            }
            
            var end : KeyFrame = KeyFrame {
                time: 1.0s
                values: [box.opacity => 1 tween Interpolator.EASEBOTH]
            }
            
            keyFrames : [begin,end]
        };
        timeline.start();
    }
}
