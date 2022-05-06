package helpers;

import com.github.javafaker.Faker;

public class DataGenerators {
    
    public static String getRandomEmail(){
        Faker faker = new Faker();
        String email = faker.name().firstName().toLowerCase() + faker.random().nextInt(0, 100) + "@test.com";
        return email;
    }

    public String getRandomUsername(){
        Faker faker = new Faker();
        String username = faker.name().username();
        return username;
    }

}
