package aegaron.service;

import aegaron.util.LoggableStatement;

import java.io.IOException;
import java.io.PrintStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;

import java.nio.charset.Charset;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.text.Collator;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.StringTokenizer;

import net.sf.json.JSON;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import net.sf.json.xml.XMLSerializer;

import org.apache.axis2.context.MessageContext;
import org.apache.commons.dbcp.PoolingDriver;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.pool.ObjectPool;

import org.codehaus.jackson.map.ObjectMapper;

import org.jdom.Attribute;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.jdom.xpath.XPath;


/**
 * The <code>AegaronService</code> is the service provider for Ancient Egyptian Architecture Online (Aegaron).
 * 
 * @author Henry Chiong
 */
public class AegaronService {
    private static final String CONNECTION_STRING = "jdbc:apache:commons:dbcp:aegaron";
         
    public Place[] listAllPlaces() {
        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
        ResultSet rset = null;
        PreparedStatement stmt = null;
        
        try {        
            // check db connection
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(CONNECTION_STRING);
            }           
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (conn != null) { 
            StringBuilder sb = new StringBuilder("SELECT desc_values.desc_qualifierid_fk, desc_values.desc_value ")
            .append("FROM desc_values, project_items ")
            .append("WHERE (project_items.divid_pk = desc_values.divid_fk) ")
            .append("AND (project_items.projectid_fk = ?) ")
            .append("AND (project_items.statusid_fk IN (?,?)) ")
            .append("AND (desc_values.desc_termid_fk = ?) ")           
            .append("AND (desc_values.desc_qualifierid_fk IN (?, ?)) ")
            .append("ORDER BY project_items.node_title, project_items.item_ark ASC");

            try {
                if (ILog.ENABLED) {
                    stmt = new LoggableStatement(conn, sb.toString());
                } else {
                    stmt = conn.prepareStatement(sb.toString());
                }

                stmt.clearParameters();
                stmt.setInt(1, AegaronConstants.PROJECT_ID);
                stmt.setInt(2, AegaronConstants.COMPLETED);
                stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
                stmt.setInt(4, AegaronConstants.ALT_IDENTIFIER);
                stmt.setInt(5, AegaronConstants.ALT_IDENTIFIER_UEEPLACE_ID);
                stmt.setInt(6, AegaronConstants.ALT_IDENTIFIER_UEEFEATURE_ID);

                if (ILog.ENABLED) {
                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                }

                rset = stmt.executeQuery();

                String qualifierId = "";
                String descValue = "";
                ArrayList<Place> list = new ArrayList<Place>();
                Place place;                
                while (rset.next()) {
                    qualifierId = rset.getString("DESC_QUALIFIERID_FK");                    
                    descValue = rset.getString("DESC_VALUE");

                    // create new Place
                    place = new Place();

                    // check if is a place or a feature
                    if ("10663".equals(qualifierId)){
                        place.setUeePlaceID(descValue);
                    } else {
                        place.setUeeFeatureID(descValue);
                    }
                    list.add(place);
                }

                // Display some pool statistics
                if (ILog.ENABLED) { printDriverStats(); }
                
                return list.toArray(new Place[list.size()]);
                
                
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { rset.close(); } catch(Exception e) { }
                try { stmt.close(); } catch(Exception e) { }
                try { conn.close(); } catch(Exception e) { }
            }
           
        }
        
        return null;
    }

//    public Image[] listAllDrawings() {
//        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
//        PreparedStatement stmt = null;
//        ResultSet rset = null;
//        
//        try {        
//            // check db connection
//            if (conn == null || conn.isClosed()) {
//                conn = DriverManager.getConnection(CONNECTION_STRING);
//            }           
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        
//        if (conn != null) {
//            StringBuilder sb = new StringBuilder("SELECT project_items.item_ark, project_items.node_title, content_files.file_name, TO_CHAR(content_files.create_date, 'MM/DD/YYYY HH:MI:SS AM') AS datetime, content_files.file_groupid_fk, ")
//            .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/type/featureType/text()').getstringval ()) AS feature_type, ")
//            .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altTitle/planTitle/text()').getstringval ()) AS plan_title, ")
//            .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/type/state/text()').getstringval ()) AS type_state, ")
//            .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/subject/place/text()').getstringval ()) AS subject_place, ")
//            .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altIdentifier/ueePlaceID/text()').getstringval ()) AS uee_placeid, ")
//            .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altIdentifier/drawing/text()').getstringval ()) AS drawing, ")
//            .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/description/view/text()').getstringval ()) AS description_view ")
//            .append("FROM project_items, content_files ")
//            .append("WHERE (project_items.divid_pk = content_files.divid_fk) ")
//            .append("AND (project_items.projectid_fk = ?) AND (project_items.statusid_fk IN (?,?)) ")
//            .append("AND (project_items.objectid_fk = ?) AND (content_files.file_use = ?) ")
//            .append("ORDER BY subject_place, plan_title, description_view, type_state, drawing ASC"); 
//            
//            try {
//                if (ILog.ENABLED) {
//                    stmt = new LoggableStatement(conn, sb.toString());
//                } else {
//                    stmt = conn.prepareStatement(sb.toString());
//                }
//
//                stmt.clearParameters();
//                stmt.setInt(1, AegaronConstants.PROJECT_ID);
//                stmt.setInt(2, AegaronConstants.COMPLETED);
//                stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
//                stmt.setInt(4, AegaronConstants.PLAN_OBJECT_ID);
//                stmt.setString(5, AegaronConstants.FILE_USE[1]);
//
//                if (ILog.ENABLED) {
//                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
//                }
//
//                rset = stmt.executeQuery();
//
//                Map<String, Image> map = new LinkedHashMap<String, Image>();
//                //Map<Long, String> dividMap = new HashMap<Long, String>();
//                String currentArk = "";                
//                //boolean isArkFound = false;                
//                String fname = "";
//                String createDate = "";
//                Image image;
//                /*List<String> periodList = new ArrayList<String>();
//                List<String> viewList = new ArrayList<String>();
//                List<String> drawingList = new ArrayList<String>();
//                List<String> stateList = new ArrayList<String>();
//                List<String> featureTypeList = new ArrayList<String>();
//                List<String> placeList = new ArrayList<String>();
//                */                
//                while (rset.next()) {
//                    //fname = rset.getString("FILE_NAME"); 
//                    //Long dividPk = rset.getLong("DIVID_PK");
//                    String ark = rset.getString("ITEM_ARK");
//                    String drawing = rset.getString("drawing");
//                    String planTitle = rset.getString("plan_title");
//                    String ueePlaceId = rset.getString("uee_placeid");
//                    String featureType = rset.getString("feature_type");
//                    String state = rset.getString("type_state");
//                    String place = rset.getString("place");
//                    String period = rset.getString("period");
//                    String descriptionView = rset.getString("description_view");
//                    int fileGroupID = rset.getInt("FILE_GROUPID_FK");
//                    
//                    /*if (!periodList.contains(period)) {
//                        periodList.add(period);
//                    }
//                    if (!viewList.contains(descriptionView)) {
//                        viewList.add(descriptionView);
//                    }
//                    if (!drawingList.contains(drawing)) {
//                        drawingList.add(drawing);
//                    }
//                    if (!stateList.contains(state)) {
//                        stateList.add(state);
//                    }
//                    if (!featureTypeList.contains(featureType)) {
//                        featureTypeList.add(featureType);
//                    }
//                    if (!placeList.contains(place)) {
//                        placeList.add(place);
//                    }*/
//                    
//                    
//                    //createDate = rset.getString("datetime");                    
//                    /*if (!dividMap.containsKey(dividPk)) {
//                        dividMap.put(dividPk, ark);
//                    }   */                  
//                                        
//                    if (!map.containsKey(ark)) {
//                        image = new Image();
//                        image.setId(ark);
//                        image.setUeePlaceID(ueePlaceId);
//                        image.setPlanTitle(planTitle);
//                        // update existing Image
//                        //image = map.get(ark);
//                        // keep track of previous ARK
//                        currentArk = ark;
//                        
//                        
//                        if (fname.endsWith(".tif") && fileGroupID == 1343) {                                                        
//                            image.setThumbnailURL(AegaronConstants.THUMB_BASE_URL+fname.replaceAll(".tif",".jpg"));
//                        }
//                        else if (fname.endsWith(".pdf") && fileGroupID == 1574) {
//                            image.setPdfThumbDateModified(createDate);
//                            image.setPdfThumbURL(AegaronConstants.PDF_BASE_URL+fname);
//                        }
//                        else if (fname.endsWith(".pdf") && fileGroupID == 1575) {
//                            image.setPdfDrawingLogDateModified(createDate);
//                            image.setPdfDrawingLogURL(AegaronConstants.PDF_BASE_URL+fname);
//                        } 
//                        else if (fname.endsWith(".pdf") && fileGroupID == 1576) {
//                            image.setPdfDrawing100DateModified(createDate);
//                            image.setPdfDrawing100URL(AegaronConstants.PDF_BASE_URL+fname);
//                        } 
//                        else if (fname.endsWith(".pdf") && fileGroupID == 1577) {
//                            image.setPdfDrawing250DateModified(createDate);
//                            image.setPdfDrawing250URL(AegaronConstants.PDF_BASE_URL+fname);
//                        } 
//                        else if (fname.endsWith(".pdf") && fileGroupID == 1578) {
//                            image.setPdfDrawing500DateModified(createDate);
//                            image.setPdfDrawing500URL(AegaronConstants.PDF_BASE_URL+fname);
//                        } 
//                        else if (fname.endsWith(".pdf") && fileGroupID == 1579) {
//                            image.setPdfDrawing2000DateModified(createDate);
//                            image.setPdfDrawing2000URL(AegaronConstants.PDF_BASE_URL+fname);
//                        } 
//                        else if (fname.endsWith(".pdf") && fileGroupID == 1580) {
//                            image.setPdfToPrintIdealDateModified(createDate);
//                            image.setPdfToPrintIdealURL(AegaronConstants.PDF_BASE_URL+fname);
//                        } 
//                        else if (fname.endsWith(".pdf") && fileGroupID == 1581) {
//                            image.setPdfPrintLetterDateModified(createDate);
//                            image.setPdfPrintLetterURL(AegaronConstants.PDF_BASE_URL+fname);
//                        }
//                        
//                        map.put(ark,image);
//                        
//                    } else {
//                        // update existing Image
//                        if (currentArk.equals(ark)) {
//                            System.out.println("IN ELSE OF WHILE LOOP 1ST CONDITION");
//                            continue;
//                        } else {
//                            System.out.println("IN ELSE OF WHILE LOOP 2ST CONDITION");
//                            // make current ark the previous one
//                            currentArk = ark;
//                        }
//                    }
////                    else {
////                        // crete new Image
////                        image = new Image();                        
////                        image.setId(ark);
////                        
////                        //String planTitle = rset.getString("plan_title");
////                        //String typeState = rset.getString("type_state");
////                        //String featureType = rset.getString("feature_type");
////                        //String subjectPlace = rset.getString("subject_place");
////                        //String ueePlaceId = rset.getString("uee_placeid");
////                        //String drawing = rset.getString("drawing");
////                        //String view = rset.getString("description_view");
////
////                        if (planTitle != null) {
////                            image.setPlanTitle( planTitle);
////                        } else {
////                            image.setPlanTitle("unknown");
////                        }
////                        if (ILog.ENABLED) {
////                            if (planTitle != null) {
////                                System.out.println("AltTitle.planTitle = " + planTitle);
////                            } else {
////                                System.out.println("AltTitle.planTitle is null.");
////                            }
////                        }
////                        
////                        if (state != null) {
////                            image.setState(state);
////                        } else {
////                            image.setState("unknown");
////                        }
////                        if (ILog.ENABLED) {
////                            if (state != null) {
////                                System.out.println("Type.state = " + state);
////                            } else {
////                                System.out.println("Type.state is null.");
////                            }
////                        }
////                        
////                        if (featureType != null) {
////                            image.setFeatureType(featureType);
////                        } else {
////                            image.setFeatureType("unknown");
////                        }
////                        if (ILog.ENABLED) {
////                            if (featureType != null) {
////                                System.out.println("Type.featureType = " + featureType);
////                            } else {
////                                System.out.println("Type.featureType is null.");
////                            }
////                        }
////                        
////                        if (place != null) {
////                            image.setPlace(place);
////                        } else {
////                            image.setPlace("unknown");
////                        }
////                        if (ILog.ENABLED) {
////                            if (place != null) {
////                                System.out.println("Subject.place = " + place);
////                            } else {
////                                System.out.println("Subject.place is null.");
////                            }
////                        }
////                        
////                        if (ueePlaceId != null) {
////                            image.setUeePlaceID(ueePlaceId);
////                        } else {
////                            image.setUeePlaceID("unknown");
////                        }
////                        if (ILog.ENABLED) {
////                            if (ueePlaceId != null) {
////                                System.out.println("altIdentifier.ueePlaceID = " + ueePlaceId);
////                            } else {
////                                System.out.println("altIdentifier.ueePlaceID is null.");
////                            }
////                        }
////                        
////                        if (drawing != null) {
////                            image.setDrawing(drawing);
////                        } else {
////                            image.setDrawing("unknown");
////                        }
////                        if (ILog.ENABLED) {
////                            if (drawing != null) {
////                                System.out.println("altIdentifier.drawing = " + drawing);
////                            } else {
////                                System.out.println("altIdentifier.drawing is null.");
////                            }
////                        }
////                        
////                        if (descriptionView != null) {
////                            image.setView(descriptionView);
////                        } else {
////                            image.setView("unknown");
////                        }
////                        if (ILog.ENABLED) {
////                            if (descriptionView != null) {
////                                System.out.println("Description.view = " + descriptionView);
////                            } else {
////                                System.out.println("Description.view is null.");
////                            }
////                        }
////                        
////                        /*if (fname.endsWith(".tif")) {                            
////                            image.setImageDateModified(createDate);
////                            image.setThumbnailURL(AegaronConstants.THUMB_BASE_URL+fname.replaceAll("master.tif","thumbnail.jpg"));
////                        }
////                        else if (fname.endsWith(".pdf") && fileGroupID == 1574) {
////                            image.setPdfThumbDateModified(createDate);
////                            image.setPdfThumbURL(AegaronConstants.PDF_BASE_URL+fname);
////                        }
////                        else if (fname.endsWith(".pdf") && fileGroupID == 1575) {
////                            image.setPdfDrawingLogDateModified(createDate);
////                            image.setPdfDrawingLogURL(AegaronConstants.PDF_BASE_URL+fname);
////                        } 
////                        else if (fname.endsWith(".pdf") && fileGroupID == 1576) {
////                            image.setPdfDrawing100DateModified(createDate);
////                            image.setPdfDrawing100URL(AegaronConstants.PDF_BASE_URL+fname);
////                        } 
////                        else if (fname.endsWith(".pdf") && fileGroupID == 1577) {
////                            image.setPdfDrawing250DateModified(createDate);
////                            image.setPdfDrawing250URL(AegaronConstants.PDF_BASE_URL+fname);
////                        } 
////                        else if (fname.endsWith(".pdf") && fileGroupID == 1578) {
////                            image.setPdfDrawing500DateModified(createDate);
////                            image.setPdfDrawing500URL(AegaronConstants.PDF_BASE_URL+fname);
////                        } 
////                        else if (fname.endsWith(".pdf") && fileGroupID == 1579) {
////                            image.setPdfDrawing2000DateModified(createDate);
////                            image.setPdfDrawing2000URL(AegaronConstants.PDF_BASE_URL+fname);
////                        } 
////                        else if (fname.endsWith(".pdf") && fileGroupID == 1580) {
////                            image.setPdfToPrintIdealDateModified(createDate);
////                            image.setPdfToPrintIdealURL(AegaronConstants.PDF_BASE_URL+fname);
////                        } 
////                        else if (fname.endsWith(".pdf") && fileGroupID == 1581) {
////                            image.setPdfPrintLetterDateModified(createDate);
////                            image.setPdfPrintLetterURL(AegaronConstants.PDF_BASE_URL+fname);
////                        } */
////                        
////                        map.put(ark, image);                        
////                        
////                    }
//
//                }
//                
//                // Display some pool statistics
//                if (ILog.ENABLED) { printDriverStats(); }
//                
//                return map.values().toArray(new Image[map.size()]);
//            } catch (Exception e) {
//                e.printStackTrace();
//            } finally {
//                try { rset.close(); } catch(Exception e) { }
//                try { stmt.close(); } catch(Exception e) { }
//                try { conn.close(); } catch(Exception e) { }
//            }
//        }
//                
//        return null;
//    }*/

