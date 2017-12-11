package aegaron.service;

import java.io.StringWriter;
import java.io.Writer;

import net.sf.json.JSON;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import net.sf.json.xml.XMLSerializer;

import org.codehaus.jackson.map.ObjectMapper;


public final class ConvertUtil {
    private ConvertUtil() {
    }

    public static void main(String[] args) throws Exception {
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

        ObjectMapper mapper = new ObjectMapper();
        DrawingMetadata drawingMD = new DrawingMetadata();
        String title = ParseXML.getCharValueForANode(xmlString, "title");
        
        if (title != null) {
            drawingMD.setTitle(title);
        }
        
        String drawing = ParseXML.getCharValueForANode(xmlString, "altIdentifier","drawing");
        if (drawing != null) {
            drawingMD.setAltDrawingID(drawing);
        }
        
        String planTitle = ParseXML.getCharValueForANode(xmlString, "altTitle","planTitle");
        if (planTitle != null) {
            drawingMD.setAltPlanTitle(planTitle);
        }
        
        String printSize = ParseXML.getCharValueForANode(xmlString, "type","printSize");
        if (printSize != null) {
            drawingMD.setPrintSizeType(printSize);
        }
        
        String ideal = ParseXML.getCharValueForANode(xmlString, "type","ideal");
        if (ideal != null) {
            drawingMD.setIdealType(ideal);
        }
        
        String geoscale = ParseXML.getCharValueForANode(xmlString, "coverage","geoscale");
        if (geoscale != null) {
            drawingMD.setCoverageGeoscale(geoscale);
        }
        
        //Writer strWriter = new StringWriter();
        //mapper.writeValue(strWriter, drawingMD);
        //String drawingDataJSON = strWriter.toString();
        //System.out.println(drawingDataJSON);
        System.out.println(mapper.defaultPrettyPrintingWriter().writeValueAsString(drawingMD));
        //System.out.println(convertXML2JSON(xmlString));
    }
    
    public static String convertXML2JSON(String xml) throws Exception {
        String jsonString = null;
        XMLSerializer xmlSerializer = new XMLSerializer();
        xmlSerializer.setForceTopLevelObject(true);
        xmlSerializer.setTypeHintsEnabled(false);
        JSONObject json = (JSONObject) xmlSerializer.read(xml);
        jsonString = json.toString(4);
        return jsonString;
    }
    
    public static String convertJSON2XML(String aRootName, String aJson) throws Exception {
        String xmlString = null;
        XMLSerializer xmlSerializer = new XMLSerializer();
        xmlSerializer.setRootName(aRootName);
        JSON json = JSONSerializer.toJSON(aJson);
        xmlString = xmlSerializer.write(json);
        return xmlString;
    }
}
