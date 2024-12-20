//
//  GenerateRoutineModel.swift
//  hairapp
//
//  Created by Liam Syversen on 9/8/24.
// 
 
import Foundation

class GenerateRoutineModel {

    func generateRoutine(from scan: ScanResult?) -> [(emoji: String, title: String, description: [String], productLinks: [ProductLink]?)] {
        var routineSet: [(emoji: String, title: String, description: [String], productLinks: [ProductLink]?)] = [
            ("🧴", "Natural Shampoo & Moisturize", [
                "Washing your hair with a sulfate-free and paraben-free shampoo keeps it clean without stripping natural oils.",
                "Always use a hydrating conditioner after shampooing ensures your hair retains moisture and stays soft.",
                "For optimal results, choose moisturizing products that match your hair type and texture."
            ], [
                ProductLink(name: "Sulfate-Free Shampoo", imageName: "shampoo", url: "https://www.amazon.com/gp/product/B0CZ4JCCQY/ref=ox_sc_act_title_3?smid=A330SBD214O4BU&psc=1"),
                ProductLink(name: "Hydrating Conditioner", imageName: "conditioner", url: "https://www.amazon.com/gp/product/B0D3KN8WDQ/ref=ox_sc_act_title_4?smid=A330SBD214O4BU&psc=1")
            ]),
            ("📅", "Haircuts Regularly", [
                "Getting regular trims helps remove split ends, preventing further damage to your hair.",
                "Trimming your hair frequently ensures that it stays healthy, allowing for better growth over time.",
                "Regular haircuts give your hair a neater, more polished look, improving its overall appearance."
            ], nil)
        ]

        // Check for the lowest metric and add a routine item based on it
        if let lowestMetricRoutine = findLowestMetricRoutine(in: scan) {
            routineSet.append(lowestMetricRoutine)
        }

        return Array(routineSet.prefix(5))
    }
    
    private func findLowestMetricRoutine(in scan: ScanResult?) -> (emoji: String, title: String, description: [String], productLinks: [ProductLink]?)? {
        guard let scan = scan else { return nil }

        let metrics: [String: (emoji: String, value: Double, description: [String], productLinks: [ProductLink]?)] = [
            "Leave-In Conditioner": ("💧", scan.frizzlevel, [
                "Helps keep hair moisturized by sealing in hydration and reducing dryness.",
                "Consider using anti-frizz serums or oils to tame flyaways, especially in humid conditions.",
                "Avoid over-brushing, as it can disrupt the hair’s natural structure and cause frizz to increase."
            ], [
                ProductLink(name: "Leave-In Conditioner", imageName: "leavein", url: "https://www.amazon.com/As-Am-Leave-Conditioner-Ounce/dp/B0065R18TY/ref=sr_1_1?crid=3OUX7F7T7UF3I&dib=eyJ2IjoiMSJ9.JBJXCUWviPCdPgpHu9DAa1ndSze2fZbeC0gcudDixDbGF95dmhLZQZPtfc2874WnBpI0djSQiI--PZoBwbeb2ywIkpbvBOhnbEJ6SvV4hKZ8DzQSNPVo9vHmb5lroYpz4JD25lVbO6beD0rIkx2bxS_C9W6aBIpu_ktcuC43aYKF8ydBRDFKXa6LpaqGh6NdhrF4uoZQ1l7joVvWTfuwCs4IMg9Oa10lxh8pmc_CKzt3Eq5cvbmnr21aWx1pgqtbeji6EvwfXfyeIDrRSI7qS4AL4FELFnZYSbYZk96Q77Q.Y26qCL-TSh8ed5BpCSyoj8bpK4tYMG3qx2dbMDh7ZZE&dib_tag=se&keywords=as+i+am+shampoo+curl+clarity&qid=1728881023&sprefix=as+i+am+shampoo+c%2Caps%2C154&sr=8-1")
            ]),
            "Hair Loss Routine": ("💪", scan.hairdensity, [
                "Use minoxidil to stimulate hair follicles. Apply with a dermastamp for deeper absorption.",
                "Consider topical finasteride if hair loss continues. It has fewer systemic side effects compared to oral versions.",
                "Consult with your doctor before starting any new hair loss treatments to discuss benefits and potential side effects."
            ], [
                ProductLink(name: "Minoxidil Solution", imageName: "minoxidil", url: "https://www.amazon.com/Kirkland-Minoxidil-Treatment-Applicator-available/dp/B078GYC6QN/ref=sr_1_1?crid=F8AV72AP0I7N&dib=eyJ2IjoiMSJ9.EfVOq63cqafBsaE5pj80mjzw2xEC5i3Tq8OUZZ9qUkMb3EV6wUJ_ZSbc57zXjQfulkcPbLTRE5bAFfNlGXLSY77EP2cgze_cKLkn3vn0rIGBdVvPYA0uEJ3ks7xndcVmAVZm6PLfc8CoWBysuO1qA9Vu5Icw3Kc1yftolC5cJ3NqMyez9FYf0Kc82fieDK_QCm0xUcGMOdn2sc85rzGrXdI_QJOwgfBrT42daX8eAi4le1m-0ZVvgc42vq92bO6XCfIR7tY9bTQnw7cDOyK1FNO-JFV0SY-6R_xBwRv0owk.U7IGOqzDKe3C_pxdIHEEBBA5O1RGp0vJFpxtdJTdHn0&dib_tag=se&keywords=minoxidil+kirkland&qid=1728880703&sprefix=mino%2Caps%2C101&sr=8-1"),
                ProductLink(name: "Derma Stamp Pen", imageName: "dermastamp", url: "https://www.amazon.com/Dermastamp-System-0-25mm-Microneedling-Alternative/dp/B0D8KVW95T/ref=sr_1_12?crid=AA2AFGPSOJUD&dib=eyJ2IjoiMSJ9.aY7XCG6DRKYRZJq9tLA5BB8sR0t27pKzAjyiyNceCPYGnncBejtU2PU9eS0p49G8Pzst_OxciDWnMYyl2OR57qIGum_nU0FoBElKIaD5_MyBmDt7F1EGbGGdzkYiAbZcbgMTVEQekUwKK--zmVkU-1FjllqQ2yJUvtaF3BTHrshLyda3Pru-MCswH-TY_lI_MAes5mcQxeEo3WIi_uP8JsxC7e65mXYuBOZz0D_GfPC77gVyqXYq7bybKMh1ldel2v46apWOECsSABHJUnca6ogvUGICOFy8cChDNPgj70U.wzhAb63fPKagFF4UIkPnAhKW7sDp0_Lxd9jAglY2tcE&dib_tag=se&keywords=derma+stamp&qid=1728880750&sprefix=derma%2Caps%2C137&sr=8-12")
            ])
        ]

        if let lowestMetric = metrics.min(by: { $0.value.value < $1.value.value }) {
            return (emoji: lowestMetric.value.emoji, title: lowestMetric.key, description: lowestMetric.value.description, productLinks: lowestMetric.value.productLinks)
        }

        return nil
    }
}

 
