package aegaron.service;

import java.io.StringWriter;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;


public class WriteXML {
/*
 <?xml version="1.0" encoding="UTF-8"?>
 <terms>
   <category classification="ornaments" />
   <term>
     <preferred arkid="21198/zz002hvpzn" lang="en">abacus</preferred>
   </term>
 </terms>
 */

    public static void main(String[] args) {
        try {

            DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

            // root elements
            Document doc = docBuilder.newDocument();
            Element rootElement = doc.createElement("terms");
            doc.appendChild(rootElement);

            // category elements
            Element category = doc.createElement("category");
            rootElement.appendChild(category);

            // set attribute to category element
            Attr attr = doc.createAttribute("classification");
            attr.setValue("ornaments");
            category.setAttributeNode(attr);

            // term elements
            Element term = doc.createElement("term");
            rootElement.appendChild(term);

            // preferred elements
            Element preferred = doc.createElement("preferred");
            preferred.appendChild(doc.createTextNode("abacus"));
            preferred.setAttribute("arkid", "21198/zz002hvpzn");
            preferred.setAttribute("lang", "en");
            category.setAttributeNode(attr);
            preferred.setNodeValue("abacus");
            term.appendChild(preferred);

            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            // pretty print
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
            DOMSource source = new DOMSource(doc);
            StringWriter writer = new StringWriter();
            transformer.transform(source, new StreamResult(writer));
            String output = writer.toString();
            
            System.out.println(output);
            // write the content into xml file
            //StreamResult result = new StreamResult(new File("C:\\test.xml"));

            // Output to console for testing
            //StreamResult result = new StreamResult(System.out);

            //transformer.transform(source, result);

            //System.out.println("File saved!");

        } catch (ParserConfigurationException pce) {
            pce.printStackTrace();
        } catch (TransformerException tfe) {
            tfe.printStackTrace();
        } 
    }
        
}

