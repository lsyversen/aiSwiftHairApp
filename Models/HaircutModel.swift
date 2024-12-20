//
//  HaircutModel.swift
//  hairapp
// 
//  Created by Liam Syversen on 9/15/24.
//
//

import Foundation

struct HairStyle: Hashable {
    let name: String
    let imageName: String
}

class GenerateHairStyle {
    func fetchRecommendations(for faceShape: String, hairType: String, gender: String) -> [HairStyle] {
        var recommendations: [HairStyle] = []
        
        // Select hairstyles based on hair type
        let hairTypeRecommendations: [HairStyle] = fetchHairTypeRecommendations(hairType: hairType, gender: gender)
        
        // Select hairstyles based on face shape
        let faceShapeRecommendations: [HairStyle] = fetchFaceShapeRecommendations(faceShape: faceShape, gender: gender)
        
        // Combine recommendations: only keep styles that appear in both lists
        recommendations = hairTypeRecommendations.filter { faceShapeRecommendations.contains($0) }
        
        // If no matching styles, fall back to hairType recommendations
        if recommendations.isEmpty {
            recommendations = hairTypeRecommendations
        }
        
        return recommendations
    }
    
    // Recommendations based on hair type
    private func fetchHairTypeRecommendations(hairType: String, gender: String) -> [HairStyle] {
        switch hairType.lowercased() {
        case "straight":
            if gender.lowercased() == "male" {
                return [
                    HairStyle(name: "Fringe", imageName: "fringe"),
                    HairStyle(name: "Buzzcut", imageName: "buzzcut"),
                    HairStyle(name: "Slick back", imageName: "slickback"),
                    HairStyle(name: "Middle part", imageName: "middlepart"),
                    HairStyle(name: "Short textured", imageName: "shorttextured"),
                    HairStyle(name: "Short and spiky", imageName: "shortandspiky"),
                    HairStyle(name: "Mid fade", imageName: "midfade"),
                    HairStyle(name: "Curtains", imageName: "curtains"),
                    HairStyle(name: "Undercut", imageName: "undercut"),
                    HairStyle(name: "70/30 Cut", imageName: "7030cut"),
                    HairStyle(name: "Warrior Cut", imageName: "warriorcut"),
                ]
            } else {
                return [
                    HairStyle(name: "Long Layers", imageName: "long_layers"),
                    HairStyle(name: "Sleek Bob", imageName: "sleek_bob"),
                    HairStyle(name: "Curtain Bangs", imageName: "curtain_bangs"),
                    HairStyle(name: "Blunt Cut", imageName: "blunt_cut"),
                    HairStyle(name: "Side Part", imageName: "side_partwomens"),
                    HairStyle(name: "Rachel", imageName: "rachel")
                ]
            }
            
        case "wavy":
            if gender.lowercased() == "male" {
                return [
                    HairStyle(name: "Blowout Taper", imageName: "blowouttaper"),
                    HairStyle(name: "Surfer Curls", imageName: "surfercurls"),
                    HairStyle(name: "Short and spiky", imageName: "shortandspiky"),
                    HairStyle(name: "French Crop", imageName: "frenchcrop"),
                    HairStyle(name: "Burst Fade", imageName: "burstfade"),
                    HairStyle(name: "Messy fringe", imageName: "messyfringe"),
                    HairStyle(name: "Textured and overgrown", imageName: "texturedovergrown"),
                    HairStyle(name: "Surfer Hair", imageName: "surferhair"),
                    HairStyle(name: "Textured Crop", imageName: "texturedcrop"),
                    HairStyle(name: "Buzz Cut", imageName: "buzzcut"),
                    HairStyle(name: "Mullet", imageName: "mullet"),
                    HairStyle(name: "70/30 Cut", imageName: "7030cut"),
                    HairStyle(name: "Short Fringe", imageName: "shortfringe"),
                    HairStyle(name: "Warrior Cut", imageName: "warriorcut"),
                    HairStyle(name: "Curtains", imageName: "curtains"),
                    HairStyle(name: "Side Part", imageName: "sidepart"),
                    HairStyle(name: "Short Mullet", imageName: "shortmullet"),
                    HairStyle(name: "Middle part", imageName: "middlepart"),
                    HairStyle(name: "Low Taper", imageName: "lowtaper"),
                    HairStyle(name: "Mid fade", imageName: "midfade"),
                    HairStyle(name: "Undercut", imageName: "undercut"),
                ]
            } else {
                return [
                    HairStyle(name: "Beach Waves", imageName: "beach_waves"),
                    HairStyle(name: "Textured Bob", imageName: "textured_bob"),
                    HairStyle(name: "Layered Waves", imageName: "layered_waves"),
                    HairStyle(name: "Shag Cut", imageName: "shag_cut"),
                    HairStyle(name: "Soft Curls", imageName: "soft_curls"),
                    HairStyle(name: "Rachel", imageName: "rachel")
                ]
            }
            
        case "curly":
            if gender.lowercased() == "male" {
                return [
                    HairStyle(name: "Greek Curl", imageName: "greekcurl"),
                    HairStyle(name: "Mid Fade with Curls", imageName: "midfadewithcurls"),
                    HairStyle(name: "Mullet", imageName: "mullet"),
                    HairStyle(name: "Short Mullet", imageName: "shortmullet"),
                    HairStyle(name: "Surfer Hair", imageName: "surferhair"),
                    HairStyle(name: "Edgar", imageName: "edgar"),
                    HairStyle(name: "Surfer Curls", imageName: "surfercurls"),
                    HairStyle(name: "Low Taper", imageName: "lowtaper"),
                    HairStyle(name: "Textured Crop", imageName: "texturedcrop"),
                    HairStyle(name: "Textured Fringe", imageName: "texturedfringe"),
                    HairStyle(name: "Textured and overgrown", imageName: "texturedovergrown"),
                    HairStyle(name: "Buzz Cut", imageName: "buzzcut"),
                    HairStyle(name: "Burst Fade", imageName: "burstfade"),
                    HairStyle(name: "Blowout Taper", imageName: "blowouttaper"),
                    HairStyle(name: "Quiffs", imageName: "quiffs"),
                    HairStyle(name: "Undercut", imageName: "undercut"),
                    HairStyle(name: "Messy Waves", imageName: "messywaves"),
                    HairStyle(name: "Messy Fringe", imageName: "messyfringe"),
                ]
            } else {
                return [
                    HairStyle(name: "Curly Bob", imageName: "curly_bob"),
                    HairStyle(name: "Layered Curls", imageName: "layered_curls"),
                    HairStyle(name: "Curly Pixie", imageName: "curly_pixie"),
                    HairStyle(name: "Afro", imageName: "afro"),
                    HairStyle(name: "Curly Shag", imageName: "curly_shag")
                ]
            }
            
        case "coily":
            if gender.lowercased() == "male" {
                return [
                    HairStyle(name: "All even haircut", imageName: "alleven"),
                    HairStyle(name: "Undercut Fade", imageName: "undercutfade"),
                    HairStyle(name: "Mid fade with curls", imageName: "midfadecurls"),
                    HairStyle(name: "High Taper", imageName: "hightaper"),
                    HairStyle(name: "Dreadlocks", imageName: "dreadlocks"),
                    HairStyle(name: "Buzz Cut", imageName: "buzzcut")
                ]
            } else {
                return [
                    HairStyle(name: "Coily Afro", imageName: "coily_afro"),
                    HairStyle(name: "Braided Updo", imageName: "braided_updo"),
                    HairStyle(name: "Tapered Coils", imageName: "tapered_coils"),
                    HairStyle(name: "Box Braids", imageName: "box_braids"),
                    HairStyle(name: "Twist Out", imageName: "twist_out")
                ]
            }
            
        default:
            return [HairStyle(name: "Default Style", imageName: "defaultstyle")]
        }
    }
    
