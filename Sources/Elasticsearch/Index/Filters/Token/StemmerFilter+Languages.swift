public protocol StemmerLanguage: Codable, RawRepresentable {}

extension StemmerFilter {

    /**
     Contains all possible languages for stemmer filter (see `StemmerFilter`)

     [More Information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-stemmer-tokenfilter.html)
     */
    public struct Language {

        public enum Arabic: String, StemmerLanguage {
            case arabic
        }

        public enum Armenian: String, StemmerLanguage {
            case armenian
        }

        public enum Basque: String, StemmerLanguage {
            case basque
        }

        public enum Bengali: String, StemmerLanguage {
            case bengali, light_bengali
        }

        public enum Brazilian: String, StemmerLanguage {
            case Portuguese, brazilian
        }

        public enum Bulgarian: String, StemmerLanguage {
            case bulgarian
        }

        public enum Catalan: String, StemmerLanguage {
            case catalan
        }

        public enum Czech: String, StemmerLanguage {
            case czech
        }

        public enum Danish: String, StemmerLanguage {
            case danish
        }

        public enum Dutch: String, StemmerLanguage {
            case dutch, dutch_kp
        }

        public enum English: String, StemmerLanguage {
            case english, light_english, minimal_english, possessive_english, porter2, lovins
        }

        public enum Finnish: String, StemmerLanguage {
            case finnish, light_finnish
        }

        public enum French: String, StemmerLanguage {
            case french, light_french, minimal_french
        }

        public enum Galician: String, StemmerLanguage {
            case galician, minimal_galician
        }

        public enum German: String, StemmerLanguage {
            case german, german2, light_german, minimal_german
        }

        public enum Greek: String, StemmerLanguage {
            case greek
        }

        public enum Hindi: String, StemmerLanguage {
            case hindi
        }

        public enum Hungarian: String, StemmerLanguage {
            case hungarian, light_hungarian
        }

        public enum Indonesian: String, StemmerLanguage {
            case indonesian
        }

        public enum Irish: String, StemmerLanguage {
            case irish
        }

        public enum Italian: String, StemmerLanguage {
            case italian, light_italian
        }

        public enum Kurdish: String, StemmerLanguage {
            case sorani
        }

        public enum Latvian: String, StemmerLanguage {
            case latvian
        }

        public enum Lithuanian: String, StemmerLanguage {
            case lithuanian
        }

        public enum NorwegianBokmal: String, StemmerLanguage {
            case norwegian, light_norwegian, minimal_norwegian
        }

        public enum NorwegianNynorsk: String, StemmerLanguage {
            case light_nynorsk, minimal_nynorsk
        }

        public enum Portuguese: String, StemmerLanguage {
            case portuguese, light_portuguese, minimal_portuguese, portuguese_rslp
        }

        public enum Romanian: String, StemmerLanguage {
            case romanian
        }

        public enum Russian: String, StemmerLanguage {
            case russian, light_russian
        }

        public enum Spanish: String, StemmerLanguage {
            case spanish, light_spanish
        }

        public enum Swedish: String, StemmerLanguage {
            case swedish, light_swedish
        }

        public enum Turkish: String, StemmerLanguage {
            case turkish
        }
    }
}
