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

    protected int userId;
    protected String name;
    protected String email;
    protected String password;
    protected String phone;
    protected String role;

    public void login() {
        System.out.println(name + " berhasil login");
    }

    public void logout() {
        System.out.println(name + " berhasil logout");
    }

    public void getProfile() {
        System.out.println("Nama : " + name);
        System.out.println("Email : " + email);
        System.out.println("Role : " + role);
    }

    public void updateProfile() {
        System.out.println("Profil berhasil diperbarui");
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