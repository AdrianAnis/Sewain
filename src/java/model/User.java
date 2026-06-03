/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Lenovo
 */ 
public abstract class User implements Reportable {

    // Menggunakan protected agar bisa diturunkan langsung ke subclass (Tenant, Owner, Admin)
    protected String userId;
    protected String name;
    protected String email;
    protected String password;
    protected String phone;
    protected String role;

    // Constructor Kosong
    public User() {}

    // Constructor untuk memudahkan pengisian data dari Database tanpa password
    public User(String userId, String name, String email, String role) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.role = role;
    }

    // Constructor Lengkap dengan password
    public User(String userId, String name, String email, String password, String role) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
    }

    // ===== ENCAPSULATION: GETTER & SETTER (Wajib ada untuk Best Practice) =====
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public void login() {
        System.out.println(name + " berhasil login");
    }

    public void logout() {
        System.out.println(name + " berhasil logout");
    }

    public void getProfile() {
        System.out.println("Mendapatkan profil " + name);
    }

    public void updateProfile() {
        System.out.println("Memperbarui profil " + name);
    }

    @Override
    public void report() {
        System.out.println("Laporan dikirim");
    }

    @Override
    public String getReportStatus() {
        return "Pending";
    }
}