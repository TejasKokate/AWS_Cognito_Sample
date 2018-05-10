//
//  NetworkSettings.swift
//  AWS_Cognito_Sample
//
//  Created by Kokate, Tejas (US - Mumbai) on 5/9/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

struct NetworkSettings {

    struct Environment {

        //Default AWS base URL
        static var baseURL = "https://8pfwlzxb07.execute-api.us-east-2.amazonaws.com/dev/observations/"
    }

    struct httpHeaders {
        static var baseHeaders : [String : Any] = [:]
    }
    
    static let parameters: [String: Any] = [
        "resourceType": "Observation",
        "id": "body-temperature",
        "status": "final",
        "category": [
            [
                "coding": [
                    [
                        "system": "http://aws-sandbox/observation",
                        "code": "vital-signs",
                        "display": "Vital Signs"
                    ]
                ],
                "text": "Vital Signs"
            ]
        ],
        "code": [
            "coding": [
                [
                    "system": "http://loinc.org",
                    "code": "8310-5",
                    "display": "Body temperature"
                ]
            ],
            "text": "Body temperature"
        ],
        "subject": [
            "reference": "Patient/example"
        ],
        "performer": [
            [
                "reference": "Patient/example",
                "display": "Example Patient"
            ]
        ],
        "effectiveDateTime": "1999-07-02",
        "valueQuantity": [
            "value": "36.5",
            "unit": "C",
            "system": "http://unitsofmeasure.org",
            "code": "Cel"
        ]
    ]

}
