//
//  DataPersistenceManager.swift
//  NetflixApp
//
//  Created by Enes Sancar on 17.07.2023.
//

import UIKit
import CoreData

final class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    private init() {}
    
    func downloadMovieWith(model: Movie, completion: @escaping(Result<Void, CustomError>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let item = MovieItem(context: context)
        
        item.id = Int32(model.id)
        item.originalTitle = model._originalTitle
        item.originalName = model.originalName
        item.overview = model._overview
        item.mediaType = model.mediaType
        item.posterPath = model._posterPath
        item.releaseDate = model.releaseDate
        item.voteCount = Int64(model._voteCount)
        item.voteAverage = model._voteAverage
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(.failedToSaveData))
        }
    }
    
    func fetchingMoviesFromDatabase(completion: @escaping(Result<[MovieItem], CustomError>) -> ()) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MovieItem>
        request = MovieItem.fetchRequest()
        
        do {
            let movies = try context.fetch(request)
            completion(.success(movies))
        } catch {
            completion(.failure(.failedToFetchData))
        }
    }
    
    func deleteTitleWith(model: MovieItem, completion: @escaping(Result<Void, CustomError>) -> ()) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(.failedToDeleteData))
        }
    }
}
