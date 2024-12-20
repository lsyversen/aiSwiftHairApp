//
//  LearnMoreModel.swift
//  hairapp
//
//  Created by Liam Syversen on 9/12/24.
//

import Foundation

struct LearnMoreSection {
    let title: String
    let description: [String]
    let image: String
}

class LearnMoreModel: ObservableObject {
    @Published var sections: [LearnMoreSection] = [
        LearnMoreSection(
            title: "Hair Texture",
            description: [
                "Our app helps you enhance your natural texture with tailored advice on products and tools. From beachy waves to defined curls, the guide covers techniques for every hair type.",
                "Texture-specific products like sea salt spray and texture powder are recommended, helping you achieve looks with added volume and definition. The right styling products can make all the difference.",
                "The app also provides advice on heat styling, explaining how to use tools like curling irons and diffusers to add or maintain texture while minimizing heat damage."
            ],
            image: "greekcurls"
        ),
        
        LearnMoreSection(
            title: "Essentials",
            description: [
                "A solid hair care routine is the foundation of healthy hair. The app recommends essential practices, from regular trims to the best way to shampoo and condition based on your hair type.",
                "Proper hydration is key, and moisturizing conditioners are recommended for all hair types. Conditioners help detangle and reduce breakage, making hair easier to manage.",
                "Protective measures, like using heat protectants and choosing the right hair oils, are essential for maintaining hair integrity. Learn how to incorporate these essentials into your daily routine for optimal results."
            ],
            image: "essentials"
        ),
        
        LearnMoreSection(
            title: "Hair Scans",
            description: [
                "The Hair Rating Scan provides an in-depth analysis of your hair's overall health, evaluating aspects like thickness, luster, and resilience. It helps you understand your hair’s condition, enabling better care and maintenance.",
                "Our Hair Line Scan is designed to detect early signs of hairline recession. By assessing the density and position of your hairline, it provides actionable insights to help you maintain or improve your hairline.",
                "The Who Has Better Hair Scan offers a fun and interactive way to compare your hair with friends. It evaluates multiple factors such as volume, texture, and sheen, giving a lighthearted comparison based on scientific metrics."
            ],
            image: "hairscans"
        ),
        
        LearnMoreSection(
            title: "Hair Type",
            description: [
                "Understanding your hair type is key to choosing the right products and care techniques.Hair types are generally categorized into four main groups, each with its unique needs.",
                "Straight Hair lacks curls and has a smooth texture. It's naturally shiny due to the way light reflects off the flat surface, but it can get oily quickly.",
                
                "Wavy Hair falls between straight and curly, often in an ‘S’ shape. This hair type tends to frizz and benefits from light hydration and frizz control products.",
                
                "Curly Hair is characterized by defined ringlets and curls, this hair type can be prone to frizz and dryness and usually needs moisture-rich products.",
                
                "Coily Hair features very tight curls or coils, often appearing voluminous but with a delicate texture. Coily hair is prone to breakage and requires heavy moisturization and gentle care.",
                
                "How to Find Your Hair Type\n\n"
                + "1. Use the Hair Rating Scan within our app.",
                
                "Your hair type not only determines the products you should use but also how often you should wash and style your hair. For example, straight hair may need more frequent washing, while curly and coily hair often benefit from less frequent washing to retain natural oils."
            ],
            image: "hairtype"
        ),

        LearnMoreSection(
            title: "Hair Porosity",
            description: [
                "Doing a Porosity Test helps you determine how well your hair absorbs and retains moisture. Knowing your hair’s porosity is essential for selecting products that enhance moisture retention and address specific hair needs.",
                
                 "Float Test – Start with clean, product-free hair. Place a loose strand of hair in a glass of water and let it sit for 3-5 minutes",
                 "• Low Porosity: Hair floats on top, indicating it resists moisture and may need lightweight, water-based products.",
                 "• Medium/Normal Porosity: Hair floats in the middle, meaning it absorbs and retains moisture well with minimal help.",
                "• High Porosity: Hair sinks to the bottom quickly, which means it can absorb moisture but loses it easily. Rich, sealing products are recommended.",
                

                
                "Based on your test results, you’ll receive personalized recommendations. Low-porosity hair benefits from lightweight products, while high-porosity hair often needs thicker, hydrating treatments. By understanding your hair’s porosity, you can ensure it receives the moisture and care it needs."
            ],
            image: "hairporosity"
        ),

        LearnMoreSection(
            title: "Hair Loss",
            description: [
                "Understanding the stages and causes of hair loss can help you make informed decisions about treatments.",
                
                "One effective treatment option is Minoxidil, which promotes hair regrowth by increasing blood flow to the scalp. It's available as an over-the-counter liquid, foam, or shampoo, and regular application is required to maintain results.",
                
                "When using Minoxidil, consider pairing it with a Dermastamp for enhanced absorption. For the best results, apply Minoxidil and use the Dermastamp 12 hours apart to allow your scalp ample time to absorb each treatment.",
                
                "Our guide also emphasizes lifestyle changes that support hair health, such as regular scalp massages, stress reduction, and a balanced diet. These natural methods complement medical treatments by improving circulation and providing essential nutrients that contribute to stronger, healthier hair growth.",
                
                "In addition to medications, surgical options and FDA-approved low-level laser therapy are available for those seeking more permanent solutions. With a holistic approach, you can address hair loss from multiple angles to achieve and maintain your desired results."
            ],
            image: "hairlinemen2"
        ),
    ]
}
