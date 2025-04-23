package com.store.api.entity;

import jakarta.persistence.*;
import java.util.List;

@Entity
public class Student {
    @Id
    private String id;
    private String name;
    private String email;
    private String password;
    private String gender;
    private String level;
    private String image;

    @ElementCollection
    private List<Integer> favStores;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public List<Integer> getFavStores() {
        return favStores;
    }

    public void setFavStores(List<Integer> favStores) {
        this.favStores = favStores;
    }
}
