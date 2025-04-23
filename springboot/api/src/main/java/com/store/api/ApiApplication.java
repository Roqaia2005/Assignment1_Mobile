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
                repo.save(new Store("Carrefour City Centre Almaza", "Salah Salem St, Heliopolis, Cairo", 30.0996, 31.3659));
                repo.save(new Store("Spinneys Mall of Arabia", "6th of October City, Giza", 29.9725, 30.9325));
                repo.save(new Store("Gourmet Zamalek", "Brazil St, Zamalek, Cairo", 30.0637, 31.2184));
                repo.save(new Store("Metro Market Nasr City", "Makram Ebeid St, Nasr City, Cairo", 30.0575, 31.3458));
                repo.save(new Store("Kazyon Nasr City", "Mostafa El-Nahas St, Nasr City, Cairo", 30.0551, 31.3486));
                repo.save(new Store("Awlad Ragab Maadi", "Street 9, Maadi, Cairo", 29.9621, 31.2616));
                repo.save(new Store("Seoudi Market Heliopolis", "El Merghany St, Heliopolis, Cairo", 30.0865, 31.3443));
                repo.save(new Store("Gourmet New Cairo", "South 90 St, New Cairo", 30.0083, 31.4421));
                repo.save(new Store("Carrefour Dandy Mall", "Cairo-Alex Desert Rd, Giza", 30.0233, 31.0117));
                repo.save(new Store("Metro Market Alexandria", "Fouad St, Alexandria", 31.1985, 29.9020));
                repo.save(new Store("Kazyon Mohandessin", "Syria St, Mohandessin, Giza", 30.0597, 31.2024));
                repo.save(new Store("Hyper One New Minya", "Eastern Desert Road, Minya", 28.0894, 30.7611));
                repo.save(new Store("Awlad Ragab Tanta", "El Geish St, Tanta, Gharbia", 30.7865, 30.9982));
                repo.save(new Store("Carrefour City Centre Tanta", "Alexandria Agricultural Rd, Tanta", 30.7812, 31.0028));
                repo.save(new Store("Spinneys Alexandria", "Smouha, Alexandria", 31.2156, 29.9604));
                repo.save(new Store("Metro Market Dokki", "Tahrir St, Dokki, Giza", 30.0384, 31.2116));
                repo.save(new Store("Kazyon Downtown", "Champollion St, Downtown Cairo", 30.0507, 31.2397));
                repo.save(new Store("Awlad Ragab Ismailia", "Talaat Harb St, Ismailia", 30.5852, 32.2654));
                repo.save(new Store("Carrefour Suez", "El Salam City, Suez", 29.9782, 32.5498));
                repo.save(new Store("Gourmet Sheikh Zayed", "Beverly Hills, Sheikh Zayed, Giza", 30.0332, 30.9921));
            }
        };
    }
}
