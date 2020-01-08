//
//  EventsTableVM.swift
//  LiveStyled-Test
//
//  Created by Atharva Vaidya on 1/6/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation
import Combine
import UIKit.UIImage
import CoreData

class EventsTableVM {
    private let model: EventsTableModel
    private let apiClient: APIClient = APIClient()
    private var cancellables: Set<AnyCancellable> = []

    @UserDefaultsWrapper(key: "currentRequestPage", defaultValue: 1)
    private var currentRequestPage: Int
    
    var modelUpdatedPublisher: AnyPublisher<Void, Never> {
        return model.modelChangedPublisher.eraseToAnyPublisher()
    }
    
    init(model: EventsTableModel) {
        self.model = model
    }
    
    //MARK:- Table View Data Source Methods
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return model.numberOfRows()
    }
    
    func title(for indexPath: IndexPath) -> String {
        guard let event = model.event(at: indexPath) else {
            return ""
        }
        
        return event.title ?? ""
    }
    
    func date(for indexPath: IndexPath) -> String {
        guard let event = model.event(at: indexPath) else {
            return ""
        }
        
        let date = Date(timeIntervalSince1970: TimeInterval(event.startDate))
        let formattedString = formatted(date: date)
        
        return formattedString
    }
    
    private func formatted(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func isFavorited(at indexPath: IndexPath) -> Bool {
        guard let event = model.event(at: indexPath) else {
            return false
        }
        
        return event.favourited
    }
    
    
    //MARK:- Network Functions
    func downloadAllEvents() {
        let eventsRequest = EventsRequest(page: currentRequestPage)
        let publisher = apiClient.send(request: eventsRequest)
        
        publisher
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] (error) in
                guard let self = self else {
                    return
                }
                
                switch error {
                case .failure(let error):
                    self.handle(networkError: error)
                case .finished:
                    self.currentRequestPage += 1
                }
            }) { [weak self] (events) in
                guard let self = self else {
                    return
                }
                
                self.model.save(events: events)
            }
            .store(in: &cancellables)
    }
    
    func image(at indexPath: IndexPath) -> UIImage? {
        guard let event = model.event(at: indexPath), let imageURL = event.image else {
            return nil
        }
                
        if let image = model.image(for: imageURL as NSString) {
            return image
        }
        
        downloadImage(at: indexPath)
        
        return nil
    }
    
    private func downloadImage(at indexPath: IndexPath) {
        guard let event = model.event(at: indexPath), let imageURLString = event.image else {
            return
        }
        
        guard let imageURL = URL(string: imageURLString) else {
            return
        }
        
        let imageRequest = ImageRequest(url: imageURL)
        let publisher = apiClient.send(request: imageRequest)
        
        let backgroundQueue = DispatchQueue.global(qos: .default)
        
        publisher
        .receive(on: backgroundQueue)
        .tryMap { data -> UIImage in
            if let image = UIImage(data: data) {
                return image
            }
            
            throw NetworkError.failedToParseImageData(data)
        }
        .sink(receiveCompletion: { (result) in
            
        }, receiveValue: { [weak self] (image) in
            guard let self = self else {
                return
            }
            
            let key = imageURLString as NSString
            self.model.add(image: image, for: key)
        })
        .store(in: &cancellables)
    }
    
    private func handle(networkError: NetworkError) {
        
    }
}
