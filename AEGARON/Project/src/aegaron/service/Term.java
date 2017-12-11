package aegaron.service;

public class Term {
    private String itemArk;
    private String preferredTerm;
    private String alternateTerm;
    private String thumbnailUrl;
    private String xmlMetadata;

    @Override
    public String toString() {
        return "Term [itemArk=" + itemArk +
                ", preferredTerm=" + preferredTerm +
                ", alternateTerm=" + alternateTerm +
                ", thumbnailUrl=" + thumbnailUrl +
                ", xmlMetadata=" + xmlMetadata +
                ']';
    }

    public void setItemArk(String itemArk) {
        this.itemArk = itemArk;
    }

    public String getItemArk() {
        return itemArk;
    }

    public void setPreferredTerm(String preferredTerm) {
        this.preferredTerm = preferredTerm;
    }

    public String getPreferredTerm() {
        return preferredTerm;
    }

    public void setAlternateTerm(String alternateTerm) {
        this.alternateTerm = alternateTerm;
    }

    public String getAlternateTerm() {
        return alternateTerm;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setXmlMetadata(String xmlMetadata) {
        this.xmlMetadata = xmlMetadata;
    }

    public String getXmlMetadata() {
        return xmlMetadata;
    }
}
