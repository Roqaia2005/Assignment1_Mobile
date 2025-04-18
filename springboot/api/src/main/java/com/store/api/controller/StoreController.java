package com.store.api.controller;

import org.springframework.web.bind.annotation.*;

import com.store.api.entity.Store;
import com.store.api.repository.StoreRepository;

import java.util.List;

@RestController
@RequestMapping("/api/stores")
@CrossOrigin(origins = "*")
public class StoreController {

    private final StoreRepository storeRepository;

    public StoreController(StoreRepository storeRepository) {
        this.storeRepository = storeRepository;
    }

    @GetMapping
    public List<Store> getAllStores() {
        return storeRepository.findAll();
    }

    @PostMapping
    public Store addStore(@RequestBody Store store) {
        return storeRepository.save(store);
    }
    @PostMapping("/bulk")
    public List<Store> addStores(@RequestBody List<Store> stores) {
        return storeRepository.saveAll(stores);
    }

    @DeleteMapping("/{id}")
    public void deleteStore(@PathVariable Long id) {
        storeRepository.deleteById(id);
    }

    @DeleteMapping("/all")
    public void deleteAllStores() {
        storeRepository.deleteAll();
    }

}

