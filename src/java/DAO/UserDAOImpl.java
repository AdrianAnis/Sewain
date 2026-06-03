/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import database.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import model.User;
import model.Tenant;

/**
 *
 * @author Lenovo
 */
public class UserDAOImpl implements UserDAO {

    // 1. Logika untuk Register (Memasukkan data user baru)
    @Override
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (name, email, password, phone, role) VALUES (?, ?, ?, ?, ?)";
        
        // Try-with-resources: conn dan stmt otomatis di-close oleh Java jika sudah selesai
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getRole().toLowerCase()); // Menyimpan string 'tenant' atau 'owner' (lowercase agar cocok dengan enum)
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0; // Mengembalikan true jika berhasil input data
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false; // Mengembalikan false jika terjadi error (misal email duplikat)
        }
    }

    // 2. Logika untuk Login (Mencocokkan data akun)
    @Override
    public User loginUser(String emailOrUsername, String password) {
        String sql = "SELECT * FROM users WHERE (email = ? OR name = ?) AND password = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, emailOrUsername);
            stmt.setString(2, emailOrUsername);
            stmt.setString(3, password);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    // KUNCI PERUBAHAN: Kita return dalam bentuk objek Tenant yang sudah nyata
                    return new Tenant(
                        String.valueOf(rs.getInt("userId")),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("role")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Mengembalikan null jika password salah atau akun tidak ada
    }

    // 3. Method pelengkap dari interface (bisa dikosongkan dulu nilainya sementara waktu)
    @Override
    public User getUserById(String userId) {
        return null; 
    }

    // 4. Method pelengkap dari interface (bisa dikosongkan dulu nilainya sementara waktu)
    @Override
    public List<User> getAllUsers() {
        return null;
    }
}
