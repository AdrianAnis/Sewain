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
public class Report {

    private int reportId;
    private User reportedBy;
    private Property reportedObject;
    private String reason;
    private String status;
    private Date date;

    public void submitReport() {
        System.out.println("Laporan berhasil dikirim");
    }

    public String getStatus() {
        return status;
    }

    public void updateStatus(String status) {
        this.status = status;
    }
}
