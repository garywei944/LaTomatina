import GameKit
var manager = ManagerClass()
enum KEGSManagerState {
    case Idle
    case Searching
    case Connected
}
class ManagerClass: NSObject, GKLocalPlayerListener, GKMatchDelegate {
    var state:KEGSManagerState = .Idle
    var currentMatch: GKMatch?
    var messages:[(player: GKPlayer, message: String)] = []
    typealias CompletionBlock = (Error?) -> Void
    var isAuthenticated: Bool {
        return GKLocalPlayer.local.isAuthenticated
    }
    var viewController: UIViewController!
    var notificationShown:Bool = false
    var mapGeneratorData:Int = 0
    var needGenerateMap:Bool = false
    var playerMapData:[(player: GKPlayer, num: Int)] = []
    var playerAppData:[(player: GKPlayer, id: [Int])] = []
    
    var playerLocations:[(x: Int, z: Int)] = []
    var playerReady:[(player: GKPlayer, rd: Bool)] = []
    var myLocation:(x: Int, z: Int) = (x: 0, z: 0)
    
    func authorize(completionHandler: @escaping (()->()),
                   errorHandler: @escaping (()->()),
                   recoverHandler: @escaping (()->())) {
        if(isAuthenticated == true) {
            completionHandler()
            return
        }
        GKLocalPlayer.local.authenticateHandler = { gameCenterVC, error in
            if(self.isAuthenticated == true) {
                GKLocalPlayer.local.register(self)
                completionHandler()
            }else if let vc = gameCenterVC {
                self.viewController.present(vc, animated: true)
                recoverHandler()
            }else{
                recoverHandler()
                errorHandler()
            }
        }
    }
    func search(completionHandler: @escaping (()->()),
                errorHandler: @escaping (()->())) {
        if(self.isAuthenticated == false) {
            errorHandler()
            return
        }
        state = .Searching
        let request = GKMatchRequest()
        request.defaultNumberOfPlayers = 5
        request.minPlayers = 2
        request.maxPlayers = 10
        request.playerGroup = 0
        request.playerAttributes = 0xFFFFFFFF
        request.recipients = [GKLocalPlayer.local]
        request.inviteMessage = "Join La Tomatina!"
        GKMatchmaker.shared().findMatch(for: request, withCompletionHandler: {
            match, error in
            if let m = match {
                self.state = .Connected
                self.currentMatch = m
                m.delegate = self
                completionHandler()
            }else{
                self.state = .Idle
                errorHandler()
            }
        })
    }
    
    func cancelRequest() {
        GKMatchmaker.shared().cancel()
    }
    func send(message: String, reliable: Bool = false) {
        if(self.state == .Connected) {
            if let match = currentMatch {
                let data: Data = message.data(using: .utf8)!
                var mode: GKMatch.SendDataMode = .unreliable
                if(reliable == true) {
                    mode = GKMatch.SendDataMode.reliable
                }
                do{ try match.sendData(toAllPlayers: data, with: mode)
                }catch{ }
            }
        }
    }
    func send(to p: GKPlayer, message: String, reliable: Bool = false) {
        if(self.state == .Connected) {
            if let match = currentMatch {
                let data: Data = message.data(using: .utf8)!
                var mode: GKMatch.SendDataMode = .unreliable
                if(reliable == true) {
                    mode = GKMatch.SendDataMode.reliable
                }
                do{ try match.send(data, to: [p], dataMode: mode)
                }catch{ }
            }
        }
    }
    func match(_ match: GKMatch, didReceive data: Data,
               fromRemotePlayer player: GKPlayer) {
        let message = String(decoding: data, as: UTF8.self)
        self.messages.append((player: player, message: message))
    }
    func getMessages()->([(player: GKPlayer, message: String)]) {
        var result: [(player: GKPlayer, message: String)] = []
        while(messages.count > 0) {
            result.append(messages.remove(at: 0))
        }
        messages.removeAll()
        return(result)
    }
}
