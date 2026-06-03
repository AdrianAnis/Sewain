/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Lenovo
 */
public class Tenant extends User {

    // 1. TAMBAHKAN SAKLAR KOSONG (Constructor)
    public Tenant() {
        super(); // Ini artinya: "Eh Java, tolong siapkan sifat-sifat dasar dari kelas induk (User)"
    }

    // 2. TAMBAHKAN SAKLAR LENGKAP (Untuk menampung data dari database)
    public Tenant(String userId, String name, String email, String role) {
        super(userId, name, email, role);
    }

    // 3. TAMBAHKAN SAKLAR LENGKAP DENGAN PASSWORD
    public Tenant(String userId, String name, String email, String password, String role) {
        super(userId, name, email, password, role);
    }

    // ===== DI BAWAH INI ADALAH METHOD ASLI BAWAAN KAMU =====
    public void searchProperty() {
        System.out.println("Mencari property");
    }

    public void addToWishlist() {
        System.out.println("Menambahkan ke wishlist");
    }

    public void viewProperty() {
        System.out.println("Melihat detail property");
    }

    public void handleReport() {
        System.out.println("Melihat laporan");
    }

    public void reportProperty() {
        System.out.println("Melaporkan property");
    }
}
