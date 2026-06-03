/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import java.util.List;
import model.User;
/**
 *
 * @author Lenovo
 */
public interface UserDAO {
    boolean registerUser(User user);
    User loginUser(String emailOrUsername, String password);
    User getUserById(String userId);
    List<User> getAllUsers(); 
}
