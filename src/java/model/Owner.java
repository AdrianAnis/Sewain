package model;

public class Owner extends User {

    // Default Constructor
    public Owner() {
        super();
    }

    // Parameterized Constructor
    public Owner(String userId, String name, String email, String password, String phone, String role) {
        super(userId, name, email, password, phone, role);
    }

    public void viewReport() {
        System.out.println("[Owner] " + getName() + " (ID: " + getUserId() + ") melihat daftar laporan keluhan masuk.");
    }

    /**
     * Dipanggil saat owner mendaftarkan properti baru ke sistem.
     */
    public void addProperty(String propertyName) {
        System.out.println("[Owner] " + getName() + " (ID: " + getUserId() + ") mendaftarkan properti baru: " + propertyName);
    }

    /**
     * Dipanggil saat owner meninjau dashboard atau daftar properti miliknya.
     */
    public void viewProperty() {
        System.out.println("[Owner] " + getName() + " (ID: " + getUserId() + ") melihat daftar properti miliknya.");
    }

    /**
     * Dipanggil saat owner menyimpan hasil pengeditan data propertinya.
     */
    public void editProperty(int propertyId) {
        System.out.println("[Owner] " + getName() + " (ID: " + getUserId() + ") mengubah data properti ID: " + propertyId);
    }

    /**
     * Dipanggil saat owner menghapus salah satu properti miliknya.
     */
    public void deleteProperty(int propertyId) {
        System.out.println("[Owner] " + getName() + " (ID: " + getUserId() + ") menghapus properti ID: " + propertyId);
    }
}
