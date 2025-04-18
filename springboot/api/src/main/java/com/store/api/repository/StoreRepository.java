package com.store.api.repository;

import com.store.api.entity.Store;
import org.springframework.stereotype.Repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.util.List;

@Repository
@Transactional
public class StoreRepository {

    @PersistenceContext
    private EntityManager entityManager;

    public Store save(Store store) {
        if (store.getId() == null) {
            entityManager.persist(store);
            return store;
        } else {
            return entityManager.merge(store);
        }
    }

    public Store findById(Long id) {
        return entityManager.find(Store.class, id);
    }

    public List<Store> findAll() {
        return entityManager.createQuery("SELECT s FROM Store s", Store.class)
                .getResultList();
    }

    public void deleteById(Long id) {
        Store store = findById(id);
        if (store != null) {
            entityManager.remove(store);
        }
    }

    public long count() {
        return entityManager.createQuery("SELECT COUNT(s) FROM Store s", Long.class)
                .getSingleResult();
    }
    public List<Store> saveAll(List<Store> stores) {
        for (Store store : stores) {
            if (store.getId() == null) {
                entityManager.persist(store);
            } else {
                entityManager.merge(store);
            }
        }
        return stores;
    }
    
    public void deleteAll() {
        entityManager.createQuery("DELETE FROM Store s").executeUpdate();
    }
    
}
