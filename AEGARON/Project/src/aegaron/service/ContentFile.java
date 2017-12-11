package aegaron.service;

public class ContentFile {
    private String contentFileId;
    private String thumbnailUrl;

    @Override
    public String toString() {
        return "ContentFile [contentFileId=" + contentFileId +
                ", thumbnailUrl=" + thumbnailUrl +

                ']';
    }

    public void setContentFileId(String contentFileId) {
        this.contentFileId = contentFileId;
    }

    public String getContentFileId() {
        return contentFileId;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }
}
