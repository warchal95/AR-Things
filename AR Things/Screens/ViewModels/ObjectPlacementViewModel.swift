//
//  ObjectPlacementViewModel.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import ARKit

final class ObjectPlacementViewModel {    

    /// THe url for world map file destination
    private let fileURL: URL = {
        guard let documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            fatalError("Document Directory couldn't been fetched")
        }
        return documentDirectory.appendingPathComponent("WorldMapName")
    }()
    
    /// World map of Augumented reality
    var worldMap: ARWorldMap? {
        guard
            let mapData = try? Data(contentsOf: fileURL),
            let unarchivedObject = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [ARWorldMap.classForKeyedUnarchiver()], from: mapData),
            let worldMap = unarchivedObject as? ARWorldMap
        else {
            return nil
        }
        return worldMap
    }
    
    /// Saves world map
    ///
    /// - Parameter session: Session that is used to extract world map
    func saveWorldMap(forSession session: ARSession) {
        worldMapDataForSession(session) { [unowned self] data in
            guard let data = data else { return }
            try? data.write(to: self.fileURL)
        }
    }
    
    /// Sends world map to peers
    ///
    /// - Parameters:
    ///   - session: AR session used to fetch world map
    ///   - p2pSession: P2P session object
    func sendWorldMapToPeers(session: ARSession, p2pSession: P2PSession) {
        worldMapDataForSession(session) { (data) in
            guard let data = data else { return }
            p2pSession.send(data)
        }
    }
}

extension ObjectPlacementViewModel {
    
    private func worldMapDataForSession(_ session: ARSession, completion: @escaping (Data?) -> Void) {
        session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap else {
                completion(nil)
                return
            }
            completion(try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true))
        }
    }
}
