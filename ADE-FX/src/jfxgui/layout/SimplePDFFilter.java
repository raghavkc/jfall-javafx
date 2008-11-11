/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package jfxgui.layout;

import java.io.File;
import java.io.FilenameFilter;

/**
 *
 * @author nl24167
 */
public class SimplePDFFilter implements FilenameFilter {

    @Override
    public boolean accept(File dir, String name) {
       if (name.endsWith(".pdf")) {
           return true;
       } else return false;
    }

}
