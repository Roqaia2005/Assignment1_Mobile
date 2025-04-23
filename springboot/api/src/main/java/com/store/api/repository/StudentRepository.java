package com.store.api.repository;

import com.store.api.entity.Student;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
@Transactional
public class StudentRepository {

    @PersistenceContext
    private EntityManager entityManager;

    public Student findByEmail(String email) {
        List<Student> results = entityManager
                .createQuery("SELECT s FROM Student s WHERE s.email = :email", Student.class)
                .setParameter("email", email)
                .getResultList();

        return results.isEmpty() ? null : results.get(0);
    }

    public Optional<Student> findById(String id) {
        Student student = entityManager.find(Student.class, id);
        return Optional.ofNullable(student);
    }

    // public String getStudentPassword(String id) {
    //     Optional<Student> optionalStudent = findById(id);
    //     if (optionalStudent.isPresent()) {
    //         return optionalStudent.get().getPassword();
    //     } else {
    //         return null;
    //     }
    // }
    

    // public Student saveStudent(Student student) {
    //     String studentId = ((Object) student).getId().isPresent(); 
    //     Optional<Student> existing = findById(studentId);
    
    //     if (existing.isPresent()) {
    //         return entityManager.merge(student); 
    //     } else {
    //         entityManager.persist(student);
    //         return student;
    //     }
    // }
    
}
