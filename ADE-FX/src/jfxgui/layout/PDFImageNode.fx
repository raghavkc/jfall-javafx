/*
 * PDFImageNode.fx
 *
 * Created on Oct 28, 2008, 8:33:24 PM
 */

package jfxgui.layout;

import com.sun.pdfview.PDFFile;
import com.sun.pdfview.PDFPage;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.awt.Rectangle;
import java.io.*;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;

/**
 * @author nl24167
 */

public class PDFImageNode {

    
    public function getAllPdfs(directory : String) : JFXPDFFile[] {
        var dir = new File(directory);
        
        var files = dir.listFiles(new SimplePDFFilter());
        var result : JFXPDFFile[];
        for (file in files) {
            insert JFXPDFFile {
                image : getImage(file) as BufferedImage
                location : file.getAbsolutePath()
                name : file.getName()
                }  into result;
        }       
                
        return result;
    }
    
    public function loadPDF(location : String) : PDFFile {
        var file = new File(location);
        var raf = new RandomAccessFile(file, "r");
        var channel = raf.getChannel();
        var buf = channel.map(FileChannel.MapMode.READ_ONLY, 0, channel.size());
        return  new PDFFile(buf);
    }
    
    public function getPage(pdf : PDFFile, page : Integer) : Image  {
        return pageToImage(pdf.getPage(page));
    }
    
    public function getImage(file: File) : Image {
        
        var raf = new RandomAccessFile(file, "r");
        var channel = raf.getChannel();
        var buf = channel.map(FileChannel.MapMode.READ_ONLY, 0, channel.size());
        var pdffile = new PDFFile(buf);

        // draw the first page to an image
        var page = pdffile.getPage(0);
        
        
        return pageToImage(page);
    }
    
    private function pageToImage(page : PDFPage) : Image {
        var rect = new Rectangle(0,0,
            page.getBBox().getWidth(),
            page.getBBox().getHeight());        
        
        var scale :Number  = 1;
        if (page.getBBox().getWidth() < 1024) {
            scale = 1024 / page.getBBox().getWidth();
        }
        
        //generate the image
        var img = page.getImage(
                rect.width * scale, rect.height * scale, //width & height
                //1024, 768, //width & height
                rect, // clip rect
                null, // null for the ImageObserver
                true, // fill background with white
                true  // block until drawing is done
        );
                
        return img;
    }
}
