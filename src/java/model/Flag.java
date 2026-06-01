/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.util.Date;
/**
 *
 * @author Lenovo
 */
public class Flag {

    private int flagId;
    private Property property;
    private String reason;
    private Date date;

    public void addFlag() {
        System.out.println("Flag ditambahkan");
    }

    public void removeFlag() {
        System.out.println("Flag dihapus");
    }

    public String getFlagInfo() {
        return reason;
    }
}