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
                repo.save(new Store("Carrefour Maadi", "Ring Road, Zahraa Al Maadi, Cairo", 29.9627, 31.2885));
                repo.save(new Store("Hyper One Sheikh Zayed", "26th of July Corridor, Sheikh Zayed City, Giza", 30.0395, 30.9763));
                repo.save(new Store("Spinneys New Cairo", "The Waterway, New Cairo, Cairo",30.0183, 31.4827));
                repo.save(new Store("Metro Market Mohandessin", "Gamaet El Dowal El Arabia St, Mohandessin, Giza",30.0586,31.2109));
                repo.save(new Store("Seoudi Market Zamalek", "26th July Street, Zamalek, Cairo",30.0662,31.2154));
                repo.save(new Store("Kazyon Shubra", "Shubra Street, Shubra, Cairo",30.0754,31.2470));
                repo.save(new Store("Awlad Ragab Heliopolis", "El Merghany St, Heliopolis, Cairo",30.0902,31.3300));
            }
        };
    }
}
