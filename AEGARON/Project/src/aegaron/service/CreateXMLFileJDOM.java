package aegaron.service;

import java.io.IOException;

import java.util.LinkedList;


import java.util.List;

import org.jdom.Attribute;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;


public class CreateXMLFileJDOM {

    private static final String xmlFilePath = "C:\\newXMLfile.xml";

    public static void main(String[] args) {

        try {

            Element term = new Element("term");

            Document document = new Document(term);

            // you might not need this..
            // the firt Element that is created
            // will be automatically set as the root element
            // document.setRootElement(company);
            String[] classifications = {"ornaments","construction and structural design"};
            String[] items = {"21198/zz002hvpzn", "21198/zz002hvrjd", "21198/zz002hvrct"};      
            String[] titles = {"abacus", "altar", "ambulatory temple"};
            Element title = new Element("title"); 
            title.setAttribute(new Attribute("lang", "en"));
            title.setText("Test");
            term.addContent(title);
           
            List<String> catList = new LinkedList<String>();
            catList.add("adobe");
            catList.add("air-dried brick");
            catList.add("brickwork");
            
            Element relationships = new Element("relationships");
            String qualifierLabel = "German_alternate";
            
            for (String s: classifications) {
                int count = 1;
                if ("German_alternate".equals(qualifierLabel)) {
                    Element altTitle = new Element("alttitle"); 
                    altTitle.setAttribute(new Attribute("lang", "en"));
                    altTitle.setAttribute(new Attribute("preferred", "false"));
                    altTitle.setText(s+count++);
                    term.addContent(altTitle);
                    
                    for (String ark: items) {
                        Element relationship = new Element("relationship");
                        relationship.setAttribute(new Attribute("type", "parent"));
                        relationship.setAttribute(new Attribute("lang", "en"));
                        relationship.setAttribute(new Attribute("arkid", ark));
                        relationship.setText("Roman"+count++);
                        relationships.addContent(relationship);
                    }
                }

                else if ("English_alternate".equals(qualifierLabel)) {
                    Element altTitle = new Element("alttitle");
                    altTitle.setAttribute(new Attribute("lang", "en"));
                    altTitle.setAttribute(new Attribute("preferred", "false"));
                    altTitle.setText("Hello World!"+count++);
                    term.addContent(altTitle);
                }
                

                //term.addContent(categories);
                /*int count = 1;
                for (String s1: items) {
                    Element preferred = new Element("preferred");
                    preferred.setAttribute(new Attribute("lang", "en"));
                    preferred.setAttribute(new Attribute("arkid", s1));
                    preferred.setText("a"+ count++);
                    term.addContent(preferred);
                }*/
    
//                Element preferred2 = new Element("preferred");
//                preferred2.setAttribute(new Attribute("lang", "en"));
//                preferred2.setAttribute(new Attribute("arkid", "21198/zz002hvrjd"));
//                preferred2.setText("base");
//                term.addContent(preferred2);
    
                //document.getRootElement().addContent(categories);
                
//                Element category2 = new Element("category");
//                category2.setAttribute(new Attribute("classification", "construction and structural design"));
//                Element term2 = new Element("term");
//                category2.addContent(term2);
//                
//                Element preferred3 = new Element("preferred");
//                preferred3.setAttribute(new Attribute("lang", "en"));
//                preferred3.setAttribute(new Attribute("arkid", "21198/zz002hvpzn"));
//                preferred3.setText("abacus");
//                term2.addContent(preferred3);
//    
//                document.getRootElement().addContent(category2);
            }
            
            Element categories = new Element("categories");
            term.addContent(categories);
            for (String s: catList){
                Element category = new Element("category");
                category.setText(s);
                categories.addContent(category);
            }
            
            term.addContent(relationships);
            
            XMLOutputter xmlOutputer = new XMLOutputter();

            // you can use this tou output the XML content to
            // the standard output for debugging purposes
            // new XMLOutputter().output(doc, System.out);

            // write the XML File with a nice formating and alignment
            xmlOutputer.setFormat(Format.getPrettyFormat());
            xmlOutputer.output(document, System.out);
            //xmlOutputer.output(document, new FileWriter(xmlFilePath));

            System.out.println("XML File was created successfully!");

        } catch (IOException ex) {
            System.out.println(ex.getMessage());
        }
    }
}
