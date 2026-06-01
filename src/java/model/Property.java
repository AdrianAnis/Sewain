/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Lenovo
 */
public abstract class Property implements Reportable {

    protected int propertyId;
    protected String name;
    protected String location;
    protected double price;
    protected String description;
    protected String facilities;
    protected boolean availability;
    protected String verificationStatus;
    protected String flagStatus;
    protected String photos;

    public void getDetail() {
        System.out.println("Nama Property : " + name);
        System.out.println("Lokasi : " + location);
        System.out.println("Harga : " + price);
    }

    public void updateStatus() {
        System.out.println("Status property diperbarui");
    }

    @Override
    public void report() {
        System.out.println("Property dilaporkan");
    }

    @Override
    public String getReportStatus() {
        return "Pending";
    }
}
