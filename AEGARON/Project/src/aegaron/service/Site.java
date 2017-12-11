package aegaron.service;

/**
 * Ancient Egyptian Architecture Online (Aegaron) site object.
 */
public class Site {
    private String id;
    private String title;
    private String ueePlaceId;
    private String subjectPlace;
    
    @Override
    public String toString() {
        return "Site [id=" + id + 
               ", title=" + title + 
               ", ueePlaceId=" + ueePlaceId + 
               ", subjectPlace=" + subjectPlace + 
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

    public void setUeePlaceId(String ueePlaceId) {
        this.ueePlaceId = ueePlaceId;
    }

    public String getUeePlaceId() {
        return ueePlaceId;
    }

    public void setSubjectPlace(String subjectPlace) {
        this.subjectPlace = subjectPlace;
    }

    public String getSubjectPlace() {
        return subjectPlace;
    }
}
