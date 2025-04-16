package com.store.api;

import com.store.api.entity.Store;
import com.store.api.repository.StoreRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class ApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(ApiApplication.class, args);
    }

    @Bean
    CommandLineRunner runner(StoreRepository repo) {
        return args -> {
            if (repo.count() == 0) {
                repo.save(new Store("Alpha Mart", "123 Market St", 40.0, -74.0));
                repo.save(new Store("Beta Store", "456 Commerce Blvd", 41.0, -75.0));
                repo.save(new Store("Gamma Goods", "789 Trade Way", 42.5, -73.5));
                repo.save(new Store("Delta Depot", "321 Supply Ave", 39.8, -76.2));
                repo.save(new Store("Epsilon Emporium", "654 Retail Rd", 43.2, -72.8));
                repo.save(new Store("Zeta Zone", "111 Wholesale Ln", 38.7, -77.1));
                repo.save(new Store("Theta Thrift", "789 Budget Blvd", 44.1, -71.5));
            }
        };
    }
}
