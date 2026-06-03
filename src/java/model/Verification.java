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
public class Verification {

    private int verificationId;
    private Property property;
    private String status;
    private Date date;

    public void approve() {
        status = "Approved";
    }

    public void reject() {
        status = "Rejected";
    }

    public String getStatus() {
        return status;
    }
}