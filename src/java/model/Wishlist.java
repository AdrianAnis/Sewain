/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.util.ArrayList;
/**
 *
 * @author Lenovo
 */
public class Wishlist {

    private int wishlistId;
    private Tenant tenant;
    private ArrayList<Property> propertyList;

    public Wishlist() {
        propertyList = new ArrayList<>();
    }

    public void addProperty(Property property) {
        propertyList.add(property);
    }

    public void removeProperty(Property property) {
        propertyList.remove(property);
    }

    public ArrayList<Property> getWishlist() {
        return propertyList;
    }
}
