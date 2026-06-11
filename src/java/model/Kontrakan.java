package model;

public class Kontrakan extends Property {

    private int durasiMinimum;
    private int jumlahKamar;

    // Default Constructor
    public Kontrakan() {
        super();
    }

    // Parameterized Constructor (Class Diagram compliant)
    public Kontrakan(int propertyId, String name, String location, double price, String propertyType,
                     boolean availability, String verificationStatus, String flagStatus, String photos,
                     String description, String facilities,
                     int durasiMinimum, int jumlahKamar) {
        super(propertyId, name, location, price, propertyType, availability, verificationStatus, flagStatus, photos, description, facilities);
        this.durasiMinimum = durasiMinimum;
        this.jumlahKamar = jumlahKamar;
    }

    // Getters and Setters
    public int getJumlahKamar() {
        return jumlahKamar;
    }

    public void setJumlahKamar(int jumlahKamar) {
        this.jumlahKamar = jumlahKamar;
    }

    public int getDurasiMinimum() {
        return durasiMinimum;
    }

    public void setDurasiMinimum(int durasiMinimum) {
        this.durasiMinimum = durasiMinimum;
    }

    @Override
    public java.util.List<String> getSpecificDetails() {
        java.util.List<String> details = new java.util.ArrayList<>();
        details.add("Kamar Tidur: " + jumlahKamar);
        details.add("Min. Sewa: " + durasiMinimum + " Bulan");
        return details;
    }

    @Override
    public String toJson() {
        return "{" + buildBaseJson() + ","
                + "\"jumlahKamar\":" + jumlahKamar + ","
                + "\"durasiMinimum\":" + durasiMinimum
                + "}";
    }
}
