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
public class ActivityLog {

    private int logId;
    private User user;
    private String action;
    private Date timestamp;
    private String description;

    public void addLog() {
        System.out.println("Log ditambahkan");
    }

    public void getLogs() {
        System.out.println("Menampilkan log");
    }
}
