package aegaron.service;

/**
 * Ancient Egyptian Architecture Online (AEGARON) plan object.
 */
public class Plan {
    private String id;
    private String title;
    private String thumbnailUrl;
    private String pdfThumbUrl;
    private String pdfDrawingLogUrl;
    private String cadDrawingUrl;
    private String thumbToScaleUrl;
    private String xmlMetadata;
    private String drawingNumber;
    
    @Override
    public String toString() {
        return "Plan [id=" + id +
                ", title=" + title +
                ", thumbnailUrl=" + thumbnailUrl +
                ", pdfThumbUrl=" + pdfThumbUrl +
                ", pdfDrawingLogUrl=" + pdfDrawingLogUrl +
                ", cadDrawingUrl=" + cadDrawingUrl +
                ", thumbToScaleUrl=" + thumbToScaleUrl +
                ", xmlMetadata=" + xmlMetadata +
                ", drawingNumber=" + drawingNumber +
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

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setPdfThumbUrl(String pdfThumbUrl) {
        this.pdfThumbUrl = pdfThumbUrl;
    }

    public String getPdfThumbUrl() {
        return pdfThumbUrl;
    }

    public void setPdfDrawingLogUrl(String pdfDrawingLogUrl) {
        this.pdfDrawingLogUrl = pdfDrawingLogUrl;
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

    public void setCadDrawingUrl(String cadDrawingUrl) {
        this.cadDrawingUrl = cadDrawingUrl;
    }

    public String getCadDrawingUrl() {
        return cadDrawingUrl;
    }

    public void setThumbToScaleUrl(String thumbToScaleUrl) {
        this.thumbToScaleUrl = thumbToScaleUrl;
    }

    public String getThumbToScaleUrl() {
        return thumbToScaleUrl;
    }

    public void setDrawingNumber(String drawingNumber) {
        this.drawingNumber = drawingNumber;
    }

    public String getDrawingNumber() {
        return drawingNumber;
    }
}
