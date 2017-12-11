package aegaron.service;

import javax.xml.parsers.*;

import org.xml.sax.InputSource;

import org.w3c.dom.*;

import java.io.*;

import org.xml.sax.SAXException;

public final class ParseXML {
    private ParseXML() {
    }

    public static void main(String[] args) {
        String xmlString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + 
        "<record>" + 
        "  <metadata>" + 
        "    <dc>" + 
        "      <identifier>21198/zz002dq9xs</identifier>" + 
        "      <altIdentifier>" + 
        "        <drawing>0167</drawing>" + 
        "      </altIdentifier>" + 
        "      <title>Fortress, New Kingdom Temple</title>" + 
        "      <altTitle>" + 
        "        <planTitle>Reconstruction 1</planTitle>" + 
        "      </altTitle>" + 
        "      <type>" + 
        "        <printSize>A4/Letter</printSize>" + 
        "        <ideal>Ideal</ideal>" + 
        "      </type>" + 
        "      <coverage>" + 
        "        <geoscale>1:250</geoscale>" + 
        "      </coverage>" + 
        "    </dc>" + 
        "  </metadata>" + 
        "</record>";

        try {
            // first level
            String title = getCharValueForANode(xmlString, "title");
            System.out.println("title: " + title);
            String identifier = getCharValueForANode(xmlString, "identifier");
            System.out.println("identifier: " + identifier);
            // second level
            String drawing = getCharValueForANode(xmlString, "altIdentifier","drawing");
            System.out.println("altIdentifier.drawing: " + drawing);
            String planTitle = getCharValueForANode(xmlString, "altTitle","planTitle");
            System.out.println("altTitle.planTitle: " + planTitle);
            
            String printSize = getCharValueForANode(xmlString, "type","printSize");
            System.out.println("type.printSize: " + printSize);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    
    // Node is on the second level under a parent node pNodeName 
    public static String getCharValueForANode(String xmlStr, String pNodeName, String nodeName) 
    throws ParserConfigurationException, SAXException, IOException {
      String nodeValue = "";

      DocumentBuilder docBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
      InputSource is = new InputSource();
      is.setCharacterStream(new StringReader(xmlStr));

      Document doc = docBuilder.parse(is);
      NodeList nodes = doc.getElementsByTagName(pNodeName);

      for (int i = 0; i < nodes.getLength(); i++) {
        Element element = (Element)nodes.item(i);

        NodeList nodeList = element.getElementsByTagName(nodeName);
        Element firstEle = (Element) nodeList.item(0);
        nodeValue = getValueForElement(firstEle);
      }

      return nodeValue;
    }
    
    public static String getCharValueForANode(String xmlStr, String nodeName) 
    throws ParserConfigurationException, SAXException, IOException {
        String nodeValue = "";

        DocumentBuilder docBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
        InputSource is = new InputSource();
        is.setCharacterStream(new StringReader(xmlStr));

        Document doc = docBuilder.parse(is);
        NodeList nodes = doc.getElementsByTagName(nodeName);

        if ( nodes != null ) {
           Element element = (Element)nodes.item(0);
           nodeValue = getValueForElement(element);
        }

        return nodeValue;
    }


    private static String getValueForElement(Element ele) {
      Node firstChild = ele.getFirstChild();
      String value = "";
      if (firstChild instanceof CharacterData) {
        CharacterData charData = (CharacterData)firstChild;
        value = charData.getData();
      }
      return value;
    }


}