     public Image[] listAllDrawings() {
         Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
         PreparedStatement stmt = null;
         ResultSet rset = null;
         
         try {        
             // check db connection
             if (conn == null || conn.isClosed()) {
                 conn = DriverManager.getConnection(CONNECTION_STRING);
             }           
         } catch (Exception e) {
             e.printStackTrace();
         }
         
         if (conn != null) {
             StringBuilder sb = new StringBuilder("SELECT project_items.item_ark, content_files.file_name, content_files.file_groupid_fk, ")
             .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/type/featureType/text()').getstringval ()) AS feature_type, ")
             .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altTitle/planTitle/text()').getstringval ()) AS plan_title, ")
             .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/type/state/text()').getstringval ()) AS type_state, ")
             .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/subject/place/text()').getstringval ()) AS subject_place, ")
             .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/subject/period/text()').getstringval ()) AS subject_period, ")
             .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altIdentifier/ueePlaceID/text()').getstringval ()) AS uee_placeid, ")
             .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altIdentifier/drawing/text()').getstringval ()) AS drawing, ")
             .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/description/view/text()').getstringval ()) AS description_view ")
             .append("FROM project_items, content_files ")
             .append("WHERE (project_items.divid_pk = content_files.divid_fk) ")
             .append("AND (project_items.projectid_fk = ?) AND (project_items.statusid_fk IN (?,?)) ")
             .append("AND (project_items.objectid_fk = ?) AND (content_files.file_use = ?) ")
             .append("ORDER BY subject_place, plan_title, description_view, type_state, drawing ASC"); 
    
             try {
                 if (ILog.ENABLED) {
                     stmt = new LoggableStatement(conn, sb.toString());
                 } else {
                     stmt = conn.prepareStatement(sb.toString());
                 }
    
                 stmt.clearParameters();
                 stmt.setInt(1, AegaronConstants.PROJECT_ID);
                 stmt.setInt(2, AegaronConstants.COMPLETED);
                 stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
                 stmt.setInt(4, AegaronConstants.PLAN_OBJECT_ID);
                 stmt.setString(5, AegaronConstants.FILE_USE[1]);
    
                 if (ILog.ENABLED) {
                     System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                 }
    
                 rset = stmt.executeQuery();
    
                 Map<String, Image> map = new LinkedHashMap<String, Image>();
                 String ark = "";
                 String fname = "";
                 Image image;
                 List<String> subjectPeriodList = new ArrayList<String>();
                 List<String> descriptionViewList = new ArrayList<String>();
                 
                 while (rset.next()) {
                     fname = rset.getString("FILE_NAME"); 
                     ark = rset.getString("ITEM_ARK");                    
                     int fileGroupID = rset.getInt("FILE_GROUPID_FK");
                     
                     if (map.containsKey(ark)) {
                         // update existing Image
                         image = map.get(ark);
    
                         if (fname.endsWith(".tif")) {                            
                             image.setThumbnailUrl(AegaronConstants.THUMB_BASE_URL+fname.replaceAll(".tif",".jpg"));
                         }
                         else if (fname.endsWith(".pdf") && fileGroupID == 1574) {
                             image.setPdfThumbUrl(AegaronConstants.PDF_BASE_URL+fname);
                         }
                         else if (fname.endsWith(".pdf") && fileGroupID == 1575) {
                             image.setPdfDrawingLogUrl(AegaronConstants.PDF_BASE_URL+fname);
                         }
                         else if (fname.endsWith(".dwg") && fileGroupID == 1690) {
                             image.setCadDrawingUrl(AegaronConstants.CAD_BASE_URL+fname);
                         }
                         else if (fname.endsWith(".png") && fileGroupID == 1705) {
                             image.setThumbToScaleUrl(AegaronConstants.PNG_BASE_URL+fname);
                         }
                         
                         map.put(ark,image);
                         
                     } else {
                         // crete new Image
                         image = new Image();                        
                         image.setId(ark);
                         String planTitle = rset.getString("plan_title");
                         String typeState = rset.getString("type_state");
                         String featureType = rset.getString("feature_type");
                         String subjectPlace = rset.getString("subject_place");
                         String subjectPeriod = rset.getString("subject_period");
                         String ueePlaceId = rset.getString("uee_placeid");
                         String drawing = rset.getString("drawing");
                         String descriptionView = rset.getString("description_view");
    
                         if (planTitle != null) {
                             image.setPlanTitle( planTitle);
                         } else {
                             image.setPlanTitle("unknown");
                         }
                         if (ILog.ENABLED) {
                             if (planTitle != null) {
                                 System.out.println("AltTitle.planTitle = " + planTitle);
                             } else {
                                 System.out.println("AltTitle.planTitle is null.");
                             }
                         }
                         
                         if (typeState != null) {
                             image.setState(typeState);
                         } else {
                             image.setState("unknown");
                         }
                         if (ILog.ENABLED) {
                             if (typeState != null) {
                                 System.out.println("Type.state = " + typeState);
                             } else {
                                 System.out.println("Type.state is null.");
                             }
                         }
                         
                         if (featureType != null) {
                             image.setFeatureType(featureType);
                         } else {
                             image.setFeatureType("unknown");
                         }
                         if (ILog.ENABLED) {
                             if (featureType != null) {
                                 System.out.println("Type.featureType = " + featureType);
                             } else {
                                 System.out.println("Type.featureType is null.");
                             }
                         }
                         
                         if (subjectPlace != null) {
                             image.setPlace(subjectPlace);
                         } else {
                             image.setPlace("unknown");
                         }
                         if (ILog.ENABLED) {
                             if (subjectPlace != null) {
                                 System.out.println("Subject.place = " + subjectPlace);
                             } else {
                                 System.out.println("Subject.place is null.");
                             }
                         }
                         
                         if (subjectPeriod != null) {
                             if (subjectPeriod.contains("Late Antiquity")) {
                                 subjectPeriodList.add("Late Antiquity");
                             }
                             if (subjectPeriod.contains("Late Period")) {
                                 subjectPeriodList.add("Late Period");
                             }
                             if (subjectPeriod.contains("Middle Kingdom")) {
                                 subjectPeriodList.add("Middle Kingdom");
                             }
                             if (subjectPeriod.contains("New Kingdom")) {
                                 subjectPeriodList.add("New Kingdom");
                             }
                             if (subjectPeriod.contains("Old Kingdom")) {
                                 subjectPeriodList.add("Old Kingdom");
                             }
                             if (subjectPeriod.contains("Ptolemaic Period")) {
                                 subjectPeriodList.add("Ptolemaic Period");
                             }
                             if (subjectPeriod.contains("Roman Period")) {
                                 subjectPeriodList.add("Roman Period");
                             }
                             
                             if (subjectPeriodList.size() > 1) {
                                 image.setPeriod(StringUtils.join(subjectPeriodList, '/'));
                             } else {
                                 image.setPeriod(subjectPeriod);
                             }
                             
                             subjectPeriodList.clear();
                             
                         } else {
                             image.setPeriod("unknown");
                         }
                         if (ILog.ENABLED) {
                             if (subjectPeriod != null) {
                                 System.out.println("Subject.period = " + subjectPeriod);
                             } else {
                                 System.out.println("Subject.period is null.");
                             }
                         }
                         
                         if (ueePlaceId != null) {
                             image.setUeePlaceID(ueePlaceId);
                         } else {
                             image.setUeePlaceID("unknown");
                         }
                         if (ILog.ENABLED) {
                             if (ueePlaceId != null) {
                                 System.out.println("altIdentifier.ueePlaceID = " + ueePlaceId);
                             } else {
                                 System.out.println("altIdentifier.ueePlaceID is null.");
                             }
                         }
                         
                         if (drawing != null) {
                             image.setDrawing(drawing);
                         } else {
                             image.setDrawing("unknown");
                         }
                         if (ILog.ENABLED) {
                             if (drawing != null) {
                                 System.out.println("altIdentifier.drawing = " + drawing);
                             } else {
                                 System.out.println("altIdentifier.drawing is null.");
                             }
                         }
                         
                         if (descriptionView != null) {
                             if (descriptionView.equalsIgnoreCase("detailsection")){
                                 descriptionViewList.add("detail");
                                 descriptionViewList.add("section");
                             } else {
                                 if (StringUtils.contains(descriptionView,"detail")) {
                                     descriptionViewList.add("detail");
                                 }
                                 if (StringUtils.contains(descriptionView,"elevation")) {
                                     descriptionViewList.add("elevation");
                                 }
                                 if (StringUtils.contains(descriptionView,"section A-A")) {
                                     descriptionViewList.add("section A-A");
                                 }
                                 if (StringUtils.contains(descriptionView,"section B-B")) {
                                     descriptionViewList.add("section B-B");
                                 }
                                 if (StringUtils.contains(descriptionView,"section C-C")) {
                                     descriptionViewList.add("section C-C");
                                 }
                                 if (StringUtils.contains(descriptionView,"general plan")) {
                                     descriptionViewList.add("general plan");
                                 }
                                 if (StringUtils.contains(descriptionView,"top view")) {
                                     descriptionViewList.add("top view");
                                 }
                                 if (StringUtils.contains(descriptionView,"east elevation")) {
                                     descriptionViewList.add("east elevation");
                                 }
                                 if (StringUtils.contains(descriptionView,"south elevation")) {
                                     descriptionViewList.add("south elevation");
                                 }
                                 if (StringUtils.contains(descriptionView,"west elevation")) {
                                     descriptionViewList.add("west elevation");
                                 }
                             }
                             
                             if (descriptionViewList.size() > 1) {
                                 image.setView(StringUtils.join(descriptionViewList, '/'));
                             } else {
                                 image.setView(descriptionView);
                             }
                             
                             descriptionViewList.clear();
                             
                         } else {
                             image.setView("unknown");
                         }
                         if (ILog.ENABLED) {
                             if (descriptionView != null) {
                                 System.out.println("Description.view = " + descriptionView);
                             } else {
                                 System.out.println("Description.view is null.");
                             }
                         }
                         
                         if (fname.endsWith(".tif")) {                            
                             image.setThumbnailUrl(AegaronConstants.THUMB_BASE_URL+fname.replaceAll(".tif",".jpg"));
                         }
                         else if (fname.endsWith(".pdf") && fileGroupID == 1574) {
                             image.setPdfThumbUrl(AegaronConstants.PDF_BASE_URL+fname);
                         }
                         else if (fname.endsWith(".pdf") && fileGroupID == 1575) {
                             image.setPdfDrawingLogUrl(AegaronConstants.PDF_BASE_URL+fname);
                         } 
                         else if (fname.endsWith(".dwg") && fileGroupID == 1690) {
                             image.setCadDrawingUrl(AegaronConstants.CAD_BASE_URL+fname);
                         }
                         else if (fname.endsWith(".png") && fileGroupID == 1705) {
                             image.setThumbToScaleUrl(AegaronConstants.PNG_BASE_URL+fname);
                         }
                         map.put(ark, image);                        
                         
                     }
    
                 }
                 
                 // Display some pool statistics
                 if (ILog.ENABLED) { printDriverStats(); }
                 
                 return map.values().toArray(new Image[map.size()]);
             } catch (Exception e) {
                 e.printStackTrace();
             } finally {
                 try { rset.close(); } catch(Exception e) { }
                 try { stmt.close(); } catch(Exception e) { }
                 try { conn.close(); } catch(Exception e) { }
             }
         }
                 
         return null;
     }

