package aegaron.service;

public class Item {
    // Metadatata
    private String id;
    private String title;
    private String xmlMetadata;
    private String xmlPrintSizeA0MD;
    private String xmlPrintSizeA1MD;
    private String xmlPrintSizeA3MD;
    private String xmlPrintSizeA4LetterMD;

    // Content URL
    private String thumbnailUrl;
    private String pdfThumbUrl;    
    private String pdfDrawingLogUrl;
    private String pdfPrintSizeA0Url;
    private String pdfPrintSizeA1Url;
    private String pdfPrintSizeA3Url;
    private String pdfPrintSizeA4LetterUrl;
    private String thumbToScaleUrl;
    private String cadDrawingUrl;
   
    @Override
    public String toString() {
         return "Item [id=" + id +
                 ", title=" + title +
                 ", xmlMetadata=" + xmlMetadata +
                 ", xmlPrintSizeA0MD=" + xmlPrintSizeA0MD +
                 ", xmlPrintSizeA1MD=" + xmlPrintSizeA1MD +
                 ", xmlPrintSizeA3MD=" + xmlPrintSizeA3MD +
                 ", xmlPrintSizeA4LetterMD=" + xmlPrintSizeA4LetterMD +
                 ", thumbnailUrl=" + thumbnailUrl +
                 ", pdfThumbUrl=" + pdfThumbUrl +
                 ", pdfDrawingLogUrl=" + pdfDrawingLogUrl +
                 ", pdfPrintSizeA0Url=" + pdfPrintSizeA0Url +
                 ", pdfPrintSizeA1Url=" + pdfPrintSizeA1Url +
                 ", pdfPrintSizeA3Url=" + pdfPrintSizeA3Url +
                 ", pdfPrintSizeA4LetterUrl=" + pdfPrintSizeA4LetterUrl +
                 ", thumbToScaleUrl=" + thumbToScaleUrl +
                 ", cadDrawingUrl=" + cadDrawingUrl +
                 ']';
    }
    
    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public void setThumbnailUrl(String thumbnailURL) {
        this.thumbnailUrl = thumbnailURL;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setPdfThumbUrl(String pdfThumbURL) {
        this.pdfThumbUrl = pdfThumbURL;
    }

    public String getPdfThumbUrl() {
        return pdfThumbUrl;
    }

    public void setPdfDrawingLogUrl(String pdfDrawingLogURL) {
        this.pdfDrawingLogUrl = pdfDrawingLogURL;
    }

    public String getPdfDrawingLogUrl() {
        return pdfDrawingLogUrl;
    }

    public void setXmlMetadata(String xmlMetadata) {
        this.xmlMetadata = xmlMetadata;
    }

    public String getXmlMetadata() {
        return xmlMetadata;
    }

    public void setXmlPrintSizeA0MD(String xmlPrintSizeA0MD) {
        this.xmlPrintSizeA0MD = xmlPrintSizeA0MD;
    }

    public String getXmlPrintSizeA0MD() {
        return xmlPrintSizeA0MD;
    }

    public void setXmlPrintSizeA1MD(String xmlPrintSizeA1MD) {
        this.xmlPrintSizeA1MD = xmlPrintSizeA1MD;
    }

    public String getXmlPrintSizeA1MD() {
        return xmlPrintSizeA1MD;
    }

    public void setXmlPrintSizeA3MD(String xmlPrintSizeA3MD) {
        this.xmlPrintSizeA3MD = xmlPrintSizeA3MD;
    }

    public String getXmlPrintSizeA3MD() {
        return xmlPrintSizeA3MD;
    }

    public void setXmlPrintSizeA4LetterMD(String xmlPrintSizeA4LetterMD) {
        this.xmlPrintSizeA4LetterMD = xmlPrintSizeA4LetterMD;
    }

    public String getXmlPrintSizeA4LetterMD() {
        return xmlPrintSizeA4LetterMD;
    }

    public void setPdfPrintSizeA0Url(String pdfPrintSizeA0URL) {
        this.pdfPrintSizeA0Url = pdfPrintSizeA0URL;
    }

    public String getPdfPrintSizeA0Url() {
        return pdfPrintSizeA0Url;
    }

    public void setPdfPrintSizeA1Url(String pdfPrintSizeA1URL) {
        this.pdfPrintSizeA1Url = pdfPrintSizeA1URL;
    }

    public String getPdfPrintSizeA1Url() {
        return pdfPrintSizeA1Url;
    }

    public void setPdfPrintSizeA3Url(String pdfPrintSizeA3URL) {
        this.pdfPrintSizeA3Url = pdfPrintSizeA3URL;
    }

    public String getPdfPrintSizeA3Url() {
        return pdfPrintSizeA3Url;
    }

    public void setPdfPrintSizeA4LetterUrl(String pdfPrintSizeA4LetterURL) {
        this.pdfPrintSizeA4LetterUrl = pdfPrintSizeA4LetterURL;
    }

    public String getPdfPrintSizeA4LetterUrl() {
        return pdfPrintSizeA4LetterUrl;
    }

    /*
    public void setPdfDrawing100URL(String pdfDrawing100URL) {
        this.pdfDrawing100URL = pdfDrawing100URL;
    }

    public String getPdfDrawing100URL() {
        return pdfDrawing100URL;
    }

    public void setPdfDrawing250URL(String pdfDrawing250URL) {
        this.pdfDrawing250URL = pdfDrawing250URL;
    }

    public String getPdfDrawing250URL() {
        return pdfDrawing250URL;
    }

    public void setPdfDrawing500URL(String pdfDrawing500URL) {
        this.pdfDrawing500URL = pdfDrawing500URL;
    }

    public String getPdfDrawing500URL() {
        return pdfDrawing500URL;
    }

    public void setPdfDrawing2000URL(String pdfDrawing2000URL) {
        this.pdfDrawing2000URL = pdfDrawing2000URL;
    }

    public String getPdfDrawing2000URL() {
        return pdfDrawing2000URL;
    }

    public void setPdfToPrintIdealURL(String pdfToPrintIdealURL) {
        this.pdfToPrintIdealURL = pdfToPrintIdealURL;
    }

    public String getPdfToPrintIdealURL() {
        return pdfToPrintIdealURL;
    }

    public void setPdfPrintLetterURL(String pdfPrintLetterURL) {
        this.pdfPrintLetterURL = pdfPrintLetterURL;
    }

    public String getPdfPrintLetterURL() {
        return pdfPrintLetterURL;
    }
*/
    public void setThumbToScaleUrl(String thumbToScaleURL) {
        this.thumbToScaleUrl = thumbToScaleURL;
    }

    public String getThumbToScaleUrl() {
        return thumbToScaleUrl;
    }

    public void setCadDrawingUrl(String cadDrawingUrl) {
        this.cadDrawingUrl = cadDrawingUrl;
    }

    public String getCadDrawingUrl() {
        return cadDrawingUrl;
    }
}
