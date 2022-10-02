//
//  Data.swift
//  Chloris.AI
//
//  Created by Mathias Tahas on 02.10.22.
//

import Foundation

// Azure backend
let azureTomatoUrl = "https://letstryagain5.eastus.inference.ml.azure.com/score"
let azureCocoaUrl = ""

// Azure auth keys
let azureTomatoKey = "HFr7WdipzYrtuQ9Bdr75O1O9COf0jc9m"
let azureCocoaKey = ""

enum Entity: String {
    case Tomato = "Tomato"
    case Cocoa = "Cocoa"
}

// -MARK: Tomato
let tomatoLabels = [
    "Tomato___Bacterial_spot",
    "Tomato___Early_blight",
    "Tomato___Late_blight",
    "Tomato___Leaf_Mold",
    "Tomato___Septoria_leaf_spot",
    "Tomato___Spider_mites Two-spotted_spider_mite",
    "Tomato___Target_Spot",
    "Tomato___Tomato_Yellow_Leaf_Curl_Virus",
    "Tomato___Tomato_mosaic_virus",
    "Tomato___healthy"
]

let tomatoHealthyLabel = tomatoLabels[9]

let tomatoDiseaseHelpLinks = [
    "Bacterial_spot": "https://hort-extension-wisc-edu.translate.goog/articles/bacterial-spot-of-tomato/?_x_tr_sl=en&_x_tr_tl=de&_x_tr_hl=de&_x_tr_pto=sc",
    "Early_blight": "https://extension-umn-edu.translate.goog/disease-management/early-blight-tomato-and-potato?_x_tr_sl=en&_x_tr_tl=de&_x_tr_hl=de&_x_tr_pto=sc",
    "Late_blight": "https://extension-umn-edu.translate.goog/disease-management/late-blight?_x_tr_sl=en&_x_tr_tl=de&_x_tr_hl=de&_x_tr_pto=sc",
    "Leaf_Mold": "https://extension-umn-edu.translate.goog/disease-management/tomato-leaf-mold?_x_tr_sl=en&_x_tr_tl=de&_x_tr_hl=de&_x_tr_pto=sc",
    "Septoria_leaf_spot": "https://www-missouribotanicalgarden-org.translate.goog/gardens-gardening/your-garden/help-for-the-home-gardener/advice-tips-resources/pests-and-problems/diseases/fungal-spots/septoria-leaf-spot-of-tomato?_x_tr_sl=en&_x_tr_tl=de&_x_tr_hl=de&_x_tr_pto=sc",
    "Spider_mites Two-spotted_spider_mite": "https://www-plantwise-org.translate.goog/knowledgebank/factsheetforfarmers/20137804187?_x_tr_sl=en&_x_tr_tl=de&_x_tr_hl=de&_x_tr_pto=sc",
    "Target_Spot": "https://www-vegetables-bayer-com.translate.goog/ca/en-ca/resources/agronomic-spotlights/target-spot-of-tomato.html?_x_tr_sl=en&_x_tr_tl=de&_x_tr_hl=de&_x_tr_pto=sc",
    "Tomato_Yellow_Leaf_Curl_Virus": "https://www2-ipm-ucanr-edu.translate.goog/agriculture/tomato/Tomato-Yellow-Leaf-Curl/?_x_tr_sl=en&_x_tr_tl=de&_x_tr_hl=de&_x_tr_pto=sc",
    "Tomato_mosaic_virus": "https://extension-umn-edu.translate.goog/disease-management/tomato-viruses?_x_tr_sl=en&_x_tr_tl=de&_x_tr_hl=de&_x_tr_pto=sc",
]



// -MARK: Cocoa
