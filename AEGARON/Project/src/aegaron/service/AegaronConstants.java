package aegaron.service;

public interface AegaronConstants {
    /* Ancient Egyptian Architecture Online (Aegaron) */
    int PROJECT_ID = 301;
    
    /* Item statuses */
    int COMPLETED = 2;
    int COMPLETED_WITH_MINIMAL_METADATA = 10;
    
    /* Plan */
    int PLAN_OBJECT_ID = 925;
    /* Site */
    int SITE_OBJECT_ID = 926;
    /* Drawing */
    int DRAWING_OBJECT_ID = 1075;
    /* Term */
    int TERM_OBJECT_ID = 1140;
    
    /* English_alternate */
    int ENGLISH_ALTERNATE = 13512;
    
    /* Arabic_preferred */
    int ARABIC_PREFERRED = 13515;
    
    /* Arabic_alternate */
    int ARABIC_ALTERNATE = 13510;
    
    /* German_preferred */
    int GERMAN_PREFERRED = 13516;
    
    /* German_alternate */
    int GERMAN_ALTERNATE = 13511;
    
    /* Title */
    int TITLE = 3721;
    
    /* Alt Title */
    int ALT_TITLE = 3720;
    
    /* Classification */
    int PUBLISHER = 4580;
    
    /* Type.drawingType :  AEGARON */
    int TYPE = 3719;
    int DRAWING_TYPE_QUALIFIER_ID = 11115;
    int AEGARON_CONTROL_VALUE_ID = 474543;
    /* Type.featureType */
    int FEATURE_TYPE = 11119;
    
    /* AltIdentifier = DESC_TERMID */
    int ALT_IDENTIFIER = 3722;
    /* Subject.period */
    int SUBJECT = 3712;
    int PERIOD = 12401;
    
    
    /* AltIdentifier.ueePlaceID = DESC_QUALIFIERID */
    int ALT_IDENTIFIER_UEEPLACE_ID = 10663;
     
    /* AltIdentifier.ueeFeatureID */
    int ALT_IDENTIFIER_UEEFEATURE_ID = 11122;
    
    /* File use */
    String[] FILE_USE = {"Thumbnail", "Master", "Submaster" };
    
    /* Mime type */
    String MIME_TYPE = "text/xml";
    
    /* location type */
    String LOCATION_TYPE = "URL";
    
    /* dlcontent */
    String PDF_BASE_URL = "http://digital2.library.ucla.edu/dlcontent/aegaron/pdf/";
    String CAD_BASE_URL = "http://digital2.library.ucla.edu/dlcontent/aegaron/cad/";
    String PNG_BASE_URL = "http://digital2.library.ucla.edu/dlcontent/aegaron/png/";
    String XML_BASE_URL = "http://digital2.library.ucla.edu/dlcontent/aegaron/text/";
    String THUMB_BASE_URL = "http://digital2.library.ucla.edu/dlcontent/aegaron/nails/";
}
