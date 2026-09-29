package com.org;

public class User {
    private int id;
    private String username, email, password, role, profilePic;
    private Integer allotteeId;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getProfilePic() { return profilePic; }
    public void setProfilePic(String profilePic) { this.profilePic = profilePic; }
    public Integer getAllotteeId() { return allotteeId; }
    public void setAllotteeId(Integer allotteeId) { this.allotteeId = allotteeId; }
}