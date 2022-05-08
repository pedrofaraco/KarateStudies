package helpers;

import com.github.javafaker.Faker;

import net.minidev.json.JSONObject;

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

    public static JSONObject getRandomArticleValues(){
        Faker faker = new Faker();
        String title = faker.harryPotter().character();
        String description = faker.harryPotter().house();
        String body = faker.harryPotter().quote();
        JSONObject json = new JSONObject();
        json.put("title", title);
        json.put("description", description);
        json.put("body", body);
        return json;
    }

    public static String getRandomComment(){
        Faker faker = new Faker();
        String comment = faker.harryPotter().quote();
        return comment;
    }

}
