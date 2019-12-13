@testable import LaunchKit
import XCTest

class LaunchTests: XCTestCase {
    // swiftlint:disable line_length force_unwrapping
    static let json = """
    {
        "id": 1373,
        "name": "Ariane 5 ES | Galileo FOC-19, FOC-20, FOC-21, FOC-22",
        "windowstart": "July 25, 2018 11:25:01 UTC",
        "windowend": "July 25, 2018 11:25:01 UTC",
        "net": "July 25, 2018 11:25:01 UTC",
        "wsstamp": 1532517901,
        "westamp": 1532517901,
        "netstamp": 1532517901,
        "isostart": "20180725T112501Z",
        "isoend": "20180725T112501Z",
        "isonet": "20180725T112501Z",
        "status": 1,
        "inhold": 0,
        "tbdtime": 0,
        "vidURLs": [
            "http://www.arianespace.com/mission/ariane-flight-va244/"
        ],
        "vidURL": null,
        "infoURLs": [

        ],
        "infoURL": null,
        "holdreason": null,
        "failreason": null,
        "tbddate": 0,
        "probability": -1,
        "hashtag": "#VA244",
        "changed": "2018-06-30 18:51:10",
        "location": {
            "pads": [
                {
                    "id": 137,
                    "name": "Ariane Launch Area 3, Kourou",
                    "infoURL": "http://www.esa.int/Our_Activities/Launchers/Europe_s_Spaceport/Europe_s_Spaceport2",
                    "wikiURL": "http://en.wikipedia.org/wiki/ELA-3",
                    "mapURL": "https://www.google.com/maps/?q=5.239,-52.769",
                    "latitude": 5.239,
                    "longitude": -52.768,
                    "agencies": [

                    ]
                }
            ],
            "id": 3,
            "name": "Kourou, French Guiana",
            "infoURL": "",
            "wikiURL": "",
            "countryCode": "GUF"
        },
        "rocket": {
            "id": 9,
            "name": "Ariane 5 ES",
            "configuration": "ES",
            "familyname": "Ariane",
            "agencies": [

            ],
            "wikiURL": "http://en.wikipedia.org/wiki/Ariane_5_ES",
            "infoURLs": [
                "http://www.arianespace.com/vehicle/ariane-5/"
            ],
            "infoURL": "http://www.arianespace.com/vehicle/ariane-5/",
            "imageURL": "https://s3.amazonaws.com/launchlibrary/RocketImages/placeholder_1920.png",
            "imageSizes": [
                320,
                480,
                640,
                720,
                768,
                800,
                960,
                1024,
                1080,
                1280,
                1440,
                1920
            ]
        },
        "missions": [
            {
                "id": 618,
                "name": "Galileo FOC-19, FOC-20, FOC-21, FOC-22",
                "description": "The Galileo constellation is ESA’s satellite navigation system and is expected to be completed by 2020. Galileo will provide Europe with an alternative to the American GPS and Russian GLONASS constellations, but will be interoperable with both systems.",
                "type": 10,
                "wikiURL": "https://en.wikipedia.org/wiki/Galileo_(satellite_navigation)#Full_Operational_Capability_.28FOC.29_satellites",
                "typeName": "Communications",
                "agencies": [
                    {
                        "id": 27,
                        "name": "European Space Agency",
                        "abbrev": "ESA",
                        "countryCode": "AUT,BEL,CZE,DNK,FIN,FRA,DEU,GRC,IRE,ITA,LUZ,NLD,NOR,POL,PRT,ROU,ESP,SWE,CHE,GBR",
                        "type": 2,
                        "infoURL": null,
                        "wikiURL": "http://en.wikipedia.org/wiki/European_Space_Agency",
                        "changed": "2017-02-21 00:00:00",
                        "infoURLs": [
                            "http://www.esa.int/",
                            "https://www.facebook.com/EuropeanSpaceAgency",
                            "https://twitter.com/esa",
                            "https://www.youtube.com/channel/UCIBaDdAbGlFDeS33shmlD0A"
                        ]
                    }
                ],
                "payloads": [

                ]
            }
        ],
        "lsp": {
            "id": 115,
            "name": "Arianespace",
            "abbrev": "ASA",
            "countryCode": "FRA",
            "type": 3,
            "infoURL": null,
            "wikiURL": "http://en.wikipedia.org/wiki/Arianespace",
            "changed": "2017-02-21 00:00:00",
            "infoURLs": [
                "http://www.arianespace.com",
                "https://www.youtube.com/channel/UCRn9F2D9j-t4A-HgudM7aLQ",
                "https://www.facebook.com/ArianeGroup",
                "https://twitter.com/arianespace",
                "https://www.instagram.com/arianespace"
            ]
        }
    }
    """.data(using: .utf8)!
    // swiftlint:enable line_length force_unwrapping

    func testLaunch_doesParseValidData() {
        do {
            // Arrange
            let decoder = JSONDecoder()
            // Act
            _ = try decoder.decode(LaunchKit.Launch.self, from: LaunchTests.json)
        } catch {
            // Assert
            XCTFail("Could not properly decode Launch payload")
        }
    }
}