    // Recommendations based on face shape
    private func fetchFaceShapeRecommendations(faceShape: String, gender: String) -> [HairStyle] {
        switch faceShape.lowercased() {
        case "oval":
            if gender.lowercased() == "male" {
                return [
                    HairStyle(name: "Buzz Cut", imageName: "buzzcut"),
                    HairStyle(name: "Mullet", imageName: "mullet"),
                    HairStyle(name: "Short Fringe", imageName: "shortfringe"),
                    HairStyle(name: "Warrior Cut", imageName: "warriorcut"),
                    HairStyle(name: "Side Part", imageName: "sidepart"),
                    HairStyle(name: "Curtains", imageName: "curtains"),
                    HairStyle(name: "Dreadlocks", imageName: "dreadlocks"),
                    HairStyle(name: "Wolf Cut", imageName: "wolfcut"),
                    HairStyle(name: "70/30 Cut", imageName: "7030cut"),
                    HairStyle(name: "Mid Fade", imageName: "midfade"),
                    HairStyle(name: "Mid Fade with Curls", imageName: "midfadewithcurls"),
                    HairStyle(name: "Low Taper", imageName: "lowtaper"),
                    HairStyle(name: "Comma Hair", imageName: "commahair"),
                    HairStyle(name: "Burst Fade", imageName: "burstfade"),
                    HairStyle(name: "Crewcut", imageName: "crewcut"),
                    HairStyle(name: "Short Mullet", imageName: "shortmullet"),
                    HairStyle(name: "Short and spiky", imageName: "shortandspiky"),
                    HairStyle(name: "Textured and overgrown", imageName: "texturedovergrown"),
                ]
            } else {
                return [
                    HairStyle(name: "Long Layers", imageName: "long_layers"),
                    HairStyle(name: "Sleek Bob", imageName: "sleek_bob"),
                    HairStyle(name: "Side Part", imageName: "side_partwomens"),
                    HairStyle(name: "Curtain Bangs", imageName: "curtain_bangs"),
                    HairStyle(name: "Blunt Cut", imageName: "blunt_cut"),
                    HairStyle(name: "Rachel", imageName: "rachel")
                ]
            }
            
        case "square":
            if gender.lowercased() == "male" {
                return [
                    HairStyle(name: "Buzz Cut", imageName: "buzzcut"),
                    HairStyle(name: "Caesar Cut", imageName: "caesarcrop"),
                    HairStyle(name: "Warrior Cut", imageName: "warriorcut"),
                    HairStyle(name: "Side Part", imageName: "sidepart"),
                    HairStyle(name: "Dreadlocks", imageName: "dreadlocks"),
                    HairStyle(name: "Quiffs", imageName: "quiffs"),
                    HairStyle(name: "All even haircut", imageName: "alleven"),
                    HairStyle(name: "Undercut", imageName: "undercut"),
                    HairStyle(name: "Short and spiky", imageName: "shortandspiky")
                ]
            } else {
                return [
                    HairStyle(name: "Shoulder-Length Waves", imageName: "shoulder_length_waves"),
                    HairStyle(name: "Soft Curls", imageName: "soft_curls"),
                    HairStyle(name: "Textured Bob", imageName: "textured_bob"),
                    HairStyle(name: "Layered Pixie", imageName: "layered_pixie"),
                    HairStyle(name: "Side-Swept Bangs", imageName: "side_swept_bangs")
                ]
            }
            
        case "diamond":
            if gender.lowercased() == "male" {
                return [
                    HairStyle(name: "Warrior Cut", imageName: "warriorcut"),
                    HairStyle(name: "Wolf Cut", imageName: "wolfcut"),
                    HairStyle(name: "70/30 Cut", imageName: "7030cut"),
                    HairStyle(name: "Low Taper", imageName: "lowtaper"),
                    HairStyle(name: "Messy Fringe", imageName: "messyfringe"),
                    HairStyle(name: "Crewcut", imageName: "crewcut"),
                    HairStyle(name: "Curtains", imageName: "curtains"),
                    HairStyle(name: "Short Mullet", imageName: "shortmullet"),
                    HairStyle(name: "Dreadlocks", imageName: "dreadlocks"),
                    HairStyle(name: "All even haircut", imageName: "alleven"),
                    HairStyle(name: "Textured and overgrown", imageName: "texturedovergrown"),
                    HairStyle(name: "Mid Fade with Curls", imageName: "midfadewithcurls")
                ]
            } else {
                return [
                    HairStyle(name: "Chin-Length Bob", imageName: "chin_length_bob"),
                    HairStyle(name: "Side-Swept Bangs", imageName: "side_swept_bangs"),
                    HairStyle(name: "Layered Curls", imageName: "layered_curls"),
                    HairStyle(name: "Textured Bob", imageName: "textured_bob"),
                    HairStyle(name: "Messy Waves", imageName: "messy_waves")
                ]
            }
            
        case "round":
            if gender.lowercased() == "male" {
                return [
                    HairStyle(name: "Side Part", imageName: "sidepart"),
                    HairStyle(name: "Blowout Taper", imageName: "blowouttaper"),
                    HairStyle(name: "Undercut", imageName: "undercut"),
                    HairStyle(name: "Quiffs", imageName: "quiffs"),
                    HairStyle(name: "Textured Fringe", imageName: "texturedfringe"),
                    HairStyle(name: "Messy Waves", imageName: "messywaves"),
                    HairStyle(name: "Dreadlocks", imageName: "dreadlocks"),
                    HairStyle(name: "All even haircut", imageName: "alleven"),
                    HairStyle(name: "Short and spiky", imageName: "shortandspiky"),
                    HairStyle(name: "Undercut", imageName: "undercut")
                ]
            } else {
                return [
                    HairStyle(name: "Layered Pixie", imageName: "layered_pixie"),
                    HairStyle(name: "Side-Swept Bangs", imageName: "side_swept_bangs"),
                    HairStyle(name: "Long Waves", imageName: "long_waves"),
                    HairStyle(name: "Shag Cut", imageName: "shag_cut"),
                    HairStyle(name: "Curly Bob", imageName: "curly_bob"),
                    HairStyle(name: "Rachel", imageName: "rachel")
                ]
            }
            
        case "rectangular", "oblong":
            if gender.lowercased() == "male" {
                return [
                    HairStyle(name: "Braids", imageName: "braids"),
                    HairStyle(name: "Modern Spike", imageName: "modernspike"),
                    HairStyle(name: "Buzzcut", imageName: "buzzcut"),
                    HairStyle(name: "Slick Back", imageName: "slickback"),
                    HairStyle(name: "Dreadlocks", imageName: "dreadlocks"),
                    HairStyle(name: "Short Mullet", imageName: "shortmullet"),
                    HairStyle(name: "All even haircut", imageName: "alleven"),
                    HairStyle(name: "Textured and overgrown", imageName: "texturedovergrown"),
                    HairStyle(name: "Mid Fade with Curls", imageName: "midfadewithcurls"),
                ]
            } else {
                return [
                    HairStyle(name: "Soft Waves", imageName: "soft_waves"),
                    HairStyle(name: "Long Layers", imageName: "long_layers"),
                    HairStyle(name: "Curtain Bangs", imageName: "curtain_bangs"),
                    HairStyle(name: "Side-Swept Bangs", imageName: "side_swept_bangs"),
                    HairStyle(name: "Dreadlocks", imageName: "dreadlocks"),
                    HairStyle(name: "Layered Curls", imageName: "layered_curls")
                ]
            }
            
        case "triangular":
            if gender.lowercased() == "male" {
                return [
                    HairStyle(name: "Messy Waves", imageName: "messywaves"),
                    HairStyle(name: "Textured Crop", imageName: "texturedcrop"),
                    HairStyle(name: "Short Mullet", imageName: "shortmullet"),
                    HairStyle(name: "Curtains", imageName: "curtains"),
                    HairStyle(name: "Low Taper", imageName: "lowtaper"),
                    HairStyle(name: "Edgar", imageName: "edgar"),
                    HairStyle(name: "Dreadlocks", imageName: "dreadlocks"),
                    HairStyle(name: "All even haircut", imageName: "alleven"),
                ]
            } else {
                return [
                    HairStyle(name: "Textured Bob", imageName: "textured_bob"),
                    HairStyle(name: "Curtain Bangs", imageName: "curtain_bangs"),
                    HairStyle(name: "Long Layers", imageName: "long_layers"),
                    HairStyle(name: "Shag Cut", imageName: "shag_cut"),
                    HairStyle(name: "Dreadlocks", imageName: "dreadlocks"),
                    HairStyle(name: "Pixie Cut", imageName: "pixie_cut")
                ]
            }
            
        case "heart":
            if gender.lowercased() == "male" {
                return [
                    HairStyle(name: "Surfer Hair", imageName: "surferhair"),
                    HairStyle(name: "Messy Fringe", imageName: "messyfringe"),
                    HairStyle(name: "Side Part", imageName: "sidepart"),
                    HairStyle(name: "Curtains", imageName: "curtains"),
                    HairStyle(name: "Greek Curl", imageName: "greekcurl"),
                    HairStyle(name: "Dreadlocks", imageName: "dreadlocks"),
                    HairStyle(name: "All even haircut", imageName: "alleven"),
                    HairStyle(name: "Undercut", imageName: "undercut"),
                ]
            } else {
                return [
                    HairStyle(name: "Side Part", imageName: "side_partwomens"),
                    HairStyle(name: "Blunt Cut", imageName: "blunt_cut"),
                    HairStyle(name: "Curtain Bangs", imageName: "curtain_bangs"),
                    HairStyle(name: "Wavy Bob", imageName: "wavy_bob"),
                    HairStyle(name: "Shag Cut", imageName: "shag_cut"),
                    HairStyle(name: "Rachel", imageName: "rachel")
                ]
            }
            
        default:
            return [HairStyle(name: "Default Style", imageName: "defaultstyle")]
        }
    }
}

