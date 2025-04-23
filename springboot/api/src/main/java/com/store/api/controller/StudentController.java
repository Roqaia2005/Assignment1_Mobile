package com.store.api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.store.api.entity.Student;
import com.store.api.repository.StudentRepository;

import java.util.Optional;

@RestController
@RequestMapping("/api/students")
@CrossOrigin("*")
public class StudentController {

    @Autowired
    private StudentRepository studentRepository;

    // @PostMapping("/signup")
    // public String signup(@RequestBody Student student) {
    //     if (studentRepository.findByEmail(student.getEmail()) != null) {
    //         return "Email already exists";
    //     }
    //     studentRepository.saveStudent(student);
    //     return "Signup successful";
    // }

    // @PostMapping("/login")
    // public String login(@RequestBody Student loginRequest) {
    //     Student student = studentRepository.findByEmail(loginRequest.getEmail());
    //     if (student != null && student.getPassword().equals(loginRequest.getPassword())) {
    //         return "Login successful";
    //     } else {
    //         return "Invalid email or password";
    //     }
    // }

    @GetMapping("/{id}")
    public Optional<Student> getStudentById(@PathVariable String id) {
        return studentRepository.findById(id);
    }
}