    public String listAllEnglishTerms() {              
            
        // get all the classification of terms
        String[] classifications = listAllClassifications();
        
        // root elements 
        Element terms = new Element("terms");
        Document document = new Document(terms);
            
            // iterate through each classification
            for (String s: classifications) {
                
                Element category = new Element("category");
                category.setAttribute(new Attribute("classification", s));
                Element term = new Element("term");
                category.addContent(term);
                
                Term[] termArray = getAllTerms(s, "English");
                
                for (Term t: termArray) {
                    if (t.getPreferredTerm() != null) {
                        Element preferred = new Element("preferred");
                        preferred.setAttribute(new Attribute("lang", "en"));
                        preferred.setAttribute(new Attribute("arkid", t.getItemArk()));
                        preferred.setText(t.getPreferredTerm());
                        term.addContent(preferred);
                    }
                    if (t.getAlternateTerm() != null) {
                        Element alternate = new Element("alternate");
                        alternate.setAttribute(new Attribute("lang", "en"));
                        alternate.setAttribute(new Attribute("arkid", t.getItemArk()));
                        alternate.setText(t.getAlternateTerm());
                        term.addContent(alternate);
                    }
                }
                
                document.getRootElement().addContent(category);
            }
                             
            XMLOutputter xmlOutputer = new XMLOutputter();
                
            if (ILog.ENABLED) {
                try {
                    // pretty format the output
                    xmlOutputer.setFormat(Format.getPrettyFormat());
                    xmlOutputer.output(document, System.out);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
                
        return xmlOutputer.outputString(document);

    }
    
    public String listAllArabicTerms() {              
            
        // get all the classification of terms
        String[] classifications = listAllClassifications();
        
        // root elements 
        Element terms = new Element("terms");
        Document document = new Document(terms);
            
            // iterate through each classification
            for (String s: classifications) {
                
                Element category = new Element("category");
                category.setAttribute(new Attribute("classification", s));
                Element term = new Element("term");
                category.addContent(term);
                
                Term[] termArray = getAllTerms(s, "Arabic");
                
                for (Term t: termArray) {
                    if (t.getPreferredTerm() != null) {
                        Element preferred = new Element("preferred");
                        preferred.setAttribute(new Attribute("lang", "ar"));
                        preferred.setAttribute(new Attribute("arkid", t.getItemArk()));
                        preferred.setText(t.getPreferredTerm());
                        term.addContent(preferred);
                    }
                    if (t.getAlternateTerm() != null) {
                        Element alternate = new Element("alternate");
                        alternate.setAttribute(new Attribute("lang", "ar"));
                        alternate.setAttribute(new Attribute("arkid", t.getItemArk()));
                        alternate.setText(t.getAlternateTerm());
                        term.addContent(alternate);
                    }
                }
                
                document.getRootElement().addContent(category);
            }
                             
            XMLOutputter xmlOutputer = new XMLOutputter();
                
            if (ILog.ENABLED) {
                try {
                    // pretty format the output
                    xmlOutputer.setFormat(Format.getPrettyFormat());
                    xmlOutputer.output(document, System.out);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
                
        return xmlOutputer.outputString(document);

    }
    
    public String listAllGermanTerms() {              
            
        // get all the classification of terms
        String[] classifications = listAllClassifications();
        
        // root elements 
        Element terms = new Element("terms");
        Document document = new Document(terms);
            
            // iterate through each classification
            for (String s: classifications) {
                
                Element category = new Element("category");
                category.setAttribute(new Attribute("classification", s));
                Element term = new Element("term");
                category.addContent(term);
                
                Term[] termArray = getAllTerms(s, "German");
                
                for (Term t: termArray) {
                    if (t.getPreferredTerm() != null) {
                        Element preferred = new Element("preferred");
                        preferred.setAttribute(new Attribute("lang", "de"));
                        preferred.setAttribute(new Attribute("arkid", t.getItemArk()));
                        preferred.setText(t.getPreferredTerm());
                        term.addContent(preferred);
                    }
                    if (t.getAlternateTerm() != null) {
                        Element alternate = new Element("alternate");
                        alternate.setAttribute(new Attribute("lang", "de"));
                        alternate.setAttribute(new Attribute("arkid", t.getItemArk()));
                        alternate.setText(t.getAlternateTerm());
                        term.addContent(alternate);
                    }
                }
                
                document.getRootElement().addContent(category);
            }
                             
            XMLOutputter xmlOutputer = new XMLOutputter();
                
            if (ILog.ENABLED) {
                try {
                    // pretty format the output
                    xmlOutputer.setFormat(Format.getPrettyFormat());
                    xmlOutputer.output(document, System.out);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
                
        return xmlOutputer.outputString(document);

    }


    public Site[] listAllSites() {
        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
        PreparedStatement stmt = null;
        ResultSet rset = null;
        
        try {        
            // check db connection
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(CONNECTION_STRING);
            }           
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (conn != null) {
             StringBuilder sb = new StringBuilder("SELECT project_items.item_ark, project_items.node_title, ")
             .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/subject/place/text()').getstringval ()) AS SUBJECT_PLACE, " )
             .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altIdentifier/ueePlaceID/text()').getstringval ()) AS UEE_PLACEID ")
             .append("FROM project_items WHERE (project_items.projectid_fk = ?) ")
             .append("AND (project_items.statusid_fk IN (?,?)) AND (project_items.objectid_fk = ?) ")
             .append("ORDER BY SUBJECT_PLACE ASC");

            try {
                if (ILog.ENABLED) {
                    stmt = new LoggableStatement(conn, sb.toString());
                } else {
                    stmt = conn.prepareStatement(sb.toString());
                }

                stmt.clearParameters();
                stmt.setInt(1, AegaronConstants.PROJECT_ID);
                stmt.setInt(2, AegaronConstants.COMPLETED);
                stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
                stmt.setInt(4, AegaronConstants.SITE_OBJECT_ID);

                if (ILog.ENABLED) {
                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                }

                rset = stmt.executeQuery();
                
                ArrayList<Site> list = new ArrayList<Site>();
                String ark = "";
                String nodeTitle = "";
                String subjectPlace = "";
                String ueePlaceId = "";
                
                while (rset.next()) {                   
                    ark = rset.getString("ITEM_ARK");                    
                    nodeTitle = rset.getString("NODE_TITLE"); 
                    subjectPlace = rset.getString("SUBJECT_PLACE");
                    ueePlaceId = rset.getString("UEE_PLACEID");

                    // create new Site
                    Site site = new Site();
                    site.setId(ark);
                    site.setTitle(nodeTitle);
                    site.setSubjectPlace(subjectPlace);
                    site.setUeePlaceId(ueePlaceId);

                    list.add(site);

                }
                
                // Display some pool statistics
                if (ILog.ENABLED) { printDriverStats(); }
                
                return list.toArray(new Site[list.size()]);
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { rset.close(); } catch(Exception e) { }
                try { stmt.close(); } catch(Exception e) { }
                try { conn.close(); } catch(Exception e) { }
            }
        }
                
        return null;
    }

    public Plan[] listAllPlans() {
        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
        PreparedStatement stmt = null;
        ResultSet rset = null;
        
        try {        
            // check db connection
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(CONNECTION_STRING);
            }           
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (conn != null) {
            StringBuilder sb = new StringBuilder("SELECT project_items.item_ark, project_items.node_title, project_items.desc_clob, content_files.file_name, content_files.file_groupid_fk ")
            .append("FROM project_items ")
            .append("LEFT OUTER JOIN content_files ON project_items.divid_pk = content_files.divid_fk ") 
            .append("WHERE (project_items.projectid_fk = ? ") 
            .append("AND project_items.statusid_fk IN (?,?) ") 
            .append("AND project_items.objectid_fk = ?) ") 
            .append("AND (content_files.file_use = ?) ")
            .append("ORDER BY project_items.node_title ASC"); 

            try {
                if (ILog.ENABLED) {
                    stmt = new LoggableStatement(conn, sb.toString());
                } else {
                    stmt = conn.prepareStatement(sb.toString());
                }

                stmt.clearParameters();
                stmt.setInt(1, AegaronConstants.PROJECT_ID);
                stmt.setInt(2, AegaronConstants.COMPLETED);
                stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
                stmt.setInt(4, AegaronConstants.PLAN_OBJECT_ID);
                stmt.setString(5, AegaronConstants.FILE_USE[1]);

                if (ILog.ENABLED) {
                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                }

                rset = stmt.executeQuery();

                Map<String, Plan> map = new LinkedHashMap<String, Plan>();
                Plan plan;
                                
                while (rset.next()) {
                    String ark = rset.getString("ITEM_ARK");
                    String title = rset.getString("NODE_TITLE");
                    String fname = rset.getString("FILE_NAME");
                    String xmlMetadata = rset.getString("DESC_CLOB");
                    int fileGroupID = rset.getInt("FILE_GROUPID_FK");
                                        
                    if (!map.containsKey(ark)) {
                        // create it
                        plan = new Plan();
                        plan.setId(ark);
                        plan.setTitle(title);
                        plan.setXmlMetadata(xmlMetadata);
                        
                        // Image
                        if (fname.endsWith(".tif") && fileGroupID == 1343) {                            
                            plan.setThumbnailUrl(AegaronConstants.THUMB_BASE_URL+fname.replaceAll(".tif",".jpg"));
                        }
                        // PDF Thumb
                        else if (fname.endsWith(".pdf") && fileGroupID == 1574) {
                            plan.setPdfThumbUrl(AegaronConstants.PDF_BASE_URL+fname);
                        }
                        // PDF Drawing Log
                        else if (fname.endsWith(".pdf") && fileGroupID == 1575) {
                            plan.setPdfDrawingLogUrl(AegaronConstants.PDF_BASE_URL+fname);
                        }
                        // CAD Drawing
                        else if (fname.endsWith(".dwg") && fileGroupID == 1690) {
                            plan.setCadDrawingUrl(AegaronConstants.CAD_BASE_URL+fname);
                        }
                        // PNG Thumb to Scale
                        else if (fname.endsWith(".png") && fileGroupID == 1705) {
                            plan.setThumbToScaleUrl(AegaronConstants.PNG_BASE_URL+fname);
                        }
                        
                        map.put(ark,plan);
                        
                    } else {
                        // upate it
                        plan = map.get(ark);
                        
                        // Image
                        if (fname.endsWith(".tif") && fileGroupID == 1343) {                            
                            plan.setThumbnailUrl(AegaronConstants.THUMB_BASE_URL+fname.replaceAll(".tif",".jpg"));
                        }
                        // PDF Thumb
                        else if (fname.endsWith(".pdf") && fileGroupID == 1574) {
                            plan.setPdfThumbUrl(AegaronConstants.PDF_BASE_URL+fname);
                        }
                        // PDF Drawing Log
                        else if (fname.endsWith(".pdf") && fileGroupID == 1575) {
                            plan.setPdfDrawingLogUrl(AegaronConstants.PDF_BASE_URL+fname);
                        }
                        // CAD Drawing
                        else if (fname.endsWith(".dwg") && fileGroupID == 1690) {
                            plan.setCadDrawingUrl(AegaronConstants.CAD_BASE_URL+fname);
                        }
                        // PNG Thumb to Scale
                        else if (fname.endsWith(".png") && fileGroupID == 1705) {
                            plan.setThumbToScaleUrl(AegaronConstants.PNG_BASE_URL+fname);
                        }
                        
                    }

                }
                
                // Display some pool statistics
                if (ILog.ENABLED) { printDriverStats(); }
                
                return map.values().toArray(new Plan[map.size()]);
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { rset.close(); } catch(Exception e) { }
                try { stmt.close(); } catch(Exception e) { }
                try { conn.close(); } catch(Exception e) { }
            }
        }
                
        return null;
    }

    public String listAllTerms() {     
      Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
      PreparedStatement stmt = null;
      ResultSet rset = null;
      
      // root elements 
      Element terms = new Element("terms");
      Document document = new Document(terms);
      
      try {        
          // check db connection
          if (conn == null || conn.isClosed()) {
              //System.out.println("Reconnecting...");
              conn = DriverManager.getConnection(CONNECTION_STRING);
              //System.out.println("Done");
          }           
      } catch (Exception e) {
          e.printStackTrace();
      }
      
      if (conn != null) {
          StringBuilder sb = new StringBuilder("SELECT project_items.node_title, desc_values.desc_value, desc_values.desc_termid_fk, desc_values.desc_qualifierid_fk ")
          .append("FROM project_items LEFT OUTER JOIN desc_values ON project_items.divid_pk = desc_values.divid_fk ")
          .append("WHERE project_items.projectid_fk = ? ")
          .append("AND project_items.statusid_fk IN (?,?) ") 
          .append("AND project_items.objectid_fk = ? ") 
          .append("AND desc_values.desc_termid_fk IN (?,?) ") 
          .append("AND (desc_values.desc_qualifierid_fk IN (?,?,?,?,?) ") 
          .append("OR (desc_values.desc_qualifierid_fk IS NULL)) ") 
          .append("ORDER BY NLSSORT(desc_values.desc_value,'NLS_SORT=BINARY_CI')");
                       
          try {
              if (ILog.ENABLED) {
                  stmt = new LoggableStatement(conn, sb.toString());
              } else {
                  stmt = conn.prepareStatement(sb.toString());
              }
    
              stmt.clearParameters();
              stmt.setInt(1, AegaronConstants.PROJECT_ID);
              stmt.setInt(2, AegaronConstants.COMPLETED);
              stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
              stmt.setInt(4, AegaronConstants.TERM_OBJECT_ID);
              stmt.setInt(5, AegaronConstants.ALT_TITLE);
              stmt.setInt(6, AegaronConstants.TITLE);
              stmt.setInt(7, AegaronConstants.ARABIC_ALTERNATE);
              stmt.setInt(8, AegaronConstants.GERMAN_ALTERNATE);
              stmt.setInt(9, AegaronConstants.ENGLISH_ALTERNATE);
              stmt.setInt(10, AegaronConstants.ARABIC_PREFERRED);
              stmt.setInt(11, AegaronConstants.GERMAN_PREFERRED);
              
              if (ILog.ENABLED) {
                  System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
              }
    
              rset = stmt.executeQuery();
              
              Element term = null;
              
              while (rset.next()) {
                  //String ark = rset.getString("ITEM_ARK");
                  String nodeTitle = rset.getString("NODE_TITLE");                    
                  String descValue = rset.getString("DESC_VALUE");
                  String descTermId = rset.getString("DESC_TERMID_FK");
                  String descQualifierId = rset.getString("DESC_QUALIFIERID_FK");
                  
                  term = new Element("term");
                  
                  // English_preferred 
                  if ("3721".equals(descTermId) && descQualifierId == null) {
                      Element title = new Element("title");
                      title.setAttribute(new Attribute("lang", "en"));
                      title.setAttribute(new Attribute("preferred", "true"));
                      title.setText(nodeTitle);
                      term.addContent(title);
                  }
                  // English_alternate
                  else if ("3720".equals(descTermId) && "13512".equals(descQualifierId)) {
                      Element altTitle = new Element("alttitle");
                      altTitle.setAttribute(new Attribute("lang", "en"));
                      altTitle.setAttribute(new Attribute("preferred", "false"));
                      altTitle.setText(descValue);
                      term.addContent(altTitle);
                  }
                  // German_preferred
                  else if ("3720".equals(descTermId) && "13516".equals(descQualifierId)) {
                      Element altTitle = new Element("alttitle");
                      altTitle.setAttribute(new Attribute("lang", "de"));
                      altTitle.setAttribute(new Attribute("preferred", "true"));
                      altTitle.setText(descValue);
                      term.addContent(altTitle);
                  }
                  // German_alternate
                  else if ("3720".equals(descTermId) && "13511".equals(descQualifierId)) {
                      Element altTitle = new Element("alttitle");
                      altTitle.setAttribute(new Attribute("lang", "de"));
                      altTitle.setAttribute(new Attribute("preferred", "false"));
                      altTitle.setText(descValue);
                      term.addContent(altTitle);
                  }
                  // Arabic_preferred
                  else if ("3720".equals(descTermId) && "13515".equals(descQualifierId)) {
                      Element altTitle = new Element("alttitle");
                      altTitle.setAttribute(new Attribute("lang", "ar"));
                      altTitle.setAttribute(new Attribute("preferred", "true"));
                      altTitle.setText(descValue);
                      term.addContent(altTitle);
                  }
                  // Arabic_alternate
                  else if ("3720".equals(descTermId) && "13510".equals(descQualifierId)) {
                      Element altTitle = new Element("alttitle");
                      altTitle.setAttribute(new Attribute("lang", "ar"));
                      altTitle.setAttribute(new Attribute("preferred", "false"));
                      altTitle.setText(descValue);
                      term.addContent(altTitle);
                  }
                  
                  terms.addContent(term);
                  
              }
                            
              XMLOutputter xmlOutputer = new XMLOutputter();
                  
              if (ILog.ENABLED) {
                  try {
                      // pretty format the output
                      xmlOutputer.setFormat(Format.getPrettyFormat());
                      xmlOutputer.output(document, System.out);
                  } catch (IOException e) {
                      e.printStackTrace();
                  }
              }
                  
              return xmlOutputer.outputString(document);
              
          } catch (Exception e) {
              e.printStackTrace();
          } finally {
              try { rset.close(); } catch(Exception e) { }
              try { stmt.close(); } catch(Exception e) { }
              try { conn.close(); } catch(Exception e) { }
          }
      }
              
      return null;
    }

    public Plan[] getPlanGeospatialMetadataByBoundingBox(final String northBL, final String southBL, final String eastBL, final String westBL) {
        if (northBL == null || "".equals(northBL.trim())) {
            return null;    
        }
        if (southBL == null || "".equals(southBL.trim())) {
            return null;    
        }        
        if (eastBL == null || "".equals(eastBL.trim())) {
            return null;    
        }
        if (westBL == null || "".equals(westBL.trim())) {
            return null;    
        }
        
        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
        PreparedStatement stmt = null;
        ResultSet rset = null;
        
        try {        
            // check db connection
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(CONNECTION_STRING);
            }           
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (conn != null) {
            StringBuilder sb = new StringBuilder("SELECT project_items.item_ark, project_items.node_title, project_items.desc_clob, xmltype(project_items.desc_clob).extract('//drawing/text()').getStringVal() as drawing, content_files.file_name, content_files.file_groupid_fk ")
            .append("FROM project_items LEFT OUTER JOIN content_files ON project_items.divid_pk = content_files.divid_fk ")
            .append("WHERE (project_items.projectid_fk = ? AND project_items.statusid_fk IN (?, ?) ")
            .append("AND project_items.objectid_fk = ?) AND (content_files.file_use = ?) ")
            .append("AND xmltype(desc_clob).extract('//latitude/text()').getNumberVal() > ").append(southBL)
            .append(" AND xmltype(desc_clob).extract('//latitude/text()').getNumberVal() < ").append(northBL)
            .append(" AND xmltype(desc_clob).extract('//longitude/text()').getNumberVal() > ").append(westBL)
            .append(" AND xmltype(desc_clob).extract('//longitude/text()').getNumberVal() < ").append(eastBL)
            .append(" ORDER BY project_items.node_title ASC"); 

            try {
                if (ILog.ENABLED) {
                    stmt = new LoggableStatement(conn, sb.toString());
                } else {
                    stmt = conn.prepareStatement(sb.toString());
                }

                stmt.clearParameters();
                stmt.setInt(1, AegaronConstants.PROJECT_ID);
                stmt.setInt(2, AegaronConstants.COMPLETED);
                stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
                stmt.setInt(4, AegaronConstants.PLAN_OBJECT_ID);
                stmt.setString(5, AegaronConstants.FILE_USE[1]);

                if (ILog.ENABLED) {
                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                    System.out.println("nortBL=" + northBL);
                    System.out.println("southBL=" + southBL);
                    System.out.println("eastBL=" + eastBL);
                    System.out.println("westBL=" + westBL);
                }

                rset = stmt.executeQuery();

                Map<String, Plan> map = new LinkedHashMap<String, Plan>();
                Plan plan;
                                
                while (rset.next()) {
                    String ark = rset.getString("ITEM_ARK");
                    String title = rset.getString("NODE_TITLE");
                    String fname = rset.getString("FILE_NAME");
                    String xmlMetadata = rset.getString("DESC_CLOB");
                    int fileGroupID = rset.getInt("FILE_GROUPID_FK");
                    String drawingNo = rset.getString("DRAWING");
                    
                    if (!map.containsKey(ark)) {
                        // create it
                        plan = new Plan();
                        plan.setId(ark);
                        plan.setTitle(title);
                        plan.setXmlMetadata(xmlMetadata);
                        plan.setDrawingNumber(drawingNo);
                                                
                        // Image
                        if (fname.endsWith(".tif") && fileGroupID == 1343) {                            
                            plan.setThumbnailUrl(AegaronConstants.THUMB_BASE_URL+fname.replaceAll(".tif",".jpg"));
                        }
                        // PDF Thumb
                        else if (fname.endsWith(".pdf") && fileGroupID == 1574) {
                            plan.setPdfThumbUrl(AegaronConstants.PDF_BASE_URL+fname);
                        }
                        // PDF Drawing Log
                        else if (fname.endsWith(".pdf") && fileGroupID == 1575) {
                            plan.setPdfDrawingLogUrl(AegaronConstants.PDF_BASE_URL+fname);
                        }
                        // CAD Drawing
                        else if (fname.endsWith(".dwg") && fileGroupID == 1690) {
                            plan.setCadDrawingUrl(AegaronConstants.CAD_BASE_URL+fname);
                        }
                        // PNG Thumb to Scale
                        else if (fname.endsWith(".png") && fileGroupID == 1705) {
                            plan.setThumbToScaleUrl(AegaronConstants.PNG_BASE_URL+fname);
                        }
                        
                        map.put(ark,plan);
                        
                    } else {
                        // upate it
                        plan = map.get(ark);
                        
                        // Image
                        if (fname.endsWith(".tif") && fileGroupID == 1343) {                            
                            plan.setThumbnailUrl(AegaronConstants.THUMB_BASE_URL+fname.replaceAll(".tif",".jpg"));
                        }
                        // PDF Thumb
                        else if (fname.endsWith(".pdf") && fileGroupID == 1574) {
                            plan.setPdfThumbUrl(AegaronConstants.PDF_BASE_URL+fname);
                        }
                        // PDF Drawing Log
                        else if (fname.endsWith(".pdf") && fileGroupID == 1575) {
                            plan.setPdfDrawingLogUrl(AegaronConstants.PDF_BASE_URL+fname);
                        }
                        // CAD Drawing
                        else if (fname.endsWith(".dwg") && fileGroupID == 1690) {
                            plan.setCadDrawingUrl(AegaronConstants.CAD_BASE_URL+fname);
                        }
                        // PNG Thumb to Scale
                        else if (fname.endsWith(".png") && fileGroupID == 1705) {
                            plan.setThumbToScaleUrl(AegaronConstants.PNG_BASE_URL+fname);
                        }
                        
                    }

                }
                
                // Display some pool statistics
                if (ILog.ENABLED) { printDriverStats(); }
                
                return map.values().toArray(new Plan[map.size()]);
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { rset.close(); } catch(Exception e) { }
                try { stmt.close(); } catch(Exception e) { }
                try { conn.close(); } catch(Exception e) { }
            }
        }
                
        return null;
    }

    /*public Drawing[] listAllDrawings() {
        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
        PreparedStatement stmt = null;
        ResultSet rset = null;
        
        try {        
            // check db connection
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(CONNECTION_STRING);
            }           
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (conn != null) {
            StringBuilder sb = new StringBuilder("SELECT project_items.item_ark, project_items.node_title, project_items.desc_clob, content_files.file_name, content_files.file_groupid_fk ")
            .append("FROM project_items ")
            .append("LEFT OUTER JOIN content_files ON project_items.divid_pk = content_files.divid_fk ") 
            .append("WHERE (project_items.projectid_fk = ? ") 
            .append("AND project_items.statusid_fk IN (?,?) ") 
            .append("AND project_items.objectid_fk = ?) ") 
            .append("AND (content_files.file_use = ?) ")
            .append("ORDER BY project_items.node_title ASC"); 

            try {
                if (ILog.ENABLED) {
                    stmt = new LoggableStatement(conn, sb.toString());
                } else {
                    stmt = conn.prepareStatement(sb.toString());
                }

                stmt.clearParameters();
                stmt.setInt(1, AegaronConstants.PROJECT_ID);
                stmt.setInt(2, AegaronConstants.COMPLETED);
                stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
                stmt.setInt(4, AegaronConstants.PLAN_OBJECT_ID);
                stmt.setString(5, AegaronConstants.FILE_USE[1]);

                if (ILog.ENABLED) {
                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                }

                rset = stmt.executeQuery();

                Map<String, Plan> map = new LinkedHashMap<String, Plan>();
                Plan plan;
                                
                while (rset.next()) {
                    String ark = rset.getString("ITEM_ARK");
                    String title = rset.getString("NODE_TITLE");
                    String fname = rset.getString("FILE_NAME");
                    String xmlMetadata = rset.getString("DESC_CLOB");
                    int fileGroupID = rset.getInt("FILE_GROUPID_FK");
                                        
                    if (!map.containsKey(ark)) {
                        // create it
                        plan = new Plan();
                        plan.setId(ark);
                        plan.setTitle(title);
                        plan.setXmlMetadata(xmlMetadata);
                        
                        // Image
                        if (fname.endsWith(".tif") && fileGroupID == 1343) {                            
                            plan.setThumbnailUrl(AegaronConstants.THUMB_BASE_URL+fname.replaceAll(".tif",".jpg"));
                        }
                        // PDF Thumb
                        else if (fname.endsWith(".pdf") && fileGroupID == 1574) {
                            plan.setPdfThumbUrl(AegaronConstants.PDF_BASE_URL+fname);
                        }
                        // PDF Drawing Log
                        else if (fname.endsWith(".pdf") && fileGroupID == 1575) {
                            plan.setPdfDrawingLogUrl(AegaronConstants.PDF_BASE_URL+fname);
                        }
                        
                        map.put(ark,plan);
                        
                    } else {
                        // upate it
                        plan = map.get(ark);
                        
                        // Image
                        if (fname.endsWith(".tif") && fileGroupID == 1343) {                            
                            plan.setThumbnailUrl(AegaronConstants.THUMB_BASE_URL+fname.replaceAll(".tif",".jpg"));
                        }
                        // PDF Thumb
                        else if (fname.endsWith(".pdf") && fileGroupID == 1574) {
                            plan.setPdfThumbUrl(AegaronConstants.PDF_BASE_URL+fname);
                        }
                        // PDF Drawing Log
                        else if (fname.endsWith(".pdf") && fileGroupID == 1575) {
                            plan.setPdfDrawingLogUrl(AegaronConstants.PDF_BASE_URL+fname);
                        }
                        
                    }

                }
                
                // Display some pool statistics
                if (ILog.ENABLED) { printDriverStats(); }
                
                return map.values().toArray(new Plan[map.size()]);
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { rset.close(); } catch(Exception e) { }
                try { stmt.close(); } catch(Exception e) { }
                try { conn.close(); } catch(Exception e) { }
            }
        }
                
        return null;
    }*/

     public String[] listAllClassifications() {
         Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
         PreparedStatement stmt = null;
         ResultSet rset = null;
         
         try {        
             // check db connection
             if (conn == null || conn.isClosed()) {
                 conn = DriverManager.getConnection(CONNECTION_STRING);
             }           
         } catch (Exception e) {
             e.printStackTrace();
         }
         
         if (conn != null) {
              StringBuilder sb = new StringBuilder("SELECT /*+ INDEX_JOIN(DESC_VALUES) */ core_desc_control_values.core_desc_cv AS classification ")
              .append("FROM project_items, desc_control_values, desc_values, core_desc_control_values ")
              .append("WHERE project_items.divid_pk = desc_values.divid_fk ")
              .append("AND desc_control_values.desc_cvid_pk = desc_values.desc_cvid_fk ")
              .append("AND core_desc_control_values.core_desc_cvid_pk = desc_control_values.core_desc_cvid_fk ")
              .append("AND project_items.projectid_fk = ? ")
              .append("AND project_items.statusid_fk IN (?,?) ")
              .append("AND desc_control_values.desc_termid_fk = ? ")
              .append("GROUP BY core_desc_control_values.core_desc_cv ")
              .append("ORDER BY NLSSORT(classification,'NLS_SORT=BINARY_CI')");

             try {
                 if (ILog.ENABLED) {
                     stmt = new LoggableStatement(conn, sb.toString());
                 } else {
                     stmt = conn.prepareStatement(sb.toString());
                 }

                 stmt.clearParameters();
                 stmt.setInt(1, AegaronConstants.PROJECT_ID);
                 stmt.setInt(2, AegaronConstants.COMPLETED);
                 stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
                 stmt.setInt(4, AegaronConstants.PUBLISHER);

                 if (ILog.ENABLED) {
                     System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                 }

                 rset = stmt.executeQuery();

                 List<String> list = new ArrayList<String>();
                 
                 while (rset.next()) {
                     String classification = rset.getString("classification"); 
                     
                     if (classification != null) {
                         list.add(classification);
                     }
                 }
                 
                 // Display some pool statistics
                 if (ILog.ENABLED) { printDriverStats(); }
                 
                 return list.toArray(new String[list.size()]);

                 
             } catch (Exception e) {
                 e.printStackTrace();
             } finally {
                 try { rset.close(); } catch(Exception e) { }
                 try { stmt.close(); } catch(Exception e) { }
                 try { conn.close(); } catch(Exception e) { }
             }
         }
                 
         return null;
     }
    
    private ContentFile[] getContentFile (int divid) {
        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
        PreparedStatement stmt = null;
        ResultSet rset = null;
        
        try {        
            // check db connection
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(CONNECTION_STRING);
            }           
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (conn != null) {
             StringBuilder sb = new StringBuilder("SELECT V_CONTENT_FILES.SUBMASTER_ID, V_CONTENT_FILES.THUMBNAIL_LOCATION ")
             .append("FROM V_CONTENT_FILES WHERE (V_CONTENT_FILES.DIV_ID = ?) ")
             .append("ORDER BY V_CONTENT_FILES.SUBMASTER_ID ASC");

            try {
                if (ILog.ENABLED) {
                    stmt = new LoggableStatement(conn, sb.toString());
                } else {
                    stmt = conn.prepareStatement(sb.toString());
                }

                stmt.clearParameters();
                stmt.setInt(1, divid);               

                if (ILog.ENABLED) {
                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                }

                rset = stmt.executeQuery();

                List<ContentFile> contentFileList = new LinkedList<ContentFile>();
                
                while (rset.next()) {
                    String submasterId = rset.getString("SUBMASTER_ID");
                    String thumbLoc = rset.getString("THUMBNAIL_LOCATION"); 
                    
                    ContentFile contentFile = new ContentFile();
                    contentFile.setContentFileId(submasterId);
                    contentFile.setThumbnailUrl(thumbLoc);
                    
                    contentFileList.add(contentFile);
                    
                }
                
                // Display some pool statistics
                if (ILog.ENABLED) { printDriverStats(); }
                
                return contentFileList.toArray(new ContentFile[contentFileList.size()]);

                
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { rset.close(); } catch(Exception e) { }
                try { stmt.close(); } catch(Exception e) { }
                try { conn.close(); } catch(Exception e) { }
            }
        }
                
        return null;
    }

    public String[] listAllFeatureTypes() {
        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
        PreparedStatement stmt = null;
        ResultSet rset = null;
        
        try {        
            // check db connection
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(CONNECTION_STRING);
            }           
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (conn != null) {
             StringBuilder sb = new StringBuilder("SELECT /*+ INDEX_JOIN(DESC_VALUES) */ core_desc_control_values.core_desc_cv AS feature_type ")
             .append("FROM project_items, desc_control_values, desc_values, core_desc_control_values ")
             .append("WHERE project_items.divid_pk = desc_values.divid_fk ")
             .append("AND desc_control_values.desc_cvid_pk = desc_values.desc_cvid_fk ")
             .append("AND core_desc_control_values.core_desc_cvid_pk = desc_control_values.core_desc_cvid_fk ")
             .append("AND project_items.projectid_fk = ? ")
             .append("AND project_items.statusid_fk IN(?,?) ")
             .append("AND desc_control_values.desc_termid_fk = ? ")
             .append("AND desc_values.desc_qualifierid_fk = ? ")
             .append("GROUP BY core_desc_control_values.core_desc_cv ")
             .append("ORDER BY core_desc_control_values.core_desc_cv ASC");

            try {
                if (ILog.ENABLED) {
                    stmt = new LoggableStatement(conn, sb.toString());
                } else {
                    stmt = conn.prepareStatement(sb.toString());
                }

                stmt.clearParameters();
                stmt.setInt(1, AegaronConstants.PROJECT_ID);
                stmt.setInt(2, AegaronConstants.COMPLETED);
                stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
                stmt.setInt(4, AegaronConstants.TYPE);
                stmt.setInt(5, AegaronConstants.FEATURE_TYPE);

                if (ILog.ENABLED) {
                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                }

                rset = stmt.executeQuery();

                List<String> list = new ArrayList<String>();
                
                while (rset.next()) {
                    String featureType = rset.getString("feature_type"); 
                    
                    if (featureType != null) {
                        list.add(featureType);
                    }
                }
                
                // Display some pool statistics
                if (ILog.ENABLED) { printDriverStats(); }
                
                return list.toArray(new String[list.size()]);

                
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { rset.close(); } catch(Exception e) { }
                try { stmt.close(); } catch(Exception e) { }
                try { conn.close(); } catch(Exception e) { }
            }
        }
                
        return null;
    }

    public String[] listAllPeriods() {
        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
        PreparedStatement stmt = null;
        ResultSet rset = null;
        
        try {        
            // check db connection
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(CONNECTION_STRING);
            }           
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (conn != null) {
             StringBuilder sb = new StringBuilder("SELECT /*+ INDEX_JOIN(DESC_VALUES) */ core_desc_control_values.core_desc_cv AS subject_period ")
             .append("FROM project_items, desc_control_values, desc_values, core_desc_control_values ")
             .append("WHERE project_items.divid_pk = desc_values.divid_fk ")
             .append("AND desc_control_values.desc_cvid_pk = desc_values.desc_cvid_fk ")
             .append("AND core_desc_control_values.core_desc_cvid_pk = desc_control_values.core_desc_cvid_fk ")
             .append("AND project_items.projectid_fk = ? ")
             .append("AND project_items.statusid_fk IN (?,?) ")
             .append("AND desc_control_values.desc_termid_fk = ? ")
             .append("AND desc_values.desc_qualifierid_fk = ? ")
             .append("GROUP BY core_desc_control_values.core_desc_cv ")
             .append("ORDER BY core_desc_control_values.core_desc_cv ASC");

            try {
                if (ILog.ENABLED) {
                    stmt = new LoggableStatement(conn, sb.toString());
                } else {
                    stmt = conn.prepareStatement(sb.toString());
                }

                stmt.clearParameters();
                stmt.setInt(1, AegaronConstants.PROJECT_ID);
                stmt.setInt(2, AegaronConstants.COMPLETED);
                stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
                stmt.setInt(4, AegaronConstants.SUBJECT);
                stmt.setInt(5, AegaronConstants.PERIOD);

                if (ILog.ENABLED) {
                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                }

                rset = stmt.executeQuery();

                List<String> list = new ArrayList<String>();
                
                while (rset.next()) {
                    String subjectPeriod = rset.getString("subject_period"); 
                    
                    if (subjectPeriod != null) {
                        list.add(subjectPeriod);
                    }
                }
                
                // Display some pool statistics
                if (ILog.ENABLED) { printDriverStats(); }
                
                return list.toArray(new String[list.size()]);

                
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { rset.close(); } catch(Exception e) { }
                try { stmt.close(); } catch(Exception e) { }
                try { conn.close(); } catch(Exception e) { }
            }
        }
                
        return null;
    }


    private Term[] getReferredArkIds(final String term, final String lang, final String relationship) {
        if (term == null || lang == null || relationship == null || "".equals(term.trim()) || 
            "".equals(lang.trim()) || "".equals(relationship.trim())) {
              
            return null;    
        }
        
        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
        PreparedStatement stmt = null;
        ResultSet rset = null;
        
        
        try {        
            // check db connection
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(CONNECTION_STRING);
            }           
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (conn != null) {
            StringBuilder sb = new StringBuilder("SELECT project_items.item_ark, ");
            if ("en".equalsIgnoreCase(lang)) {
                sb.append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/title/text()').getstringval()) AS preferred_term ");
            }
            else if ("ar".equalsIgnoreCase(lang)) {
                sb.append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altTitle/Arabic_preferred/text()').getstringval()) AS preferred_term ");
            }
            else if ("de".equalsIgnoreCase(lang)) {
                sb.append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altTitle/German_preferred/text()').getstringval()) AS preferred_term ");
            } 
            /*else if ("en".equalsIgnoreCase(lang) && "child".equalsIgnoreCase(relationship)) {
                sb.append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/title/text()').getstringval()) AS preferred_term ");
            }
            else if ("de".equalsIgnoreCase(lang) && "child".equalsIgnoreCase(relationship)) {
                sb.append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altTitle/German_preferred/text()').getstringval()) AS preferred_term ");
            }
            else if ("ar".equalsIgnoreCase(lang) && "child".equalsIgnoreCase(relationship)) {
                sb.append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altTitle/Arabic_preferred/text()').getstringval()) AS preferred_term ");
            }*/
            
            sb.append("FROM project_items ");
            sb.append("WHERE (project_items.projectid_fk = ?) ");
            sb.append("AND (project_items.statusid_fk IN (?,?)) ");
            sb.append("AND (project_items.objectid_fk = ?) "); 
            
            if ("en".equalsIgnoreCase(lang) && "parent".equalsIgnoreCase(relationship)) {
                sb.append("and xmltype(desc_clob).extract('/record/metadata/dc/title/text()').getStringVal() = ?");
            }
            else if ("ar".equalsIgnoreCase(lang) && "parent".equalsIgnoreCase(relationship)) {
                sb.append("and xmltype(desc_clob).extract('/record/metadata/dc/altTitle/Arabic_preferred/text()').getStringVal() = ?");
            }
            else if ("de".equalsIgnoreCase(lang) && "parent".equalsIgnoreCase(relationship)) {
                sb.append("and xmltype(desc_clob).extract('/record/metadata/dc/altTitle/German_preferred/text()').getStringVal() = ?");
            } 
            else if ("en".equalsIgnoreCase(lang) && "child".equalsIgnoreCase(relationship)) {
                sb.append("and xmltype(desc_clob).extract('/record/metadata/dc/relation/parent_English/text()').getStringVal() = ?");
            }
            else if ("de".equalsIgnoreCase(lang) && "child".equalsIgnoreCase(relationship)) {
                sb.append("and xmltype(desc_clob).extract('/record/metadata/dc/relation/parent_German/text()').getStringVal() = ?");
            }
            else if ("ar".equalsIgnoreCase(lang) && "child".equalsIgnoreCase(relationship)) {
                sb.append("and xmltype(desc_clob).extract('/record/metadata/dc/relation/parent_Arabic/text()').getStringVal() = ?");
            }

            try {
                if (ILog.ENABLED) {
                    stmt = new LoggableStatement(conn, sb.toString());
                } else {
                    stmt = conn.prepareStatement(sb.toString());
                }

                stmt.clearParameters();
                stmt.setInt(1, AegaronConstants.PROJECT_ID);
                stmt.setInt(2, AegaronConstants.COMPLETED);
                stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
                stmt.setInt(4, AegaronConstants.TERM_OBJECT_ID);
                stmt.setString(5, term);

                if (ILog.ENABLED) {
                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                }

                rset = stmt.executeQuery();

                //List<Term> list = new ArrayList<String>();
                List<Term> termList = new LinkedList<Term>();
                
                while (rset.next()) {
                    String ark = rset.getString("ITEM_ARK"); 
                    String preferredTerm = rset.getString("preferred_term"); 
                    
                    Term t = new Term();
                    t.setItemArk(ark);
                    t.setPreferredTerm(preferredTerm);
                    
                    termList.add(t);
                    

                }
                
                // Display some pool statistics
                if (ILog.ENABLED) { printDriverStats(); }
                
                return termList.toArray(new Term[termList.size()]);

                
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { rset.close(); } catch(Exception e) { }
                try { stmt.close(); } catch(Exception e) { }
                try { conn.close(); } catch(Exception e) { }
            }
        }
                
        return null;
    }

    public Image[] searchDrawing(final String keyword) {
        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
        PreparedStatement stmt = null;
        ResultSet rset = null;
        boolean hasKeyword = false;
        String searchString = "AEGARON"; //default
        
        if (textHasContent(keyword)) {
            searchString = getKeywords(keyword.trim());
            hasKeyword = true;
            if (ILog.ENABLED) {
                System.out.println("Search String => " + searchString);
            }
        } 
         
        try {        
            // check db connection
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(CONNECTION_STRING);
            }           
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (conn != null) {
            StringBuilder sb = new StringBuilder("SELECT /* + FIRST_ROWS */  score(1), project_items.item_ark, content_files.file_name, content_files.file_groupid_fk, ")
            .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/type/featureType/text()').getstringval ()) AS feature_type, ")
            .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altTitle/planTitle/text()').getstringval ()) AS plan_title, ")
            .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/type/state/text()').getstringval ()) AS type_state, ")
            .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/subject/place/text()').getstringval ()) AS subject_place, ")
            .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/subject/period/text()').getstringval ()) AS subject_period, ")
            .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altIdentifier/ueePlaceID/text()').getstringval ()) AS uee_placeid, ")
            .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altIdentifier/drawing/text()').getstringval ()) AS drawing, ")
            .append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/description/view/text()').getstringval ()) AS description_view ")
            .append("FROM project_items, content_files ")
            .append("WHERE (project_items.divid_pk = content_files.divid_fk) ")
            .append("AND (project_items.projectid_fk = ?) AND (project_items.statusid_fk IN (?,?)) ")
            .append("AND (project_items.objectid_fk = ?)  AND (content_files.file_use = ?) ")
            .append("AND (contains (desc_clob, ?, 1) > 0) ")
            .append("ORDER BY score(1) DESC, subject_place, plan_title, description_view, type_state, drawing ASC");            

            try {
                if (ILog.ENABLED) {
                    stmt = new LoggableStatement(conn, sb.toString());
                } else {
                    stmt = conn.prepareStatement(sb.toString());
                }

                stmt.clearParameters();                
                stmt.setInt(1, AegaronConstants.PROJECT_ID);
                stmt.setInt(2, AegaronConstants.COMPLETED);
                stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
                stmt.setInt(4, AegaronConstants.PLAN_OBJECT_ID);
                stmt.setString(5, AegaronConstants.FILE_USE[1]);
                stmt.setString(6, searchString);
                
                if (ILog.ENABLED) {
                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                }

                rset = stmt.executeQuery();

                Map<String,Image> map = new LinkedHashMap<String,Image>();
                String ark = "";
                String fname = "";
                Image image;
                List<String> subjectPeriodList = new ArrayList<String>();
                List<String> descriptionViewList = new ArrayList<String>();
                
                while (rset.next()) {
                    fname = rset.getString("FILE_NAME"); 
                    ark = rset.getString("ITEM_ARK");                    
                    int fileGroupID = rset.getInt("FILE_GROUPID_FK");
                    
                    if (map.containsKey(ark)) {
                        // update existing Image
                        image = map.get(ark);

                        if (fname.endsWith(".tif")) {                            
                            image.setThumbnailUrl(AegaronConstants.THUMB_BASE_URL+fname.replaceAll(".tif",".jpg"));
                        }
                        else if (fname.endsWith(".pdf") && fileGroupID == 1574) {
                            image.setPdfThumbUrl(AegaronConstants.PDF_BASE_URL+fname);
                        }
                        else if (fname.endsWith(".pdf") && fileGroupID == 1575) {
                            image.setPdfDrawingLogUrl(AegaronConstants.PDF_BASE_URL+fname);
                        } 
                       
                        map.put(ark,image);
                        
                    } else {
                        // crete new Image
                        image = new Image();                        
                        image.setId(ark);
                                                
                        String planTitle = rset.getString("plan_title");
                        String typeState = rset.getString("type_state");
                        String typeFeatureType = rset.getString("feature_type");
                        String subjectPlace = rset.getString("subject_place");
                        String subjectPeriod = rset.getString("subject_period");
                        String ueePlaceId = rset.getString("uee_placeid");
                        String altIdentifierDrawing = rset.getString("drawing");
                        String descriptionView = rset.getString("description_view");
                        
                        if (planTitle != null) {
                            image.setPlanTitle( planTitle);
                        } else {
                            image.setPlanTitle("unknown");
                        }
                        if (ILog.ENABLED) {
                            if (planTitle != null) {
                                System.out.println("AltTitle.planTitle = " + planTitle);
                            } else {
                                System.out.println("AltTitle.planTitle is null.");
                            }
                        }
                                              
                        if (typeState != null) {
                            image.setState(typeState);
                        } else {
                            image.setState("unknown");
                        }
                        if (ILog.ENABLED) {
                            if (typeState != null) {
                                System.out.println("Type.state = " + typeState);
                            } else {
                                System.out.println("Type.state is null.");
                            }
                        }
                        
                        if (typeFeatureType != null) {
                            image.setFeatureType(typeFeatureType);
                        } else {
                            image.setFeatureType("unknown");
                        }
                        if (ILog.ENABLED) {
                            if (typeFeatureType != null) {
                                System.out.println("Type.featureType = " + typeFeatureType);
                            } else {
                                System.out.println("Type.featureType is null.");
                            }
                        }
                        
                        if (subjectPlace != null) {
                            image.setPlace(subjectPlace);
                        } else {
                            image.setPlace("unknown");
                        }
                        if (ILog.ENABLED) {
                            if (subjectPlace != null) {
                                System.out.println("Subject.place = " + subjectPlace);
                            } else {
                                System.out.println("Subject.place is null.");
                            }
                        }
                        
                        if (subjectPeriod != null) {
                            if (subjectPeriod.contains("Late Antiquity")) {
                                subjectPeriodList.add("Late Antiquity");
                            }
                            if (subjectPeriod.contains("Late Period")) {
                                subjectPeriodList.add("Late Period");
                            }
                            if (subjectPeriod.contains("Middle Kingdom")) {
                                subjectPeriodList.add("Middle Kingdom");
                            }
                            if (subjectPeriod.contains("New Kingdom")) {
                                subjectPeriodList.add("New Kingdom");
                            }
                            if (subjectPeriod.contains("Old Kingdom")) {
                                subjectPeriodList.add("Old Kingdom");
                            }
                            if (subjectPeriod.contains("Ptolemaic Period")) {
                                subjectPeriodList.add("Ptolemaic Period");
                            }
                            if (subjectPeriod.contains("Roman Period")) {
                                subjectPeriodList.add("Roman Period");
                            }
                            
                            if (subjectPeriodList.size() > 1) {
                                image.setPeriod(StringUtils.join(subjectPeriodList, '/'));
                            } else {
                                image.setPeriod(subjectPeriod);
                            }
                            
                            subjectPeriodList.clear();
                            
                        } else {
                            image.setPeriod("unknown");
                        }

                        if (ueePlaceId != null) {
                            image.setUeePlaceID(ueePlaceId);
                        } else {
                            image.setUeePlaceID("unknown");
                        }
                        if (ILog.ENABLED) {
                            if (ueePlaceId != null) {
                                System.out.println("altIdentifier.ueePlaceID = " + ueePlaceId);
                            } else {
                                System.out.println("altIdentifier.ueePlaceID is null.");
                            }
                        }
                        
                        if (altIdentifierDrawing != null) {
                            image.setDrawing(altIdentifierDrawing);
                        } else {
                            image.setDrawing("unknown");
                        }
                        if (ILog.ENABLED) {
                            if (altIdentifierDrawing != null) {
                                System.out.println("altIdentifier.drawing = " + altIdentifierDrawing);
                            } else {
                                System.out.println("altIdentifier.drawing is null.");
                            }
                        }
                        
                        if (descriptionView != null) {
                            if (descriptionView.equalsIgnoreCase("detailsection")){
                                descriptionViewList.add("detail");
                                descriptionViewList.add("section");
                            } else {
                                if (StringUtils.contains(descriptionView,"detail")) {
                                    descriptionViewList.add("detail");
                                }
                                if (StringUtils.contains(descriptionView,"elevation")) {
                                    descriptionViewList.add("elevation");
                                }
                                if (StringUtils.contains(descriptionView,"section A-A")) {
                                    descriptionViewList.add("section A-A");
                                }
                                if (StringUtils.contains(descriptionView,"section B-B")) {
                                    descriptionViewList.add("section B-B");
                                }
                                if (StringUtils.contains(descriptionView,"section C-C")) {
                                    descriptionViewList.add("section C-C");
                                }
                                if (StringUtils.contains(descriptionView,"general plan")) {
                                    descriptionViewList.add("general plan");
                                }
                                if (StringUtils.contains(descriptionView,"top view")) {
                                    descriptionViewList.add("top view");
                                }
                                if (StringUtils.contains(descriptionView,"east elevation")) {
                                    descriptionViewList.add("east elevation");
                                }
                                if (StringUtils.contains(descriptionView,"south elevation")) {
                                    descriptionViewList.add("south elevation");
                                }
                                if (StringUtils.contains(descriptionView,"west elevation")) {
                                    descriptionViewList.add("west elevation");
                                }
                            }
                            
                            if (descriptionViewList.size() > 1) {
                                image.setView(StringUtils.join(descriptionViewList, '/'));
                            } else {
                                image.setView(descriptionView);
                            }
                            
                            descriptionViewList.clear();
                            
                        } else {
                            image.setView("unknown");
                        }
                                               
                        if (fname.endsWith(".tif")) {                                                        
                            image.setThumbnailUrl(AegaronConstants.THUMB_BASE_URL+fname.replaceAll(".tif",".jpg"));
                        }
                        else if (fname.endsWith(".pdf") && fileGroupID == 1574) {
                            image.setPdfThumbUrl(AegaronConstants.PDF_BASE_URL+fname);
                        }
                        else if (fname.endsWith(".pdf") && fileGroupID == 1575) {
                            image.setPdfDrawingLogUrl(AegaronConstants.PDF_BASE_URL+fname);
                        } 
                        
                        map.put(ark, image);                        
                        
                    }

                }
                
                // Display some pool statistics
                if (ILog.ENABLED) { printDriverStats(); }
                
                return map.values().toArray(new Image[map.size()]);
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { rset.close(); } catch(Exception e) { }
                try { stmt.close(); } catch(Exception e) { }
                try { conn.close(); } catch(Exception e) { }
            }
        }
                
        return null;
    }

    public String searchTerms(final String keyword, final String lang) {
       Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
       PreparedStatement stmt = null;
       ResultSet rset = null;
       boolean hasKeyword = false;
       String searchString = "AEGARON"; //default
       
       // root elements 
       Element terms = new Element("terms");
       Document document = new Document(terms);         
       
       if (textHasContent(keyword)) {
           if ("en".equalsIgnoreCase(lang)) {
                searchString = StringEscapeUtils.escapeSql(keyword);
           } else {
                try {
                    searchString = new String(keyword.getBytes("UTF-8"), "UTF-8");
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
            }
           hasKeyword = true;
           if (ILog.ENABLED) {
               System.out.println("Search String => " + searchString);
               System.out.println("lang=" + lang);
           }
       }
       
       try {        
           // check db connection
           if (conn == null || conn.isClosed()) {
               //System.out.println("Reconnecting...");
               conn = DriverManager.getConnection(CONNECTION_STRING);
               //System.out.println("Done");
           }           
       } catch (Exception e) {
           e.printStackTrace();
       }
       
       if (conn != null) {
           StringBuilder sb = new StringBuilder("SELECT /* + FIRST_ROWS */ project_items.item_ark, project_items.node_title, project_items.desc_clob, content_files.file_name, content_files.file_location FROM project_items ");
           sb.append("LEFT OUTER JOIN content_files ON project_items.divid_pk = content_files.divid_fk ");
           sb.append("WHERE (project_items.projectid_fk = ?) ");
           sb.append("AND (project_items.statusid_fk IN (?,?)) ");
           sb.append("AND (project_items.objectid_fk = ?) "); 
           sb.append("AND (content_files.file_use = ?) ");
           
           if ("en".equalsIgnoreCase(lang)) {
               sb.append("AND (contains (desc_clob, '").append(searchString).append(" WITHIN title OR ").append(searchString).append(" WITHIN English_alternate', 1) > 0) ");
           }
           else if ("ar".equalsIgnoreCase(lang)) {
                sb.append("AND (contains (desc_clob, '").append(searchString).append(" WITHIN Arabic_preferred OR ").append(searchString).append(" WITHIN Arabic_alternate', 1) > 0) ");
           }
           else if ("de".equalsIgnoreCase(lang)) {
               sb.append("AND (contains (desc_clob, '").append(searchString).append(" WITHIN German_preferred OR ").append(searchString).append(" WITHIN German_alternate', 1) > 0) ");
           } else {
                sb.append("AND (contains (desc_clob, '").append(searchString).append(" WITHIN title OR ").append(searchString).append(" WITHIN English_alternate OR ").append(searchString).append(" WITHIN Arabic_preferred OR ").append(searchString).append(" WITHIN Arabic_alternate OR ").append(searchString).append(" WITHIN German_preferred OR ").append(searchString).append(" WITHIN German_alternate', 1) > 0) ");
           }
           
           sb.append("ORDER BY NLSSORT(project_items.node_title,'NLS_SORT=BINARY_CI')");
               
           try {
               if (ILog.ENABLED) {
                   stmt = new LoggableStatement(conn, sb.toString());
               } else {
                   stmt = conn.prepareStatement(sb.toString());
               }
     
               stmt.clearParameters();
               stmt.setInt(1, AegaronConstants.PROJECT_ID);
               stmt.setInt(2, AegaronConstants.COMPLETED);
               stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
               stmt.setInt(4, AegaronConstants.TERM_OBJECT_ID);
               stmt.setString(5, AegaronConstants.FILE_USE[0]);
               
               if (ILog.ENABLED) {
                   System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
               }
     
               rset = stmt.executeQuery();

               
               Element term = null;
               Map<String, String> map = new HashMap<String, String>();
               
               while (rset.next()) {
                   String ark = rset.getString("ITEM_ARK");                    
                   String nodeTitle = rset.getString("NODE_TITLE");
                   String descClob = rset.getString("DESC_CLOB");
                   String flocat = rset.getString("FILE_LOCATION");
                                     
                   if (!map.containsKey(ark)) {
                       map.put(ark, nodeTitle);
                       SAXBuilder builder = new SAXBuilder();
                       Document tempDoc = builder.build(new StringReader(descClob));
                       
                       term = new Element("term");
                      
                       if (lang != null && "en".equalsIgnoreCase(lang)) {
                           // the preferred term is the title
                           Element title = new Element("title");
                           title.setAttribute(new Attribute("lang", "en"));
                           title.setAttribute(new Attribute("arkid", ark));
                           title.setText(nodeTitle);
                           term.addContent(title);
                           
                           XPath xPathPublisher = XPath.newInstance("/record/metadata/dc/publisher");
                           List publisherList = xPathPublisher.selectNodes(tempDoc);
                           List<String> categoryList = new ArrayList<String>();
                           
                           Element categories = new Element("categories");
                           
                           for (Object obj: publisherList) {
                               Element category = (Element)obj;
                               categoryList.add(category.getText());
                           }
                           if (publisherList.size() > 0) {
                               publisherList.clear();
                           }
                           
                           if (categoryList.size() > 0) {
                               Collections.sort(categoryList, new SortIgnoreCase());
                               
                               for (String s: categoryList) {
                                   Element category = new Element("category");
                                   category.setText(s);
                                   categories.addContent(category);
                               }
                               
                               categoryList.clear();
    
                           } 
                           
                           term.addContent(categories);
                           
                           Element image = new Element("image");
                           image.setText(flocat);
                           term.addContent(image);
                           
                           terms.addContent(term);
    
                       }                   
                       else if (lang != null && "ar".equalsIgnoreCase(lang)) {
                           if (ILog.ENABLED) {
                               System.out.println(">>>lang="+lang);
                           }
                           XPath xPathArabicPreferred = XPath.newInstance("/record/metadata/dc/altTitle/Arabic_preferred");
                           List preferredArablicList = xPathArabicPreferred.selectNodes(tempDoc);
                           
                           List<String> preferredArabicTitles = new ArrayList<String>();
                           for (Object obj: preferredArablicList) {
                               Element e = (Element)obj;
                               String arabic = new String(e.getText().getBytes("UTF-8"), "UTF-8");
                               preferredArabicTitles.add(arabic);
                           }
                           
                           if (preferredArablicList.size() > 0) {
                               preferredArablicList.clear();
                           }
                           
                           if (preferredArabicTitles.size() > 0) {
                               Collator collator = Collator.getInstance(new Locale("ar"));
                               Collections.sort(preferredArabicTitles, collator);
                               
                               for (String s: preferredArabicTitles) {
                                   Element arTitle = new Element("title");
                                   arTitle.setAttribute(new Attribute("lang", "ar"));
                                   arTitle.setAttribute(new Attribute("arkid", ark));
                                   arTitle.setText(s);
                                   term.addContent(arTitle);
                                   if (ILog.ENABLED) {
                                       System.out.println(">>>deTitle: " + s);
                                   }
                               }
                               
                               preferredArabicTitles.clear();
                               
                           }
    
                           XPath xPathPublisherAr = XPath.newInstance("/record/metadata/dc/publisher");
                           List publisherList = xPathPublisherAr.selectNodes(tempDoc);
                           List<String> categoryList = new ArrayList<String>();
                           
                           Element categories = new Element("categories");
                           
                           for (Object obj: publisherList) {
                               Element category = (Element)obj;
                               categoryList.add(category.getText());
                           }
                           
                           if (publisherList.size() > 0) {
                               publisherList.clear();
                           }
                           
                           if (categoryList.size() > 0) {
                               Collections.sort(categoryList, new SortIgnoreCase());
                               
                               for (String s: categoryList) {
                                   Element category = new Element("category");
                                   category.setText(s);
                                   categories.addContent(category);
                               }
                               
                               categoryList.clear();
                               
                           }
                           
                           term.addContent(categories);
                           
                           Element image = new Element("image");
                           image.setText(flocat);
                           term.addContent(image);
    
                           terms.addContent(term);
                           
                       } 
                       else if (lang != null && "de".equalsIgnoreCase(lang)) {
                           if (ILog.ENABLED) {
                               System.out.println(">>>lang=" + lang);
                           }
                           XPath xPathGermanPreferred = XPath.newInstance("/record/metadata/dc/altTitle/German_preferred");
                           List preferredGermanList = xPathGermanPreferred.selectNodes(tempDoc);
                           
                           List<String> preferredGermanTitles = new ArrayList<String>();
                           for (Object obj: preferredGermanList) {
                               Element e = (Element)obj;
                               String german = new String(e.getText().getBytes("UTF-8"), "UTF-8");
                               preferredGermanTitles.add(german);
                           }
                           
                           if (preferredGermanList.size() > 0) {
                               preferredGermanList.clear();
                           }
                           
                           if (preferredGermanTitles.size() > 0) {
                               Collator collator = Collator.getInstance(new Locale("de"));
                               Collections.sort(preferredGermanTitles, collator);
                               
                               for (String s: preferredGermanTitles) {
                                   Element deTitle = new Element("title");
                                   deTitle.setAttribute(new Attribute("lang", "de"));
                                   deTitle.setAttribute(new Attribute("arkid", ark));
                                   deTitle.setText(s);
                                   term.addContent(deTitle);
                                   if (ILog.ENABLED) {
                                       System.out.println(">>>deTitle: " + s);
                                   }
                               }
                               preferredGermanTitles.clear();
                           }
    
                           XPath xPathPublisherDe = XPath.newInstance("/record/metadata/dc/publisher");
                           List publisherList = xPathPublisherDe.selectNodes(tempDoc);
                           List<String> categoryList = new ArrayList<String>();
                           
                           Element categories = new Element("categories");
                           
                           for (Object obj: publisherList) {
                               Element category = (Element)obj;
                               categoryList.add(category.getText());
                           }
                           
                           if (publisherList.size() > 0) {
                               publisherList.clear();
                           }
                           
                           if (categoryList.size() > 0) {
                               Collections.sort(categoryList, new SortIgnoreCase());
                               
                               for (String s: categoryList) {
                                   Element category = new Element("category");
                                   category.setText(s);
                                   categories.addContent(category);
                               }
                               
                               categoryList.clear();
    
                           } 
                           
                           term.addContent(categories);
                           
                           Element image = new Element("image");
                           image.setText(flocat);
                           term.addContent(image);
                           
                           terms.addContent(term);
                           
                       } 
    
                       else if (hasKeyword && lang == null) {
                           if (ILog.ENABLED) {
                               System.out.println(">>>lang=" + lang);
                           }
                           // the preferred term is the title
                           Element title = new Element("title");
                           title.setAttribute(new Attribute("lang", "en"));
                           title.setAttribute(new Attribute("arkid", ark));
                           title.setText(nodeTitle);
                           term.addContent(title);
                           
                           XPath xPathPublisher = XPath.newInstance("/record/metadata/dc/publisher");
                           List publisherList = xPathPublisher.selectNodes(tempDoc);
                           List<String> categoryList = new ArrayList<String>();
                           
                           Element categories = new Element("categories");
                           
                           for (Object obj: publisherList) {
                               Element category = (Element)obj;
                               categoryList.add(category.getText());
                           }
                           
                           if (publisherList.size() > 0) {
                               publisherList.clear();
                           }
                           
                           if (categoryList.size() > 0) {
                               Collections.sort(categoryList, new SortIgnoreCase());
                               
                               for (String s: categoryList) {
                                   Element category = new Element("category");
                                   category.setText(s);
                                   categories.addContent(category);
                               }
    
                           } 
                           
                           term.addContent(categories);
                           
                           if (categoryList.size() > 0) {
                               categoryList.clear();
                           }
                           
                           Element image = new Element("image");
                           image.setText(flocat);
                           term.addContent(image);
    
                           terms.addContent(term);
                           
                       } // end keyword specified w/o lang
                   } // end map                   
               } // end while
                                           
               XMLOutputter xmlOutputer = new XMLOutputter();
                   
               if (ILog.ENABLED) {
                   try {
                       // pretty format the output
                       xmlOutputer.setFormat(Format.getPrettyFormat());
                       xmlOutputer.output(document, System.out);
                   } catch (IOException e) {
                       e.printStackTrace();
                   }
               }

               if (!map.isEmpty()) {
                   map.clear();
               }
               
               return xmlOutputer.outputString(document);
               
           } catch (Exception e) {
               e.printStackTrace();
           } finally {
               try { rset.close(); } catch(Exception e) { }
               try { stmt.close(); } catch(Exception e) { }
               try { conn.close(); } catch(Exception e) { }
           }
       }
               
       return null;
     }

    public DrawingMetadata getDrawingMetadata(final String ark) {        
        if (ark == null || ark.equals("")) {
            return null;    
        }
        
        DrawingMetadata drawingMD = null;
        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
        PreparedStatement stmt = null;
        ResultSet rset = null;
        //ObjectMapper mapper
        try {        
            // check db connection
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(CONNECTION_STRING);

            }           
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (conn != null) {
            StringBuilder sb = new StringBuilder("SELECT project_items.desc_clob ") 
            .append("FROM project_items WHERE project_items.item_ark = ?");

            try {                
                if (ILog.ENABLED) {
                    stmt = new LoggableStatement(conn, sb.toString());
                } else {
                    stmt = conn.prepareStatement(sb.toString());
                }
                stmt.clearParameters();
                stmt.setString(1, ark);
                
                if (ILog.ENABLED) {
                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                }

                rset = stmt.executeQuery();

                if (rset.next()) {
                    String xmlString = rset.getString("DESC_CLOB");
                    
                    if (xmlString != null) {
                        //jsonString = convertXML2JSON(xml);
                         //ObjectMapper mapper = new ObjectMapper();
                         drawingMD = new DrawingMetadata();
                         
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
                         //drawingDataJSON = strWriter.toString();
                         //drawingDataJSON = mapper.writeValueAsString(drawingMD);
                         //drawingDataJSON = mapper.defaultPrettyPrintingWriter().writeValueAsString(drawingMD);
                    }
                }

            } catch (SQLException e) {
                e.printStackTrace();
            } catch (Exception e) {
                // ignore it!
            }
            finally {
                try { rset.close(); } catch(Exception e) { }
                try { stmt.close(); } catch(Exception e) { }
                try { conn.close(); } catch(Exception e) { }
            }
        }
        return drawingMD;
    } 

    public PlanGeospatialMetadata getPlanGeospatialMetadata(final String ark) {        
        if (ark == null || ark.equals("")) {
            return null;    
        }
        
        PlanGeospatialMetadata planGeospatialMD = null;
        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
        PreparedStatement stmt = null;
        ResultSet rset = null;

        try {        
            // check db connection
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(CONNECTION_STRING);

            }           
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (conn != null) {
            StringBuilder sb = new StringBuilder("SELECT project_items.desc_clob ") 
            .append("FROM project_items WHERE project_items.item_ark = ?");

            try {                
                if (ILog.ENABLED) {
                    stmt = new LoggableStatement(conn, sb.toString());
                } else {
                    stmt = conn.prepareStatement(sb.toString());
                }
                stmt.clearParameters();
                stmt.setString(1, ark);
                
                if (ILog.ENABLED) {
                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                }

                rset = stmt.executeQuery();

                if (rset.next()) {
                    String xmlString = rset.getString("DESC_CLOB");
                    if (xmlString != null) {
                         //ObjectMapper mapper = new ObjectMapper();
                         planGeospatialMD = new PlanGeospatialMetadata();

                         String planTitle = ParseXML.getCharValueForANode(xmlString, "altTitle","planTitle");                         
                         if (planTitle != null) {
                             planGeospatialMD.setPlanTitle(planTitle);
                         }
                         
                         String temporalNote = ParseXML.getCharValueForANode(xmlString, "description","temporalNote");
                         if (temporalNote != null) {
                             planGeospatialMD.setTemporalNote(temporalNote);
                         }
                         
                         String keyword = ParseXML.getCharValueForANode(xmlString, "description","keyword");
                         if (keyword != null) {
                             planGeospatialMD.setKeyword(keyword);
                         }
                         
                         String view = ParseXML.getCharValueForANode(xmlString, "description","view");
                         if (view != null) {
                             planGeospatialMD.setView(view);
                         }
                         
                         String latitude = ParseXML.getCharValueForANode(xmlString, "description","latitude");
                         if (latitude != null) {
                             planGeospatialMD.setLatitude(latitude);
                         }
                         
                         String longitude = ParseXML.getCharValueForANode(xmlString, "description","longitude");
                         if (longitude != null) {
                             planGeospatialMD.setLongitude(longitude);
                         }
                         
                         String zoomLevel = ParseXML.getCharValueForANode(xmlString, "description","zoomLevel");
                         if (zoomLevel != null) {
                            planGeospatialMD.setZoomLevel(zoomLevel);
                         }
                         
                         String eastBL = ParseXML.getCharValueForANode(xmlString, "description","eastBL");
                         if (eastBL != null) {
                            planGeospatialMD.setEastBL(eastBL);
                         }
                         
                         String westBL = ParseXML.getCharValueForANode(xmlString, "description","westBL");
                         if (eastBL != null) {
                            planGeospatialMD.setWestBL(westBL);
                         }
                         
                         String northBL = ParseXML.getCharValueForANode(xmlString, "description","northBL");
                         if (northBL != null) {
                            planGeospatialMD.setNorthBL(northBL);
                         }

                         String southBL = ParseXML.getCharValueForANode(xmlString, "description","southBL");
                         if (southBL != null) {
                             planGeospatialMD.setSouthBL(southBL);
                         }  
                         
                         String urlForTitles = ParseXML.getCharValueForANode(xmlString, "description","URLforTiles");
                         if (urlForTitles != null) {
                            planGeospatialMD.setUrlForTitles(urlForTitles);
                         }
                         
                         //Writer strWriter = new StringWriter();
                         //mapper.writeValue(strWriter, drawingMD);
                         //drawingDataJSON = strWriter.toString();
                         //drawingDataJSON = mapper.writeValueAsString(drawingMD);
                         //drawingDataJSON = mapper.defaultPrettyPrintingWriter().writeValueAsString(drawingMD);
                    }
                }

            } catch (SQLException e) {
                e.printStackTrace();
            } catch (Exception e) {
                // ignore it!
            }
            finally {
                try { rset.close(); } catch(Exception e) { }
                try { stmt.close(); } catch(Exception e) { }
                try { conn.close(); } catch(Exception e) { }
            }
        }
        return planGeospatialMD;
    } 

    public String getMetadata(final String ark) {        
        if (ark == null || ark.equals("")) {
            return null;    
        }
        
        String metadata = null;
        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
        PreparedStatement stmt = null;
        ResultSet rset = null;
        
        try {        
            // check db connection
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(CONNECTION_STRING);

            }           
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (conn != null) {
            StringBuilder sb = new StringBuilder("SELECT project_items.desc_clob ") 
            .append("FROM project_items WHERE project_items.item_ark = ?");

            try {                
                if (ILog.ENABLED) {
                    stmt = new LoggableStatement(conn, sb.toString());
                } else {
                    stmt = conn.prepareStatement(sb.toString());
                }
                stmt.clearParameters();
                stmt.setString(1, ark);
                
                if (ILog.ENABLED) {
                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                }

                rset = stmt.executeQuery();

                if (rset.next()) {
                    metadata = rset.getString("DESC_CLOB");
                }

            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                try { rset.close(); } catch(Exception e) { }
                try { stmt.close(); } catch(Exception e) { }
                try { conn.close(); } catch(Exception e) { }
            }
        }
        return metadata;
    } 
    
    public Item getItem(final String ark) {        
        if (ark == null || ark.equals("")) {
            return null;    
        }
        
        Item item = null;
        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
        PreparedStatement stmt = null;
        ResultSet rset = null;
        
        try {        
            // check db connection
            if (conn == null || conn.isClosed()) {
                //System.out.println("Reconnecting...");
                conn = DriverManager.getConnection(CONNECTION_STRING);
                //System.out.println("Done");
            }           
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (conn != null) {
            StringBuilder sb = new StringBuilder("SELECT pi.node_title, pi.item_ark, cf.file_name, cf.file_groupid_fk,pi.desc_clob, ")
            .append("(EXTRACT (XMLTYPE (pi.desc_clob),'/record/metadata/dc/type/printSize/text()').getstringval ()) AS print_size ")
            .append("FROM (SELECT * FROM project_items CONNECT BY PRIOR divid_pk = parent_divid ")
            .append("START WITH (item_ark = ?)) pi, content_files cf ")
            .append("WHERE cf.divid_fk = pi.divid_pk AND cf.file_use = ?");

            try {                
                if (ILog.ENABLED) {
                    stmt = new LoggableStatement(conn, sb.toString());
                } else {
                    stmt = conn.prepareStatement(sb.toString());
                }
                
                stmt.clearParameters();
                stmt.setString(1, ark);
                stmt.setString(2, AegaronConstants.FILE_USE[1]);
                
                if (ILog.ENABLED) {
                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                }

                rset = stmt.executeQuery();

                String fname = "";
                String nodeTitle = "";
                String tempArk = "";
                
                while (rset.next()) {
                    // Plan will have the same descriptive metadata
                    if ("".equals(tempArk)) {
                        item = new Item();
                        tempArk = rset.getString("ITEM_ARK");
                        item.setXmlMetadata(rset.getString("DESC_CLOB"));
                        item.setId(tempArk);
                        nodeTitle = rset.getString("NODE_TITLE");
                    }
                    fname = rset.getString("FILE_NAME");                     
                    
                    int fileGroupID = rset.getInt("FILE_GROUPID_FK");
                    
                    // Thumbnail
                    if (fname.endsWith(".tif")) {                            
                        item.setThumbnailUrl(AegaronConstants.THUMB_BASE_URL+fname.replaceAll(".tif",".jpg"));
                    }
                    // PDF Thumb
                    else if (fname.endsWith(".pdf") && fileGroupID == 1574) {
                        item.setPdfThumbUrl(AegaronConstants.PDF_BASE_URL+fname);
                    }
                    // PDF Drawing Log
                    else if (fname.endsWith(".pdf") && fileGroupID == 1575) {
                        item.setPdfDrawingLogUrl(AegaronConstants.PDF_BASE_URL+fname);
                    }
                    // CAD Drawing
                    else if (fname.endsWith(".dwg") && fileGroupID == 1690) {
                        item.setCadDrawingUrl(AegaronConstants.CAD_BASE_URL+fname);
                    }
                    // PNG Thumb to Scale
                    else if (fname.endsWith(".dwg") && fileGroupID == 1705) {
                        item.setThumbToScaleUrl(AegaronConstants.PNG_BASE_URL+fname);
                    }
                    // Drawings 
                    else if (fname.endsWith(".pdf") && fileGroupID == 1631) {
                        String printSize = rset.getString("print_size");
                        String drawingMD = rset.getString("DESC_CLOB");
                        
                        if ("A0".equals(printSize)) {
                            item.setPdfPrintSizeA0Url(AegaronConstants.PDF_BASE_URL+fname);
                            item.setXmlPrintSizeA0MD(drawingMD);
                        }
                        else if ("A1".equals(printSize)) {
                            item.setPdfPrintSizeA1Url(AegaronConstants.PDF_BASE_URL+fname);
                            item.setXmlPrintSizeA1MD(drawingMD);
                        }
                        else if ("A3".equals(printSize)) {
                            item.setPdfPrintSizeA3Url(AegaronConstants.PDF_BASE_URL+fname);
                            item.setXmlPrintSizeA3MD(drawingMD);
                        }
                        else if ("A4/Letter".equals(printSize)) {
                            item.setPdfPrintSizeA4LetterUrl(AegaronConstants.PDF_BASE_URL+fname);
                            item.setXmlPrintSizeA4LetterMD(drawingMD);
                        }
                    } 

                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                try { rset.close(); } catch(Exception e) { }
                try { stmt.close(); } catch(Exception e) { }
                try { conn.close(); } catch(Exception e) { }
            }
        }
        
        return item;
    } 
     
    private Term[] getAllTerms(final String classification, final String language) {
      Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
      PreparedStatement stmt = null;
      ResultSet rset = null;
      
      try {        
          // check db connection
          if (conn == null || conn.isClosed()) {
              //System.out.println("Reconnecting...");
              conn = DriverManager.getConnection(CONNECTION_STRING);
              //System.out.println("Done");
          }           
      } catch (Exception e) {
          e.printStackTrace();
      }
      
      if (conn != null) {
          StringBuilder sb = new StringBuilder("SELECT /* + FIRST_ROWS */  project_items.item_ark, project_items.node_title, desc_values.desc_value, desc_values.desc_termid_fk, desc_values.desc_qualifierid_fk ");
          sb.append("FROM project_items LEFT OUTER JOIN desc_values ON project_items.divid_pk = desc_values.divid_fk ");          
          sb.append("WHERE (contains (desc_clob, '").append(classification).append(" WITHIN publisher') > 0) ");
          sb.append("AND project_items.projectid_fk = ? ");
          sb.append("AND project_items.statusid_fk IN (?,?) ");
          sb.append("AND project_items.objectid_fk = ? ");
          
          if ("English".equals(language)) {
              sb.append("AND desc_values.DESC_TERMID_FK IN (3720,3721) ");
              sb.append("AND (desc_values.DESC_QUALIFIERID_FK NOT IN (13510,13511,13515,13516) ");
          }
          else if ("Arabic".equals(language)) {
              sb.append("AND desc_values.DESC_TERMID_FK IN (3720) ");
              sb.append("AND (desc_values.DESC_QUALIFIERID_FK IN (13515,13516) ");
          }
          else if ("German".equals(language)) {
              sb.append("AND desc_values.DESC_TERMID_FK IN (3720) ");
              sb.append("AND (desc_values.DESC_QUALIFIERID_FK NOT IN (13510,13512,13515) ");
          }
          
          sb.append("OR (desc_values.DESC_QUALIFIERID_FK IS NULL)) ");
          sb.append("ORDER BY NLSSORT(desc_values.desc_value,'NLS_SORT=BINARY_CI')");
              
          try {
              if (ILog.ENABLED) {
                  stmt = new LoggableStatement(conn, sb.toString());
              } else {
                  stmt = conn.prepareStatement(sb.toString());
              }
    
              stmt.clearParameters();
              stmt.setInt(1, AegaronConstants.PROJECT_ID);
              stmt.setInt(2, AegaronConstants.COMPLETED);
              stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
              stmt.setInt(4, AegaronConstants.TERM_OBJECT_ID);
              
              if (ILog.ENABLED) {
                  System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
              }
    
              rset = stmt.executeQuery();

              List<Term> termList = new LinkedList<Term>();
              
              while (rset.next()) {
                  String ark = rset.getString("ITEM_ARK");                    
                  String nodeTitle = rset.getString("NODE_TITLE");
                  String descValue = rset.getString("DESC_VALUE");
                  String descTermId = rset.getString("DESC_TERMID_FK");
                  String descQualifierId = rset.getString("DESC_QUALIFIERID_FK");
                  
                  Term term = new Term();
                  term.setItemArk(ark);
                  
                  if ("English".equals(language)) {
                      // the preferred term is the title
                      if ("3721".equals(descTermId) && descQualifierId == null) {
                          term.setPreferredTerm(nodeTitle);
                      }
                      else if ("3720".equals(descTermId) && "13512".equals(descQualifierId)) {
                          term.setAlternateTerm(descValue);
                      }
                  }
                  
                  else if ("Arabic".equals(language)) {
                      if ("3720".equals(descTermId) && "13515".equals(descQualifierId)) {
                          term.setPreferredTerm(descValue);
                      }
                      else if ("3720".equals(descTermId) && "13510".equals(descQualifierId)) {
                          term.setAlternateTerm(descValue);
                      }
                  }
                  
                  else if ("German".equals(language)) {
                      if ("3720".equals(descTermId) && "13516".equals(descQualifierId)) {
                          term.setPreferredTerm(descValue);
                      }
                      else if ("3720".equals(descTermId) && "13511".equals(descQualifierId)) {
                          term.setAlternateTerm(descValue);
                      }
                  }
                  
                  termList.add(term);

              }
                            
              // Display some pool statistics
              if (ILog.ENABLED) { printDriverStats(); }
                            
              return termList.toArray(new Term[termList.size()]);
              
          } catch (Exception e) {
              e.printStackTrace();
          } finally {
              try { rset.close(); } catch(Exception e) { }
              try { stmt.close(); } catch(Exception e) { }
              try { conn.close(); } catch(Exception e) { }
          }
      }
              
      return null;
    }

    public Image[] getAllDrawings(final String keyword, final String state, final String ueePlaceID, final String featureType, final String view, final String drawing, final String period, final String startYear, final String endYear) {
      Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
      PreparedStatement stmt = null;
      ResultSet rset = null;
      String searchString = "AEGARON"; //default
      boolean hasKeyword = false;
      boolean hasState = false;
      boolean hasUeePlaceID = false;
      boolean hasStartYear = false;
      boolean hasEndYear = false;
      boolean hasFeatureType = false;
      boolean hasView = false;
      boolean hasDrawing = false;
      boolean hasPeriod = false;
      
      if (textHasContent(keyword)) {
          searchString = getKeywords(keyword.trim());
          hasKeyword = true;
          if (ILog.ENABLED) {
              System.out.println("Search String => " + searchString);
          }
      } 
      
      if (textHasContent(state)) {
          hasState = true;
      }
      
      if (textHasContent(ueePlaceID)) {
          hasUeePlaceID = true;
      }
      
      if (textHasContent(featureType)) {
          hasFeatureType = true;
      }
      
      if (textHasContent(startYear)) {
          hasStartYear = true;
      }
      
      if (textHasContent(endYear)) {
          hasEndYear = true;
      }
      
      if (textHasContent(view)) {
          hasView = true;
      }
      
      if (textHasContent(drawing)) {
          hasDrawing = true;
      }
      
      if (textHasContent(period)) {
          hasPeriod = true;
      }
      
      try {        
          // check db connection
          if (conn == null || conn.isClosed()) {
              //System.out.println("Reconnecting...");
              conn = DriverManager.getConnection(CONNECTION_STRING);
              //System.out.println("Done");
          }           
      } catch (Exception e) {
          e.printStackTrace();
      }
      
      if (conn != null) {
          StringBuilder sb = new StringBuilder("SELECT /* + FIRST_ROWS */  score(1), project_items.item_ark, content_files.file_name, content_files.file_groupid_fk, ");
          sb.append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/type/featureType/text()').getstringval ()) AS feature_type, ");
          sb.append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altTitle/planTitle/text()').getstringval ()) AS plan_title, ");
          sb.append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/type/state/text()').getstringval ()) AS type_state, ");
          sb.append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/subject/place/text()').getstringval ()) AS subject_place, ");
          sb.append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/subject/period/text()').getstringval ()) AS subject_period, ");
          sb.append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altIdentifier/ueePlaceID/text()').getstringval ()) AS uee_placeid, ");
          sb.append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/altIdentifier/drawing/text()').getstringval ()) AS drawing, ");
          sb.append("(EXTRACT (XMLTYPE (desc_clob),'/record/metadata/dc/description/view/text()').getstringval ()) AS description_view ");
          sb.append("FROM project_items, content_files ");
          sb.append("WHERE (project_items.divid_pk = content_files.divid_fk) ");
          sb.append("AND (project_items.projectid_fk = ?) AND (project_items.statusid_fk IN (?,?)) ");
          sb.append("AND (project_items.objectid_fk = ?)  AND (content_files.file_use = ?) ");
          sb.append("AND (contains (desc_clob, ?, 1) > 0) ");

          if (hasState) {
              sb.append("AND (contains (desc_clob, '").append(state.trim()).append(" WITHIN state') > 0) ");
          }
          
          if (hasUeePlaceID) {
              sb.append("AND (contains (desc_clob, '").append(Integer.valueOf(ueePlaceID)).append(" WITHIN ueePlaceID') > 0) ");
          }
          
          if (hasFeatureType) {
              sb.append("AND (contains (desc_clob, '").append(featureType.trim()).append(" WITHIN featureType') > 0) ");
          }
          
          if (hasView) {
              sb.append("AND (contains (desc_clob, '").append(view.trim()).append(" WITHIN view') > 0) ");
          }
          
          if (hasDrawing) {
              sb.append("AND (contains (desc_clob, '").append(drawing.trim()).append(" WITHIN drawing') > 0) ");
          }
          
          if (hasPeriod) {
              sb.append("AND (contains (desc_clob, '").append(period.trim()).append(" WITHIN period') > 0) ");
          }
          
          sb.append("ORDER BY score(1) DESC, subject_place, plan_title, description_view, type_state, drawing ASC");

    
          try {
              if (ILog.ENABLED) {
                  stmt = new LoggableStatement(conn, sb.toString());
              } else {
                  stmt = conn.prepareStatement(sb.toString());
              }
    
              stmt.clearParameters();
              stmt.setInt(1, AegaronConstants.PROJECT_ID);
              stmt.setInt(2, AegaronConstants.COMPLETED);
              stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
              stmt.setInt(4, AegaronConstants.PLAN_OBJECT_ID);
              stmt.setString(5, AegaronConstants.FILE_USE[1]);
              stmt.setString(6, searchString);
              
              if (ILog.ENABLED) {
                  System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
              }
    
              rset = stmt.executeQuery();
    
              Map<String,Image> map = new LinkedHashMap<String,Image>();
              String ark = "";
              String fname = "";
              Image image;
              List<String> subjectPeriodList = new ArrayList<String>();
              List<String> descriptionViewList = new ArrayList<String>();
              
              while (rset.next()) {
                  fname = rset.getString("FILE_NAME"); 
                  ark = rset.getString("ITEM_ARK");                       
                  int fileGroupID = rset.getInt("FILE_GROUPID_FK");
                  
                  if (map.containsKey(ark)) {
                      // update existing Image
                      image = map.get(ark);
                      
                      // Thumbnail  
                      if (fname.endsWith(".tif")) {                            
                          image.setThumbnailUrl(AegaronConstants.THUMB_BASE_URL+fname.replaceAll(".tif",".jpg"));
                      }
                      // PDF Thumb
                      else if (fname.endsWith(".pdf") && fileGroupID == 1574) {
                          image.setPdfThumbUrl(AegaronConstants.PDF_BASE_URL+fname);
                      }
                      // PDF Drawing Log
                      else if (fname.endsWith(".pdf") && fileGroupID == 1575) {
                          image.setPdfDrawingLogUrl(AegaronConstants.PDF_BASE_URL+fname);
                      }
                      // CAD Drawing
                      else if (fname.endsWith(".dwg") && fileGroupID == 1690) {
                          image.setCadDrawingUrl(AegaronConstants.CAD_BASE_URL+fname);
                      }
                      // PNG Thumb to Scale
                      else if (fname.endsWith(".dwg") && fileGroupID == 1705) {
                          image.setThumbToScaleUrl(AegaronConstants.PNG_BASE_URL+fname);
                      }
                      
                      map.put(ark,image);
                      
                  } else {
                      // crete new Image
                      image = new Image();                        
                      image.setId(ark);
                      
                      String planTitle = rset.getString("plan_title");
                      String typeState = rset.getString("type_state");
                      String typeFeatureType = rset.getString("feature_type");
                      String subjectPlace = rset.getString("subject_place");
                      String subjectPeriod = rset.getString("subject_period");
                      String ueePlaceId = rset.getString("uee_placeid");
                      String altIdentifierDrawing = rset.getString("drawing");
                      String descriptionView = rset.getString("description_view");
                      
                      if (planTitle != null) {
                          image.setPlanTitle( planTitle);
                      } else {
                          image.setPlanTitle("unknown");
                      }
                      if (ILog.ENABLED) {
                          if (planTitle != null) {
                              System.out.println("AltTitle.planTitle = " + planTitle);
                          } else {
                              System.out.println("AltTitle.planTitle is null.");
                          }
                      }
                                            
                      if (typeState != null) {
                          image.setState(typeState);
                      } else {
                          image.setState("unknown");
                      }
                      if (ILog.ENABLED) {
                          if (typeState != null) {
                              System.out.println("Type.state = " + typeState);
                          } else {
                              System.out.println("Type.state is null.");
                          }
                      }
                      
                      if (typeFeatureType != null) {
                          image.setFeatureType(typeFeatureType);
                      } else {
                          image.setFeatureType("unknown");
                      }
                      if (ILog.ENABLED) {
                          if (typeFeatureType != null) {
                              System.out.println("Type.featureType = " + typeFeatureType);
                          } else {
                              System.out.println("Type.featureType is null.");
                          }
                      }
                      
                      if (subjectPlace != null) {
                          image.setPlace(subjectPlace);
                      } else {
                          image.setPlace("unknown");
                      }
                      if (ILog.ENABLED) {
                          if (subjectPlace != null) {
                              System.out.println("Subject.place = " + subjectPlace);
                          } else {
                              System.out.println("Subject.place is null.");
                          }
                      }
                      
                      if (subjectPeriod != null) {
                          if (subjectPeriod.contains("Late Antiquity")) {
                              subjectPeriodList.add("Late Antiquity");
                          }
                          if (subjectPeriod.contains("Late Period")) {
                              subjectPeriodList.add("Late Period");
                          }
                          if (subjectPeriod.contains("Middle Kingdom")) {
                              subjectPeriodList.add("Middle Kingdom");
                          }
                          if (subjectPeriod.contains("New Kingdom")) {
                              subjectPeriodList.add("New Kingdom");
                          }
                          if (subjectPeriod.contains("Old Kingdom")) {
                              subjectPeriodList.add("Old Kingdom");
                          }
                          if (subjectPeriod.contains("Ptolemaic Period")) {
                              subjectPeriodList.add("Ptolemaic Period");
                          }
                          if (subjectPeriod.contains("Roman Period")) {
                              subjectPeriodList.add("Roman Period");
                          }

                          if (subjectPeriodList.size() > 1) {
                              image.setPeriod(StringUtils.join(subjectPeriodList, '/'));
                          } else {
                              image.setPeriod(subjectPeriod);
                          }
                          
                          subjectPeriodList.clear();

                      } else {
                          image.setPeriod("unknown");
                      }
                      if (ILog.ENABLED) {
                          if (subjectPeriod != null) {
                              System.out.println("Subject.period = " + subjectPeriod);
                          } else {
                              System.out.println("Subject.period is null.");
                          }
                      }
                      
                      if (ueePlaceId != null) {
                          image.setUeePlaceID(ueePlaceId);
                      } else {
                          image.setUeePlaceID("unknown");
                      }
                      if (ILog.ENABLED) {
                          if (ueePlaceId != null) {
                              System.out.println("altIdentifier.ueePlaceID = " + ueePlaceId);
                          } else {
                              System.out.println("altIdentifier.ueePlaceID is null.");
                          }
                      }
                      
                      if (altIdentifierDrawing != null) {
                          image.setDrawing(altIdentifierDrawing);
                      } else {
                          image.setDrawing("unknown");
                      }
                      if (ILog.ENABLED) {
                          if (altIdentifierDrawing != null) {
                              System.out.println("altIdentifier.drawing = " + altIdentifierDrawing);
                          } else {
                              System.out.println("altIdentifier.drawing is null.");
                          }
                      }
                      
                      if (descriptionView != null) {
                          if (descriptionView.equalsIgnoreCase("detailsection")){
                              descriptionViewList.add("detail");
                              descriptionViewList.add("section");
                          } else {
                              if (StringUtils.contains(descriptionView,"detail")) {
                                  descriptionViewList.add("detail");
                              }
                              if (StringUtils.contains(descriptionView,"elevation")) {
                                  descriptionViewList.add("elevation");
                              }
                              if (StringUtils.contains(descriptionView,"section A-A")) {
                                  descriptionViewList.add("section A-A");
                              }
                              if (StringUtils.contains(descriptionView,"section B-B")) {
                                  descriptionViewList.add("section B-B");
                              }
                              if (StringUtils.contains(descriptionView,"section C-C")) {
                                  descriptionViewList.add("section C-C");
                              }
                              if (StringUtils.contains(descriptionView,"general plan")) {
                                  descriptionViewList.add("general plan");
                              }
                              if (StringUtils.contains(descriptionView,"top view")) {
                                  descriptionViewList.add("top view");
                              }
                              if (StringUtils.contains(descriptionView,"east elevation")) {
                                  descriptionViewList.add("east elevation");
                              }
                              if (StringUtils.contains(descriptionView,"south elevation")) {
                                  descriptionViewList.add("south elevation");
                              }
                              if (StringUtils.contains(descriptionView,"west elevation")) {
                                  descriptionViewList.add("west elevation");
                              }
                          }
                          
                          if (descriptionViewList.size() > 1) {
                              image.setView(StringUtils.join(descriptionViewList, '/'));
                          } else {
                              image.setView(descriptionView);
                          }
                          
                          descriptionViewList.clear();
                          
                      } else {
                          image.setView("unknown");
                      }
                      if (ILog.ENABLED) {
                          if (descriptionView != null) {
                              System.out.println("Description.view = " + descriptionView);
                          } else {
                              System.out.println("Description.view is null.");
                          }
                      }
                      
                      if (fname.endsWith(".tif")) {                            
                          image.setThumbnailUrl(AegaronConstants.THUMB_BASE_URL+fname.replaceAll(".tif",".jpg"));
                      }
                      else if (fname.endsWith(".pdf") && fileGroupID == 1574) {
                          image.setPdfThumbUrl(AegaronConstants.PDF_BASE_URL+fname);
                      }
                      else if (fname.endsWith(".pdf") && fileGroupID == 1575) {
                          image.setPdfDrawingLogUrl(AegaronConstants.PDF_BASE_URL+fname);
                      } 
                      
                      map.put(ark, image);                        
                      
                  }
    
              }
              
              // Display some pool statistics
              if (ILog.ENABLED) { printDriverStats(); }
              
              return map.values().toArray(new Image[map.size()]);
          } catch (Exception e) {
              e.printStackTrace();
          } finally {
              try { rset.close(); } catch(Exception e) { }
              try { stmt.close(); } catch(Exception e) { }
              try { conn.close(); } catch(Exception e) { }
          }
      }
              
      return null;
    }
    
    public String repeat(String text) {
        return text;    
    }
    
    /**
     * Helper methods
     */    
     // Modify search string to include  "implied AND"
     private String getKeywords(String s) {
         if (s == null || "".equals(s.trim())) return s;
         
         StringBuilder sb = new StringBuilder();
         char firstChar = s.charAt(0);
     
         //check first char for quotes
         if ((firstChar != '\"') && (firstChar != '\'')) {
             StringTokenizer st = new StringTokenizer(s);
             List<String> wordList = new ArrayList<String>();
     
             while (st.hasMoreTokens()) {
                 wordList.add(st.nextToken());
             }
     
             int iNumOfWords = wordList.size();
             int iNextIndex = 0;
             boolean bLastWord = false;
     
             if (iNumOfWords > 1) {
                 for (int i = 0; i < iNumOfWords; i++) {
                     sb.append(wordList.get(i));
                     iNextIndex = i + 1;
     
                     if (iNextIndex == iNumOfWords) {
                         bLastWord = true;
                     }
     
                     if (!bLastWord) {
                         String strNextWord = wordList.get(iNextIndex);
     
                         if (strNextWord.equalsIgnoreCase("AND") ||
                             strNextWord.equalsIgnoreCase("OR") ||
                             strNextWord.equalsIgnoreCase("NOT")) {
                             sb.append(" " + strNextWord + " ");
                             i = i + 1; // move past this word in loop
                         } else {
                             sb.append(" AND ");
                         }
                     }
                 }
     
                 s = sb.toString();
             }
         }
     
         return s;

    }
        
    private String convertXML2JSON(String xml) throws Exception {
        String jsonString = null;
        XMLSerializer xmlSerializer = new XMLSerializer();
        xmlSerializer.setForceTopLevelObject(true);
        xmlSerializer.setTypeHintsEnabled(false);
        JSONObject json = (JSONObject) xmlSerializer.read(xml);
        jsonString = json.toString(2);
        return jsonString;
    }
    
    private boolean textHasContent(final String text ) {
        return (text != null) && (!"".equals(text.trim()));
    }
    
    private boolean isValidDate(final String sDate) {        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        sdf.setLenient(false);
        try {
          sdf.parse(sDate.trim());
        } catch (ParseException pe) {
          return false;
        }
        return true;
    }

    //TODO: Retrieves the Subject period for the specified item.
    public String getSubjectPeriod(final String ark) {
        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
        PreparedStatement stmt = null;
        ResultSet rset = null;
        String subjectPeriod = null;
        
        try {        
            // check db connection
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(CONNECTION_STRING);
            }           
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (conn != null) {
             StringBuilder sb = new StringBuilder("SELECT /*+ INDEX_JOIN(DESC_VALUES) */ core_desc_control_values.core_desc_cv AS subject_period ")
             .append("FROM project_items, desc_control_values, desc_values, core_desc_control_values ")
             .append("WHERE project_items.divid_pk = desc_values.divid_fk ")
             .append("AND desc_control_values.desc_cvid_pk = desc_values.desc_cvid_fk ")
             .append("AND core_desc_control_values.core_desc_cvid_pk = desc_control_values.core_desc_cvid_fk ")
             .append("AND project_items.item_ark = ? ")
             .append("AND project_items.projectid_fk = ? ")
             .append("AND project_items.statusid_fk IN (?,?) ")
             .append("AND desc_control_values.desc_termid_fk = ? ")
             .append("AND desc_values.desc_qualifierid_fk = ? ")
             .append("GROUP BY core_desc_control_values.core_desc_cv ")
             .append("ORDER BY core_desc_control_values.core_desc_cv ASC");

            try {
                if (ILog.ENABLED) {
                    stmt = new LoggableStatement(conn, sb.toString());
                } else {
                    stmt = conn.prepareStatement(sb.toString());
                }

                stmt.clearParameters();
                stmt.setString(1, ark);
                stmt.setInt(2, AegaronConstants.PROJECT_ID);
                stmt.setInt(3, AegaronConstants.COMPLETED);
                stmt.setInt(4, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
                stmt.setInt(5, AegaronConstants.SUBJECT);
                stmt.setInt(6, AegaronConstants.PERIOD);

                if (ILog.ENABLED) {
                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
                }

                rset = stmt.executeQuery();

                List<String> list = new ArrayList<String>();
                while (rset.next()) {
                    String period = rset.getString("subject_period");
                    if (subjectPeriod != null) {
                        list.add(period);
                    }
                }
                                                
                subjectPeriod = StringUtils.join(list, '|');
                
                // Display some pool statistics and delimited string
                if (ILog.ENABLED) { 
                    System.out.println("Delimited Subject.period => " + subjectPeriod);
                    for (String period: list) {
                        System.out.println(period);
                    }
                    printDriverStats();
                }
                /*
                if (!list.isEmpty()) {
                    list.clear();
                }*/
                
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { rset.close(); } catch(Exception e) { }
                try { stmt.close(); } catch(Exception e) { }
                try { conn.close(); } catch(Exception e) { }
            }
        }
                
        return subjectPeriod;
    }

    // TODO
    public String getTerm(final String arkid) {
      if (arkid == null || "".equals(arkid.trim())) {
            return null;    
      }
      
      Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
      PreparedStatement stmt = null;
      ResultSet rset = null;
      
      // root elements 
      Element term = new Element("term");
      Document document = new Document(term);
      
      try {        
          // check db connection
          if (conn == null || conn.isClosed()) {
              //System.out.println("Reconnecting...");
              conn = DriverManager.getConnection(CONNECTION_STRING);
              //System.out.println("Done");
          }           
      } catch (Exception e) {
          e.printStackTrace();
      }
      
      if (conn != null) {
          StringBuilder sb = new StringBuilder("SELECT PROJECT_ITEMS.DIVID_PK, ")
          .append("VW_ITEM_METADATA.TEXT_VALUE, ")
          .append("VW_ITEM_METADATA.QUALIFIER_LABEL, ") 
          .append("VW_ITEM_METADATA.DESC_TERM_LABEL, ")
          .append("VW_ITEM_METADATA.DESC_TERMID_ID, ")
          .append("VW_ITEM_METADATA.DESC_QUALIFIERS_ID, ")
          .append("VW_ITEM_METADATA.CORE_DESC_TERM ")
          .append("FROM PROJECT_ITEMS, VW_ITEM_METADATA ")
          .append("WHERE (PROJECT_ITEMS.DIVID_PK = VW_ITEM_METADATA.ITEM_ID) ")
          .append("AND PROJECT_ITEMS.PROJECTID_FK = ? ")
          .append("AND PROJECT_ITEMS.STATUSID_FK IN (?,?) ")
          .append("AND PROJECT_ITEMS.OBJECTID_FK = ? ")
          .append("AND PROJECT_ITEMS.ITEM_ARK = ? ")
          .append("AND VW_ITEM_METADATA.CORE_DESC_TERMID_ID IN (1,2,7,13) ")
          .append("ORDER BY VW_ITEM_METADATA.CORE_DESC_TERMID_ID ASC");
                       
          try {
              if (ILog.ENABLED) {
                  stmt = new LoggableStatement(conn, sb.toString());
              } else {
                  stmt = conn.prepareStatement(sb.toString());
              }
    
              stmt.clearParameters();
              stmt.setInt(1, AegaronConstants.PROJECT_ID);
              stmt.setInt(2, AegaronConstants.COMPLETED);
              stmt.setInt(3, AegaronConstants.COMPLETED_WITH_MINIMAL_METADATA);
              stmt.setInt(4, AegaronConstants.TERM_OBJECT_ID);
              stmt.setString(5, arkid);
              
              if (ILog.ENABLED) {
                  System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
              }
    
              rset = stmt.executeQuery();
              int divId = 0;
              String aatUrl = "";
              String aatValue = "";
              List<String> categoryList = new LinkedList<String>();
              List<String> englishTermList = new LinkedList<String>();
              List<String> germanTermList = new LinkedList<String>();
              List<String> arabicTermList = new LinkedList<String>();
              List<String> englishPreferredList = new LinkedList<String>();
              List<String> germanPreferredList = new LinkedList<String>();
              List<String> arabicPreferredList = new LinkedList<String>();
              
              Element relationships = new Element("relationships");
              
              while (rset.next()) {
                  divId = rset.getInt("DIVID_PK");
                  String textValue = rset.getString("TEXT_VALUE");                    
                  String qualifierLabel = rset.getString("QUALIFIER_LABEL");
                  String descTermLabel = rset.getString("DESC_TERM_LABEL");
                  String coreDescTerm = rset.getString("CORE_DESC_TERM");
                  String descTermId = rset.getString("DESC_TERMID_ID");

                  if ("Title".equals(coreDescTerm) && "3721".equals(descTermId)) {
                      Element title = new Element("title");
                      title.setAttribute(new Attribute("lang", "en"));
                      title.setText(textValue);
                      term.addContent(title);
                      englishPreferredList.add(textValue);
                  }
                  else if ("English_alternate".equalsIgnoreCase(qualifierLabel)) {
                      Element altTitle = new Element("alttitle");
                      altTitle.setAttribute(new Attribute("lang", "en"));
                      altTitle.setAttribute(new Attribute("preferred", "false"));
                      altTitle.setText(textValue);
                      term.addContent(altTitle);
                  }
                  else if ("AltTitle".equals(coreDescTerm) && "German_alternate".equalsIgnoreCase(qualifierLabel)) {
                      Element altTitle = new Element("alttitle");
                      altTitle.setAttribute(new Attribute("lang", "de"));
                      altTitle.setAttribute(new Attribute("preferred", "false"));
                      altTitle.setText(textValue);
                      term.addContent(altTitle);
                  }
                  else if ("AltTitle".equals(coreDescTerm) && "German_preferred".equalsIgnoreCase(qualifierLabel)) {
                      Element altTitle = new Element("alttitle");
                      altTitle.setAttribute(new Attribute("lang", "de"));
                      altTitle.setAttribute(new Attribute("preferred", "true"));
                      altTitle.setText(textValue);
                      term.addContent(altTitle);
                      germanPreferredList.add(textValue);
                  }
                  else if ("AltTitle".equals(coreDescTerm) && "Arabic_preferred".equalsIgnoreCase(qualifierLabel)) {
                      Element altTitle = new Element("alttitle");
                      altTitle.setAttribute(new Attribute("lang", "ar"));
                      altTitle.setAttribute(new Attribute("preferred", "true"));
                      altTitle.setText(textValue);
                      term.addContent(altTitle);
                      arabicPreferredList.add(textValue);
                  }
                  else if ("AltTitle".equals(coreDescTerm) && "Arabic_alternate".equalsIgnoreCase(qualifierLabel)) {
                      Element altTitle = new Element("alttitle");
                      altTitle.setAttribute(new Attribute("lang", "ar"));
                      altTitle.setAttribute(new Attribute("preferred", "false"));
                      altTitle.setText(textValue);
                      term.addContent(altTitle);                      
                  }
                  else if ("Publisher".equals(coreDescTerm) && "4580".equals(descTermId)) {
                      categoryList.add(textValue);
                  }
                  else if ("Relation".equals(coreDescTerm) && "Relationships".equalsIgnoreCase(descTermLabel) && "url".equalsIgnoreCase(qualifierLabel)) {
                      aatUrl = textValue;
                  }
                  else if ("Relation".equals(coreDescTerm) && "Relationships".equalsIgnoreCase(descTermLabel) && "AAT".equalsIgnoreCase(qualifierLabel)) {
                      aatValue = textValue;
                  }
                  else if ("Relation".equals(coreDescTerm) && "Relationships".equalsIgnoreCase(descTermLabel) && qualifierLabel!= null && "parent_English".equalsIgnoreCase(qualifierLabel)) {
                      englishTermList.add(textValue);
                  }
                  else if ("Relation".equals(coreDescTerm) && "Relationships".equals(descTermLabel) && "parent_German".equals(qualifierLabel)) {
                      germanTermList.add(textValue);
                  }
                  else if ("Relation".equals(coreDescTerm) && "Relationships".equals(descTermLabel) && "parent_Arabic".equals(qualifierLabel)) {
                      arabicTermList.add(textValue);
                  }
                  else if ("Relation".equals(coreDescTerm) && "Relationships".equals(descTermLabel) && "plan".equals(qualifierLabel)) {
                      Element relationship = new Element("relationship");
                      relationship.setAttribute(new Attribute("type", "plan"));
                      relationship.setAttribute(new Attribute("arkid", textValue));
                      relationship.setText(textValue);
                      relationships.addContent(relationship);
                  }
  
              }

              Element categories = new Element("categories");
              term.addContent(categories);
              
              for (String s: categoryList){
                  Element category = new Element("category");
                  category.setText(s);
                  categories.addContent(category);
              }
              
              // English referred IDs for parent
              for (String englishTerm: englishTermList){
                  Term[] englishReferredIds = getReferredArkIds(englishTerm, "en", "parent");
                  
                  if (ILog.ENABLED) {
                      System.out.println(">>>DEBUG: Found " + englishReferredIds.length + " english referred IDs.");
                  }                    
                  
                  for (Term t: englishReferredIds) {
                      Element relationship = new Element("relationship");
                      relationship.setAttribute(new Attribute("type", "parent"));
                      relationship.setAttribute(new Attribute("lang", "en"));
                      relationship.setAttribute(new Attribute("arkid", t.getItemArk()));
                      relationship.setText(t.getPreferredTerm());
                      relationships.addContent(relationship);
                  }
                  
              }
              
              // German referred IDs for parent
              for (String germanTerm: germanTermList){
                  Term[] germanReferredIds = getReferredArkIds(germanTerm, "de", "parent");
                  
                  if (ILog.ENABLED) {
                      System.out.println(">>>DEBUG: Found " + germanReferredIds.length + " german referred IDs.");
                  }                    
                  
                  for (Term t: germanReferredIds) {
                      Element relationship = new Element("relationship");
                      relationship.setAttribute(new Attribute("type", "parent"));
                      relationship.setAttribute(new Attribute("lang", "de"));
                      relationship.setAttribute(new Attribute("arkid", t.getItemArk()));
                      relationship.setText(t.getPreferredTerm());
                      relationships.addContent(relationship);
                  }
                  
              }
              
              // Arabic referred IDs for parent
              for (String arabicTerm: arabicTermList){
                  Term[] arabicReferredIds = getReferredArkIds(arabicTerm, "ar", "parent");
                  
                  if (ILog.ENABLED) {
                      System.out.println(">>>DEBUG: Found " + arabicReferredIds.length + " arabic referred IDs.");
                  }                    
                  
                  for (Term t: arabicReferredIds) {
                      Element relationship = new Element("relationship");
                      relationship.setAttribute(new Attribute("type", "parent"));
                      relationship.setAttribute(new Attribute("lang", "ar"));
                      relationship.setAttribute(new Attribute("arkid", t.getItemArk()));
                      relationship.setText(t.getPreferredTerm());
                      relationships.addContent(relationship);
                  }
                  
              }

              // English preferred child IDs
              for (String englishPreferredTerm: englishPreferredList){
                  Term[] englishChildIds = getReferredArkIds(englishPreferredTerm, "en", "child");
                  
                  if (ILog.ENABLED) {
                      System.out.println(">>>DEBUG: Found " + englishChildIds.length + " english preferred child IDs.");
                  }                    
                  
                  for (Term t: englishChildIds) {
                      Element relationship = new Element("relationship");
                      relationship.setAttribute(new Attribute("type", "child"));
                      relationship.setAttribute(new Attribute("lang", "en"));
                      relationship.setAttribute(new Attribute("arkid", t.getItemArk()));
                      relationship.setText(t.getPreferredTerm());
                      relationships.addContent(relationship);
                  }
                  
              }
              
              // German preferred child IDs
              for (String germanPreferredTerm: germanPreferredList){
                  Term[] germanChildIds = getReferredArkIds(germanPreferredTerm, "de", "child");
                  
                  if (ILog.ENABLED) {
                      System.out.println(">>>DEBUG: Found " + germanChildIds.length + " german preferred child IDs.");
                  }                    
                  
                  for (Term t: germanChildIds) {
                      Element relationship = new Element("relationship");
                      relationship.setAttribute(new Attribute("type", "child"));
                      relationship.setAttribute(new Attribute("lang", "de"));
                      relationship.setAttribute(new Attribute("arkid", t.getItemArk()));
                      relationship.setText(t.getPreferredTerm());
                      relationships.addContent(relationship);
                  }
                  
              }

              // Arabic preferred child IDs
              for (String arabicPreferredTerm: arabicPreferredList){
                  Term[] arabicChildIds = getReferredArkIds(arabicPreferredTerm, "ar", "child");
                  
                  if (ILog.ENABLED) {
                      System.out.println(">>>DEBUG: Found " + arabicChildIds.length + " arabic preferred child IDs.");
                  }                    
                  
                  for (Term t: arabicChildIds) {
                      Element relationship = new Element("relationship");
                      relationship.setAttribute(new Attribute("type", "child"));
                      relationship.setAttribute(new Attribute("lang", "ar"));
                      relationship.setAttribute(new Attribute("arkid", t.getItemArk()));
                      relationship.setText(t.getPreferredTerm());
                      relationships.addContent(relationship);
                  }
                  
              }
              
              term.addContent(relationships);

              Element aat = new Element("aat");
              aat.setAttribute(new Attribute("url", aatUrl));
              aat.setText(aatValue);
              term.addContent(aat);

              Element images = new Element("images");
              term.addContent(images);
              
              ContentFile[] contentFiles = getContentFile(divId);
              for (ContentFile cf: contentFiles) {
                  Element image = new Element("image");
                  image.setAttribute(new Attribute("contentFileId", cf.getContentFileId()));
                  image.setText(cf.getThumbnailUrl());
                  images.addContent(image);
              }
              
              XMLOutputter xmlOutputer = new XMLOutputter();
                  
              if (ILog.ENABLED) {
                  try {
                      // pretty format the output
                      xmlOutputer.setFormat(Format.getPrettyFormat());
                      xmlOutputer.output(document, System.out);
                  } catch (IOException e) {
                      e.printStackTrace();
                  }
              }
             
             // clean up! 
             if (!categoryList.isEmpty()){
                 categoryList.clear();
             }
             if (!englishTermList.isEmpty()) {
                 englishTermList.clear();
             }
             if (!germanTermList.isEmpty()) {
                 germanTermList.clear();
             }
             if (!arabicTermList.isEmpty()) {
                 arabicTermList.clear();
             }
             if (!englishPreferredList.isEmpty()) {
                 englishPreferredList.clear();
             }
             if (!germanPreferredList.isEmpty()) {
                germanPreferredList.clear();
             }
             if (!arabicPreferredList.isEmpty()) {
                arabicPreferredList.clear();
             }
             
             return xmlOutputer.outputString(document);
              
          } catch (Exception e) {
              e.printStackTrace();
          } finally {
              try { rset.close(); } catch(Exception e) { }
              try { stmt.close(); } catch(Exception e) { }
              try { conn.close(); } catch(Exception e) { }
          }
      }
              
      return null;
    }

//    private String getContentFileId(final String ark) {
//        String fileId = null;
//        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
//        PreparedStatement stmt = null;
//        ResultSet rset = null;
//        
//        try {        
//            // check db connection
//            if (conn == null || conn.isClosed()) {
//                //System.out.println("Reconnecting...");
//                conn = DriverManager.getConnection(CONNECTION_STRING);
//                //System.out.println("Done");
//            }           
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        
//        if (conn != null) {
//            StringBuilder sb = new StringBuilder("SELECT content_files.fileid_pk ") 
//            .append("FROM project_items LEFT OUTER JOIN content_files ")
//            .append("ON project_items.divid_pk = content_files.divid_fk ")
//            .append("WHERE (project_items.item_ark = ?) ")
//            .append("AND (content_files.file_use = ?)");
//
//            try {               
//                if (ILog.ENABLED) {
//                    stmt = new LoggableStatement(conn, sb.toString());
//                } else {
//                    stmt = conn.prepareStatement(sb.toString());
//                }
//                stmt.clearParameters();
//                stmt.setString(1, ark);
//                stmt.setString(2, AegaronConstants.FILE_USE[2]);
//                
//                if (ILog.ENABLED) {
//                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
//                }
//
//                rset = stmt.executeQuery();
//
//                if (rset.next()) {
//                    fileId = rset.getString("FILEID_PK");
//                }
//
//            } catch (SQLException e) {
//                e.printStackTrace();
//            } finally {
//                try { rset.close(); } catch(Exception e) { }
//                try { stmt.close(); } catch(Exception e) { }
//                try { conn.close(); } catch(Exception e) { }
//            }
//        }
//        return fileId;
//    }

    //    private static String readClob(ResultSet rs, String fieldName) throws SQLException {
    //            String text = null;
    //            Clob clob = rs.getClob(fieldName);
    //            int length = (int) clob.length();
    //            text = clob.getSubString(1, length);
    //            return text;
    //    }
    //
    //    private static String readBlobUTF16BinaryStream(ResultSet rs,
    //                                                    String fieldName) throws SQLException,
    //                                                                             IOException {
    //            Blob clob = rs.getBlob(fieldName);
    //
    //            InputStream is = clob.getBinaryStream();
    //            StringBuilder sb = new StringBuilder();
    //
    //            int bytesRead;
    //            int bufferSize = 4096;
    //
    //            do {
    //                byte[] bytes = new byte[bufferSize];
    //
    //                bytesRead = is.read(bytes);
    //
    //                if (bytesRead > 0) {
    //                    String read = new String(bytes, 0, bytesRead, "UTF-16");
    //                    sb.append(read);
    //                }
    //            } while (bytesRead == bufferSize);
    //
    //            is.close();
    //            return sb.toString();
    //        }

//    private void setSiteContent(final int divid, Site Site) {
//        //String flocat = null;
//        Connection conn = (Connection)MessageContext.getCurrentMessageContext().getProperty(AegaronServiceLifeCycle.DB_CONNECTION);
//        PreparedStatement stmt = null;
//        ResultSet rset = null;
//        
//        try {        
//            // check db connection
//            if (conn == null || conn.isClosed()) {
//                //System.out.println("Reconnecting...");
//                conn = DriverManager.getConnection(CONNECTION_STRING);
//                //System.out.println("Done");
//            }           
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        
//        if (conn != null) {
//            String sql = "SELECT file_name, TO_CHAR(content_files.create_date, 'MM/DD/YYYY HH:MI:SS AM') AS datetime FROM content_files WHERE divid_fk = ? and file_use = ?";
//
//            try {
//                if (ILog.ENABLED) {
//                    stmt = new LoggableStatement(conn, sql);
//                } else {
//                    stmt = conn.prepareStatement(sql);
//                }
//                stmt.clearParameters();
//                stmt.setInt(1, divid);
//                stmt.setString(2, AegaronConstants.FILE_USE[1]);
//
//                if (ILog.ENABLED) {
//                    System.out.println("Executing query: " + ((LoggableStatement)stmt).getQueryString());
//                }
//
//                rset = stmt.executeQuery();
//
//                while (rset.next()) {
//                    String fname = rset.getString("FILE_NAME");
//                    String createDate = rset.getString("datetime");
//                    if (fname.endsWith(".xml")) {
//                        Site.setXmlURL(AegaronConstants.XML_BASE_URL+fname);
//                        Site.setXmlCreateDate(createDate);
//                    }
//                    else if (fname.endsWith(".pdf")) {
//                        Site.setPdfURL(AegaronConstants.PDF_BASE_URL+fname);
//                        Site.setPdfCreateDate(createDate);
//                    }
//                }
//
//            } catch (SQLException e) {
//                e.printStackTrace();
//            } finally {
//                try { rset.close(); } catch(Exception e) { }
//                try { stmt.close(); } catch(Exception e) { }
//                try { conn.close(); } catch(Exception e) { }
//            }
//        }
//        //return flocat;
//    }
    
    
        
    //    private static List getTags(String xml) {
    //        SAXBuilder builder;
    //        Document doc;
    //        List tags = null;
    //
    //        try {
    //            builder = new SAXBuilder();
    //            doc = builder.build(new StringReader(xml));
    //            tags = doc.getRootElement().getChildren();
    //        } catch (JDOMException jdome) {
    //            System.out.println("Error getting tag: " + jdome.getMessage());
    //        } catch (IOException ioe) {
    //            System.out.println("Error loading XML: " + ioe.getMessage());
    //        }
    //
    //        return tags;
    //    }

    //     private static Date getDate(final String dateTime, final String format) {
    //         SimpleDateFormat dateFormat = new SimpleDateFormat(format);
    //         try {
    //             return dateFormat.parse(dateTime);
    //         } catch (ParseException exception) {
    //            return null;
    //         }
    //     }
    //
    //    private static java.util.Date getDateTime( Object value ) throws ParseException {
    //           if( value == null ) return null;
    //           if( value instanceof java.util.Date ) return (java.util.Date)value;
    //           if( value instanceof String )
    //           {
    //               if( "".equals( (String)value ) ) return null;
    //               return DATETIME_FORMAT.parse( (String)value );
    //           }
    //
    //           return DATETIME_FORMAT.parse( value.toString() );
    //    }
    private static class SortIgnoreCase implements Comparator<Object> {
         public int compare(Object o1, Object o2) {
                 String s1 = (String) o1;
                 String s2 = (String) o2;
                 return s1.toLowerCase().compareTo(s2.toLowerCase());
         }
    }   
    
    private static void printDriverStats() throws Exception {
        PoolingDriver driver = (PoolingDriver) DriverManager.getDriver(CONNECTION_STRING);
        ObjectPool connectionPool = driver.getConnectionPool("uee");
        
        System.out.println("NumActive: " + connectionPool.getNumActive());
        System.out.println("NumIdle: " + connectionPool.getNumIdle());
    }
    
}
