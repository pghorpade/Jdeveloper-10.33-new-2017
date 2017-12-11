package aegaron.service;

import java.io.File;
import java.io.IOException;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.xpath.XPath;


public class Test {

    public static void main(String[] args) throws Exception {
        Test test = new Test();

        System.out.println("Valid Format Test: " + test.isValidDate("2004-02-29"));
        System.out.println("Leap Year Test: " + test.isValidDate("2005-02-29"));
        System.out.println("Year Only Test: " + test.isValidDate("2012"));
        System.out.println("Incorrect format Test: " + test.isValidDate("09-25-2012"));
        System.out.println("Empty Test: " + test.isValidDate(" "));
        System.out.println("Null Test: " + test.isValidDate(null));
        
        test.processXml("c:\\aegaron.xml");
        
    }
    
    private static void processXml(final String filename) {
        try {
            SAXBuilder builder = new SAXBuilder();
            Document document = builder.build(new File(filename));
    
            XPath xPath = XPath.newInstance("/record/metadata/dc/altTitle/planTitle");
            Element planTitle = (Element)xPath.selectSingleNode(document);
            
            if (planTitle != null) {
                System.out.println("AltTitle.planTitle = " + planTitle.getText());
            } else {
                System.out.println("AltTitle.planTitle is null.");
            }
            
            XPath xPath2 = XPath.newInstance("/record/metadata/dc/type/state");
            Element state = (Element)xPath2.selectSingleNode(document);
            
            if (state != null) {
                System.out.println("Type.state = " + state.getText());
            } else {
                System.out.println("Type.state is null.");
            }
            
            XPath xPath3 = XPath.newInstance("/record/metadata/dc/subject/place");
            Element place = (Element)xPath3.selectSingleNode(document);
            
            if (place != null) {
                System.out.println("Subject.place = " + place.getText());
            } else {
                System.out.println("Subject.place is null.");
            }
        }
        catch (JDOMException e) {
            e.printStackTrace();
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static boolean isValidDate(final String sDate) {
        if ((sDate == null) || ("".equals(sDate))) 
            return false;
        
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        if (sDate.trim().length() != formatter.toPattern().length()) 
            return false;

        formatter.setLenient(false);
        
        try {
            formatter.parse(sDate.trim());
        } catch (ParseException pe) {
            return false;
        }        
        return true;
    }


}
