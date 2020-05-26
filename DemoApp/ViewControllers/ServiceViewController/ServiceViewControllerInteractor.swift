//
//  ServiceViewControllerInteractor.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 26.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import Foundation

protocol IServiceViewControllerInteractor {
    func loadAndParseXML(_ completion: @escaping () -> Void)
}

class ServiceViewControllerInteractor: NSObject {
    private let networkFactory: INetworkFactory
    private let network: INetwork
    private let presenter: IServiceViewControllerPresenter

    private var parcingCD: CD?
    private var parcingElementName = ""
    private var completionLoadAndParseBlock: (() -> Void)?

    init(networkFactory: INetworkFactory,
         presenter: IServiceViewControllerPresenter) {
        self.networkFactory = networkFactory
        network = self.networkFactory.createNetwork()
        self.presenter = presenter
    }
}

// MARK: - IServiceViewControllerInteractor

extension ServiceViewControllerInteractor: IServiceViewControllerInteractor {
    func loadAndParseXML(_ completion: @escaping () -> Void) {
        // simple handling of multiple simulteniously parses
        if completionLoadAndParseBlock != nil {
            completion()
            return
        }

        completionLoadAndParseBlock = completion
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            let group = DispatchGroup()

            group.enter()
            var result: Result<CDCatalogResponse, Error>?
            self.loadXML { r in
                result = r
                group.leave()
            }
            group.wait()

            switch result {
            case .success(let response):
                self.parseXML(data: response.data)
            case .failure(_), .none:
                self.finishParsing()
            }
        }
    }
}

// MARK: - Private

private extension ServiceViewControllerInteractor {
    func loadXML(_ completion: @escaping (Result<CDCatalogResponse, Error>) -> Void) {
        let request: CDCatalogRequest = networkFactory.createCDCatalogRequest()
        request.execute(network: network, completion)
    }

    func parseXML(data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }

    func finishParsing() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.completionLoadAndParseBlock?()
            self.completionLoadAndParseBlock = nil
        }
    }
}

// MARK: - XMLParserDelegate

extension ServiceViewControllerInteractor: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "CD" {
            parcingCD = CD()
        }

        parcingElementName = elementName
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "CD" {
            if let cd = parcingCD {
                presenter.finishParseCDElement(cd)
            }
            parcingCD = nil
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if parcingElementName == "TITLE" {
                parcingCD?.title = data
            } else if parcingElementName == "ARTIST" {
                parcingCD?.artist = data
            } else if parcingElementName == "COUNTRY" {
                parcingCD?.country = data
            } else if parcingElementName == "COMPANY" {
                parcingCD?.company = data
            } else if parcingElementName == "PRICE" {
                parcingCD?.price = data
            } else if parcingElementName == "YEAR" {
                parcingCD?.year = data
            }
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        finishParsing()
    }
}
