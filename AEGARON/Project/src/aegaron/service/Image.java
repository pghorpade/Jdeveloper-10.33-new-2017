package aegaron.service;


/**
 * Ancient Egyptian Architecture Online (Aegaron) drawing (a.k.a. image) object.
 */
public class Image {
    private String id;
    private String imageDateModified;
    private String pdfUrl;
    private String thumbnailUrl;
    private String pdfThumbUrl;
    private String pdfDrawingLogUrl;
    private String cadDrawingUrl;
    private String thumbToScaleUrl;
    private String planTitle;
    private String state;
    private String place;
    private String period;
    private String ueePlaceID;
    private String featureType;
    private String view;
    private String drawing;

    @Override
    public String toString() {
        return "Image [id=" + id + 
               ", imageDateModified=" + imageDateModified + 
               ", pdfUrl=" + pdfUrl + 
               ", thumbnailUrl=" + thumbnailUrl + 
               ", pdfThumbUrl=" + pdfThumbUrl + 
               ", pdfDrawingLogUrl=" + pdfDrawingLogUrl + 
               ", cadDrawingUrl=" + cadDrawingUrl + 
               ", thumbToScaleUrl=" + thumbToScaleUrl + 
               ", planTitle=" + planTitle + 
               ", state=" + state + 
               ", place=" + place + 
               ", period=" + period + 
               ", ueePlaceID=" + ueePlaceID + 
               ", featureType=" + featureType + 
               ", view=" + view + 
               ", drawing=" + drawing + 
               ']';

    }

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setImageDateModified(String dateStamp) {
        this.imageDateModified = dateStamp;
    }

    public String getImageDateModified() {
        return imageDateModified;
    }

    /*protected void setUrlList(List<String> urlList) {
        this.urlList = urlList;
    }*/

    /*protected List<String> getUrlList() {
        if (urlList == null) {
            urlList = new ArrayList<String>();
        }
        return urlList;
    }*/

    /*public String[] getUrl() {
        url = new String[urlList.size()];
        //url = (String[])urlList.toArray();
        for (int i = 0; i < url.length; i++) {
            System.our
        }

         //return (Image[])list.toArray(new Image[list.size()]);
        return url;
    }*/

    public void setPdfThumbUrl(String url1) {
        this.pdfThumbUrl = url1;
    }

    public String getPdfThumbUrl() {
        return pdfThumbUrl;
    }


    public void setPdfDrawingLogUrl(String pdfUrl2) {
        this.pdfDrawingLogUrl = pdfUrl2;
    }

    public String getPdfDrawingLogUrl() {
        return pdfDrawingLogUrl;
    }

    public void setThumbnailUrl(String thumbnailURL) {
        this.thumbnailUrl = thumbnailURL;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setPlanTitle(String planTitle) {
        this.planTitle = planTitle;
    }

    public String getPlanTitle() {
        return planTitle;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getState() {
        return state;
    }

    public void setPlace(String place) {
        this.place = place;
    }

    public String getPlace() {
        return place;
    }

    public void setUeePlaceID(String ueePlaceID) {
        this.ueePlaceID = ueePlaceID;
    }

    public String getUeePlaceID() {
        return ueePlaceID;
    }

    public void setFeatureType(String featureType) {
        this.featureType = featureType;
    }

    public String getFeatureType() {
        return featureType;
    }

    public void setView(String view) {
        this.view = view;
    }

    public String getView() {
        return view;
    }

    public void setDrawing(String drawing) {
        this.drawing = drawing;
    }

    public String getDrawing() {
        return drawing;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    public String getPeriod() {
        return period;
    }

    public void setPdfUrl(String pdfUrl) {
        this.pdfUrl = pdfUrl;
    }

    public String getPdfUrl() {
        return pdfUrl;
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
    }*/

    public void setCadDrawingUrl(String cadDrawingURL) {
        this.cadDrawingUrl = cadDrawingURL;
    }

    public String getCadDrawingUrl() {
        return cadDrawingUrl;
    }

    public void setThumbToScaleUrl(String thumbToScaleURL) {
        this.thumbToScaleUrl = thumbToScaleURL;
    }

    public String getThumbToScaleUrl() {
        return thumbToScaleUrl;
    }
}
