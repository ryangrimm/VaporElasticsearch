extension StemmerFilter {

    /**
     Contains all possible languages for stemmer filter (see `StemmerFilter`)

     [More Information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-stemmer-tokenfilter.html)
     */
    public enum Language: String, Codable {

        case arabic
        case armenian
        case basque
        case bengali
        case bengaliLight = "light_bengali"
        case brazilian
        case bulgarian
        case catalan
        case czech
        case danish
        case dutch
        case dutchKraaijPohlmann = "dutch_kp"
        case english
        case englishLight = "light_english"
        case englishMinimal = "minimal_english"
        case englishPossessive = "possessive_english"
        case englishPorter2 = "porter2"
        case englishLovins = "lovins"
        case finnish
        case finnishLight = "light_finnish"
        case french
        case frenchLight = "light_french"
        case frenchMinimal = "minimal_french"
        case galician
        case galicianMinimal = "minimal_galician"
        case german
        case german2
        case germanLight = "light_german"
        case germanMinimal = "minimal_germann"
        case greek
        case hindi
        case hungarian
        case hungarianLight = "light_hungarian"
        case indonesian
        case irish
        case italian
        case italianLight = "light_italian"
        case sorani
        case latvian
        case lithuanian
        case norwegian
        case norwegianLight = "light_norwegian"
        case norwegianMinimal = "minimal_norwegian"
        case norwegianNynorskLight = "light_nynorsk"
        case norwegianNynorskMinimal = "minimal_nynorsk"
        case portuguese = "portuguese"
        case portugueseLight = "light_portuguese"
        case portugueseMinimal = "minimal_portuguese"
        case portugueseRSLP = "portuguese_rslp"
        case romanian
        case russian
        case russianLight = "light_russian"
        case spanish
        case spanishLight = "light_spanish"
        case swedish
        case swedishLight = "light_swedish"
        case turkish
    }
}
