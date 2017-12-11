package aegaron.service;


/**
 * Ancient Egyptian Architecture Online (Aegaron) place object.
 */
public class Place {
    private String ueePlaceID;
    private String ueeFeatureID;

    @Override
    public String toString() {
        return "Place [ueePlaceID=" + ueePlaceID + 
               ", ueeFeatureID=" + ueeFeatureID + 
               ']';
    }

    public void setUeePlaceID(String ueePlaceID) {
        this.ueePlaceID = ueePlaceID;
    }

    public String getUeePlaceID() {
        return ueePlaceID;
    }

    public void setUeeFeatureID(String ueeFeatureID) {
        this.ueeFeatureID = ueeFeatureID;
    }

    public String getUeeFeatureID() {
        return ueeFeatureID;
    }

}
